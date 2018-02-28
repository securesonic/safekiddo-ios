//
//  TabBrowserViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "TabBrowserViewController.h"
#import <FXBlurView/FXBlurView.h>
#import "WebBrowserViewController.h"
#import "TabBrowserTransitioning.h"
#import "WebpageCard+Ext.h"
#import "CoreData.h"
#import "BrowserCollectionViewCell.h"
#import "UIImageView+Util.h"
#import "Constants.h"
#import "CustomFlowLayout.h"
@interface TabBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, BrowserCollectionViewCellDelegate, WebBrowserViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic)TabBrowserTransitioning* transitioning;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong,nonatomic)NSMutableArray* tabsArray;
@property (strong,nonatomic)NSIndexPath* currentIndexPath;
@property (assign,nonatomic)BOOL openSettingsFlag;

@property (strong,nonatomic)NSURL* initialURL;

-(UIImage*)imageFromView:(UIView*)view;

-(void)handleOpenSettings;
@end

NSInteger const addTabOffset = 1;

@implementation TabBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* imageCopy = [self.backgroundImageView.image
                          blurredImageWithRadius:8.f
                          iterations:3
                          tintColor:[UIColor whiteColor]];
    
    self.backgroundImageView.image = imageCopy;

    self.tabsArray = [[[CoreDataManager sharedInstance] getEntitiesWithName:[WebpageCard description] sortDescriptior:@"dateAndTime" sortAscending:NO]mutableCopy];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleOpenSettings) name:kOpenSettingsNotification object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    WebBrowserViewController* viewController = (id)self.presentedViewController;
    UIImage* snapshot = [self imageFromView:viewController.view];
    
    [super dismissViewControllerAnimated:flag completion:^()
     {
         if(completion)
         {
             completion();
         }

         WebpageCard* card;

         if(self.currentIndexPath.item == self.tabsArray.count)
         {
             WebpageCard* newCard = [[CoreDataManager sharedInstance]createEntity:[WebpageCard description]];
             if( [[viewController currentURL].absoluteString rangeOfString:@"applewebdata://"].location == NSNotFound)
             {
                 newCard.title = [viewController currentTitle];
                 newCard.url = [viewController currentURL].absoluteString;
             }
             
             newCard.snapShot = snapshot;
             [self.tabsArray addObject:newCard];
             [self.collectionView insertItemsAtIndexPaths:@[self.currentIndexPath]];
             
             card = newCard;
         }
         else
         {
             card = self.tabsArray[self.currentIndexPath.item];
             card.snapShot = snapshot;
             if( [[viewController currentURL].absoluteString rangeOfString:@"applewebdata://"].location == NSNotFound)
             {
                 card.title = [viewController currentTitle];
                 card.url = [viewController currentURL].absoluteString;
             }
             else
             {
                 card.title = nil;
                 card.url = nil;
             }
             [self.collectionView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
         }
         card.viewController = viewController;
         [[CoreDataManager sharedInstance]saveContext];
     }];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionView -

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float itemWidth = 300;
    
    float screenWidth = collectionView.frame.size.width;
    
    int itemCount = floor(screenWidth / itemWidth);
    
    float marginSize = (screenWidth - (itemCount * itemWidth)) / (itemCount+1);
    
    return UIEdgeInsetsMake(10, marginSize, 10, marginSize);

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tabsArray.count + addTabOffset;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrowserCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(indexPath.row == self.tabsArray.count)
    {
        [cell fillWithTitle:NSLocalizedString(@"TAB_ADD_TITLE", @"") andImage:nil];
        cell.delegate = nil;
        //Add Tab cell
    }
    else
    {
        WebpageCard* card = self.tabsArray[indexPath.row];
        [cell fillWithTitle:card.title andImage:card.snapShot];
        cell.delegate = self;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrowserCollectionViewCell* cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
  
    
    
    
    CGPoint originInSuperView = [self.view convertPoint:[cell.snapshotImagView originOfSizeToFit] fromView:cell.snapshotImagView.superview];
    
//    originInSuperView.x+=60;
 //   originInSuperView.y+=30;
    CGRect rect = (CGRect){originInSuperView,cell.contentView.frame.size};
    self.transitioning = [[TabBrowserTransitioning alloc]initWithRectOfOriginCell:rect];
    
    WebBrowserViewController* webbrowserViewController;
    
    if(indexPath.row == self.tabsArray.count)
    {
        webbrowserViewController   = [self.storyboard instantiateViewControllerWithIdentifier:@"Browser"];
        if(self.initialURL)
        {
            webbrowserViewController.initialURL = self.initialURL;
            self.initialURL = nil;
        }
    }
    else
    {
        WebpageCard* card = self.tabsArray[indexPath.row];
        webbrowserViewController = (id)card.viewController;
        if(!webbrowserViewController)
        {
            webbrowserViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Browser"];
        }
        card.viewController = webbrowserViewController;
        webbrowserViewController.initialURL =  [NSURL URLWithString:card.url];
    }
    
    webbrowserViewController.delegate = self;
    
    webbrowserViewController.transitioningDelegate = self.transitioning;
    [self presentViewController:webbrowserViewController animated:YES completion:^{
       if(self.openSettingsFlag)
       {
           [webbrowserViewController openSettings];
           self.openSettingsFlag = NO;
       }
    }];
    self.currentIndexPath = indexPath;
}




#pragma mark - BrowserCollectionViewCellDelegate -

-(void)browserCellDelete:(BrowserCollectionViewCell *)cell
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    
    WebpageCard* card = self.tabsArray[indexPath.row];
    card.viewController = nil;
    [[CoreDataManager sharedInstance]deleteEntity:card];
    [[CoreDataManager sharedInstance] saveContext];
    
    [self.tabsArray removeObject:card];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - WebBrowserViewControllerDelegate -

-(void)webBrowserViewController:(WebBrowserViewController *)controller wantToOpenNewTabWitPage:(Webpage *)page
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.initialURL = [NSURL URLWithString:page.url];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.tabsArray.count inSection:0]];
    }];
}

#pragma mark - Private -

-(UIImage*)imageFromView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copied;
}

-(void)handleOpenSettings
{
    if(self.presentedViewController)
    {
        WebBrowserViewController* vc=(id) self.presentedViewController;
        [vc openSettings];
    }
    else
    {
        self.openSettingsFlag = YES;
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
