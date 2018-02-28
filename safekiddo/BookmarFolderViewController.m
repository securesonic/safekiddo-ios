//
//  BookmarFolderViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 09.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarFolderViewController.h"
#import "BookmarkFolderNameTableViewCell.h"
#import "BookmarkFolderFolderTableViewCell.h"
#import "BookmarkFolderListViewController.h"
#import "Appearance.h"
@interface BookmarFolderViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BookmarFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [Appearance tintColor];
    self.navigationItem.title = NSLocalizedString(@"BOOKMARK_EDIT_FLD", @"");
    // Do any additional setup after loading the view.
    
    self.doneButton.enabled = (self.folder.name.length >0);
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
        [self.delegate bookmarFolderViewControllerDidEndEdit:self];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView -

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        BookmarkFolderNameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        
        cell.textField.delegate = self;
        cell.textField.text = self.folder.name;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.textField becomeFirstResponder];
        });
        return cell;
    }
    else
    {
        BookmarkFolderFolderTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell"];
        [cell fillWithTitle:self.folder.parentFolder.name];

        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        BookmarkFolderListViewController* listVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkFolderListViewController"];
        listVC.folder = self.folder;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

#pragma mark - UITextField -


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.folder.name = newString;
    
     self.doneButton.enabled = (self.folder.name.length >0);
    return YES;
}

#pragma mark - UINavigationViewController -



#pragma mark - IBActions -

- (IBAction)doneAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
