//
//  BookmarkWebpageViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 12.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarkWebpageViewController.h"
#import "BookmarkFolderNameTableViewCell.h"
#import "BookmarkFolderFolderTableViewCell.h"
#import "BookmarkFolderListViewController.h"
@interface BookmarkWebpageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

-(void)cancelAction:(id)sender;
-(void)saveAction:(id)sender;

@property(strong,nonatomic)UIBarButtonItem* cancelButton;
@property(strong,nonatomic)UIBarButtonItem* saveButton;
@end

typedef enum
{
    WebpageRowsTitle,
    WebpageRowsURL,
    WebpageRowsCount
}WebpageRows;

typedef enum
{
    SectionWebpage,
    SectionFolder,
    SectionCount
}Section;

@implementation BookmarkWebpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.type == BookmarkWebpageViewControllerAlone)
    {
        //BOOKMARK_ADD_SAVE
        self.cancelButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"BOOKMARK_ADD_CANCEL", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        self.saveButton =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"BOOKMARK_ADD_SAVE", @"") style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
        
        self.navigationItem.title = NSLocalizedString(@"BOOKMARK_HOME", @"");
        self.navigationItem.leftBarButtonItem = self.cancelButton;
        self.navigationItem.rightBarButtonItem = self.saveButton;
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        //It's a pop.
        
        if(self.webPage.title.length > 0 &&
           self.webPage.url.length > 0)
        {
            [self.delegate bookmarkWebPageViewControllerDidEndEdit:self shouldSave:YES];
        }
        else
        {
            [self.delegate bookmarkWebPageViewControllerDidEndEdit:self shouldSave:NO];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView - 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SectionCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return WebpageRowsCount;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SectionWebpage)
    {
        BookmarkFolderNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        cell.textField.delegate = self;
        if(indexPath.row == WebpageRowsTitle)
        {
            cell.textField.text = self.webPage.title;
            cell.textField.tag = WebpageRowsTitle;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [cell.textField becomeFirstResponder];
            });
        }
        else
        {
            cell.textField.text = self.webPage.url;
            cell.textField.tag = WebpageRowsURL;
        }
        
        return cell;
    }
    else
    {
        BookmarkFolderFolderTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
        [cell fillWithTitle:self.webPage.folder.name];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SectionFolder)
    {
        BookmarkFolderListViewController* listVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkFolderListViewController"];
        listVC.webPage = self.webPage;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

#pragma mark - UITextViewDelegate - 

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.type == BookmarkWebpageViewControllerViewController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self saveAction:nil];
    }
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if(textField.tag == WebpageRowsTitle)
    {
        self.webPage.title = newString;
    }
    else
    {
        self.webPage.url = newString;
    }
    
    
    self.saveButton.enabled = self.webPage.title.length >0 && self.webPage.url.length > 0;
    
    return YES;
}

#pragma mark - Private -

-(void)saveAction:(id)sender
{
    if(self.webPage.title.length >0 && self.webPage.url.length > 0)
    {
        [self.delegate bookmarkWebPageViewControllerDidEndEdit:self shouldSave:YES];
    }
}

-(void)cancelAction:(id)sender
{
    [self.delegate bookmarkWebPageViewControllerDidEndEdit:self shouldSave:NO];
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
