//
//  SegmentViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 30.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SegmentViewController.h"
#import "HistoryViewController.h"
#import "BookmarkViewController.h"
#import "CoreData.h"
#import "BookmarkTableViewCell.h"
#import "Appearance.h"
#import "CoreDataManager+SafeKiddo.h"
@interface SegmentViewController ()<HistoryViewControllerDelegate,BookmarkViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

@property (assign,nonatomic) SegmentViewControllerSegment currentSegment;



@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.closeButton setTitle:NSLocalizedString(@"GENERAL_DISMISS",@"")];
    
    [self.segmentedControl removeAllSegments];
    
   // [self.segmentedControl insertSegmentWithTitle:[self.class stringForSegmentedViewControllerSegment:SegmentViewControllerSegmentHistory] atIndex:SegmentViewControllerSegmentHistory animated:NO];
    
    [self.segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"icon_history"] atIndex:SegmentViewControllerSegmentHistory animated:NO];
    [self.segmentedControl insertSegmentWithTitle:[self.class stringForSegmentedViewControllerSegment:SegmentViewControllerSegmentBookmark] atIndex:SegmentViewControllerSegmentBookmark animated:NO];
    
    [self.segmentedControl setSelectedSegmentIndex:SegmentViewControllerSegmentHistory];
    
    [self segmentedControlValueChangedAction:nil];
    
    self.view.backgroundColor = [Appearance tintColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[CoreDataManager sharedInstance]discardChanges];
}

#pragma mark - IBActions
- (IBAction)closeAction:(id)sender
{
    [self.delegate segmentedViewControllerDidTapToDismiss:self];
}

- (IBAction)segmentedControlValueChangedAction:(id)sender
{
    self.currentSegment = (int)self.segmentedControl.selectedSegmentIndex;
    
    UIViewController* rootViewController;
    UINavigationController* navController;
    
    if(self.currentSegment == SegmentViewControllerSegmentHistory)
    {
        rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:[HistoryViewController description]];
        ((HistoryViewController*)rootViewController).delegate = self;
        navController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
        [navController setNavigationBarHidden:YES];
    }
    else
    {
        rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:[BookmarkViewController description]];
        
        id rootFolder =[[CoreDataManager sharedInstance]rootFolder];
        ((BookmarkViewController*)rootViewController).folder = rootFolder;
        ((BookmarkViewController*)rootViewController).delegate = self;
        
                navController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    }
    
    
   
    navController.navigationBar.translucent = NO;
    navController.view.translatesAutoresizingMaskIntoConstraints = NO;
    void(^addConstraints)(void) = ^
    {
        NSMutableArray* constraints = [NSMutableArray arrayWithArray:
                                       [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"view":navController.view,
                                                                                         @"tlb":self.toolbar}]];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tlb]-0-[view]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"view":navController.view,
                                                                                           @"tlb":self.toolbar}]];
    
        [self.view addConstraints:constraints];
    };
    
    
    if(self.childViewControllers.count>0)
    {
        UIViewController* oldViewController = self.childViewControllers[0];
       // [oldViewController willMoveToParentViewController:nil];
       // [navController willMoveToParentViewController:self];
        [self addChildViewController:navController];
        [self.view addSubview:navController.view];
            addConstraints();
        [self.view layoutIfNeeded];
        
        [self transitionFromViewController:oldViewController toViewController:navController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^(){

            
        } completion:^(BOOL finished) {
           
            [oldViewController removeFromParentViewController];
            [navController didMoveToParentViewController:self];
            [oldViewController.view removeFromSuperview];
            
            
            
        }];
    }
    else
    {
        [navController willMoveToParentViewController:self];
        [self.view addSubview:navController.view];
        [self addChildViewController:navController];
        [navController didMoveToParentViewController:self];
            addConstraints();
    }
    
    
}


#pragma mark - Public -

+(NSString *)stringForSegmentedViewControllerSegment:(SegmentViewControllerSegment)segment
{
    switch (segment)
    {
        case SegmentViewControllerSegmentBookmark:
            return @"Zakładki";
        case SegmentViewControllerSegmentHistory:
            return @"Historia";
    }
}

#pragma mark - HistoryViewControllerDelegate -

-(void)historyViewController:(HistoryViewController *)historyViewController didSelectWebPage:(Webpage *)webpage
{
    [self.delegate segmentedViewController:self didSelectWebPage:webpage];
}

#pragma mark - BookmarkViewControllerDelegate -

-(void)bookmarViewController:(BookmarkViewController *)bookmarkViewController didSelectWebPage:(Webpage *)webpage
{
    [self.delegate segmentedViewController:self didSelectWebPage:webpage];
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
