//
//  BookmarkViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 30.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarkViewController.h"
#import "WebpageBookmark.h"
#import "BookmarkTableViewCell.h"
#import "BookmarkItem.h"
#import "BookmarFolderViewController.h"
#import "CoreData.h"
#import "BookmarkWebpageViewController.h"

@interface BookmarkViewController ()<UITableViewDataSource,UITableViewDelegate,BookmarFolderViewControllerDelegate,BookmarkWebpageViewControllerDelegate,BookmarkTableViewCellDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) UIBarButtonItem *editBarButton;
@property (strong, nonatomic) UIBarButtonItem *doneBarButton;
@property (strong, nonatomic) UIBarButtonItem *addFolderButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

-(void)editAction;
-(void)doneAction;
-(void)addFolderAction;

-(NSArray*)arrayFromFolder:(BookmarkFolder*)folder;

@property(strong,nonatomic)NSMutableArray* dataSource;

@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.folder.name;

    [self.closeButton setTitle:NSLocalizedString(@"GENERAL_DISMISS",@"")];
    
    self.editBarButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GENERAL_EDIT", @"") style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    self.doneBarButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GENERAL_DONE", @"") style:UIBarButtonItemStyleDone  target:self action:@selector(doneAction)];
    
    self.addFolderButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"BOOKMARK_ADD_FLD", @"") style:UIBarButtonItemStylePlain target:self action:@selector(addFolderAction)];

    [self.toolbar setItems:@[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],self.editBarButton] animated:NO];
    
    
    self.dataSource = [[self arrayFromFolder:self.folder]mutableCopy];
    
    if([self.navigationController.viewControllers count] > 1)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
   // self.dataSource = [NSMutableArray arrayWithArray:[self.folder.subFolders
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataSource = [[self arrayFromFolder:self.folder] mutableCopy];
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions -

- (IBAction)closeAction:(id)sender {
    [self.delegate bookmarViewControllerDismiss:self];
}

#pragma mark - UITableView -

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"GENERAL_DELETE", @"");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookmarkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    id<BookmarkItem> obj = [self.dataSource objectAtIndex:indexPath.row];
    
    if([obj isFolder])
    {
        cell.typeLabel.text = @"F";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.typeLabel.text = @"B";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.titleLabel.text = [obj title];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        id<BookmarkItem> obj = [self.dataSource objectAtIndex:indexPath.row];
        
        [[CoreDataManager sharedInstance]deleteEntity:obj];
        [self.dataSource removeObject:obj];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[CoreDataManager sharedInstance] saveContext];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     id<BookmarkItem> obj = [self.dataSource objectAtIndex:indexPath.row];
    
    if([obj isFolder])
    {
        UIViewController* vc;
        if(self.tableView.isEditing)
        {
            BookmarFolderViewController* bookmarkFolderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarFolderViewController"];
            bookmarkFolderVC.folder = obj;
            bookmarkFolderVC.delegate = self;
            vc = bookmarkFolderVC;
        }
        else
        {
            BookmarkViewController* bookmarkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkViewController"];
            bookmarkVC.folder = obj;
            bookmarkVC.delegate = self.delegate;
            vc= bookmarkVC;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if(self.tableView.isEditing)
        {
            BookmarkWebpageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkWebpageViewController"];
            vc.delegate = self;
            vc.webPage = obj;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [self.delegate bookmarViewController:self didSelectWebPage:obj];
        }
    }
}

#pragma mark - BookmarkWebpageViewControllerDelegate -

-(void)bookmarkWebPageViewControllerDidEndEdit:(BookmarkWebpageViewController *)bookmarkViewController shouldSave:(BOOL)shouldSave
{
    if(shouldSave)
    {
        [[CoreDataManager sharedInstance]saveContext];
    }
    else
    {
        [[CoreDataManager sharedInstance] discardChanges];
    }
}

#pragma mark - BookmarFolderViewControllerDelegate -

-(void)bookmarFolderViewControllerDidEndEdit:(BookmarFolderViewController *)bookmarkViewController
{
    if(bookmarkViewController.folder.name.length > 0)
    {
        [[CoreDataManager sharedInstance]saveContext];
    }
    else
    {
        [[CoreDataManager sharedInstance] discardChanges];
    }
}

#pragma mark - BookmarkTableViewCellDelegate -

-(void)bookmarkTableViewCellDidLongTap:(BookmarkTableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    id<BookmarkItem> obj = [self.dataSource objectAtIndex:indexPath.row];
   
    
    if(![obj isFolder] && !self.tableView.isEditing)
    {
        WebpageBookmark* webpage = obj;
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:webpage.url
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"NEW_TAB_CANCEL", @"")
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:NSLocalizedString(@"NEW_TAB_OPEN", @"")
                                      ,NSLocalizedString(@"NEW_TAB_OPEN_IN_NEW", @""), nil];
        
        actionSheet.tag = indexPath.row;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate - 

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WebpageBookmark* webpage = self.dataSource[actionSheet.tag];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(buttonIndex == 0)
        {
            [self.delegate bookmarViewController:self didSelectWebPage:webpage];
        }
        else if(buttonIndex ==1)
        {
            [self.delegate bookmarViewController:self didSelectWebPageInNewTab:webpage];
        }
    });
}

#pragma mark - Private -

-(void)editAction
{
    [self.tableView setEditing:YES animated:YES];
    [self.toolbar setItems:@[self.addFolderButton, [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],self.doneBarButton] animated:YES];
}

-(void)doneAction
{
    [self.tableView setEditing:NO animated:YES];
    [self.toolbar setItems:@[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],self.editBarButton] animated:YES];
}

-(void)addFolderAction
{
    BookmarFolderViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarFolderViewController"];
    vc.delegate = self;
    vc.folder = [[CoreDataManager sharedInstance] createEntity:[BookmarkFolder description]];
    vc.folder.parentFolder = self.folder;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSArray*)arrayFromFolder:(BookmarkFolder*)folder
{
    NSArray* folderArray =[[folder.subFolders allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

        BookmarkFolder* f1 = obj1;
        BookmarkFolder* f2 = obj2;
        
        return [f1.dateAndTime compare:f2.dateAndTime];
    }];
    
    NSArray* pageArray = [[folder.webpages allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
        WebpageBookmark* wp1 = obj1;
        WebpageBookmark* wp2 = obj2;
        
         return [wp1.dateAndTime compare:wp2.dateAndTime];
    }];
    
    return [folderArray arrayByAddingObjectsFromArray:pageArray];
}

@end
