//
//  SelectChildViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SelectChildViewController.h"
#import "NetworkManager+Children.h"
#import "SelectChildTableViewCell.h"
#import "Child.h"
#import "Utilities.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Appearance.h"

@interface SelectChildViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSArray* childsDataSource;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noAccountLabel;
@property (weak, nonatomic) IBOutlet UITextView *createAccountLabel;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;


@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *marginContraintsArray;



-(CGFloat)heightForRow;
-(CGFloat)calculateTableViewHeight;
-(void)childSelectedAction:(id)sender;
-(void)setChildSelectedButtonVisible:(BOOL)isVisible;

@end

@implementation SelectChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.createAccountLabel.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    
    self.tableViewHeightConstraint.constant = 0.f;
    
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
        for(NSLayoutConstraint* constraint in self.marginContraintsArray)
        {
            constraint.constant = constraint.constant/2.f;
        }
    }
    
    self.titleLabel.text = NSLocalizedString(@"CHILD_TXT1", @"");
    self.noAccountLabel.text = NSLocalizedString(@"CHILD_TXT2", @"");
    self.createAccountLabel.text = NSLocalizedString(@"CHILD_TXT3", @"");
    
    [self refreshChildren:nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"CHILD_BACK_TXT", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if(self.type == SelectChildViewControllerTypeSettings)
    {
        self.tableView.backgroundColor = [Appearance tintColor];
        self.navigationItem.title = NSLocalizedString(@"SETTINGS_ASSING_ACCOUNT_TITLE", @"");
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


#pragma mark - IBActions - 

- (IBAction)refreshChildren:(id)sender
{
    [self setChildSelectedButtonVisible:NO];
    if(self.childsDataSource.count > 0)
    {
        self.childsDataSource = [NSArray array];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkManager childsWithSuccessBlock:^(ChildsResponse * response)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.childsDataSource = response.childs;
         [self.tableView beginUpdates];
         
         [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
         
         int index =0;
         if(self.type == SelectChildViewControllerTypeSettings)
         {
             for(Child* child in self.childsDataSource)
             {
                 if([child.uuid isEqualToString:[Utilities retrieveChildUUID]])
                 {
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                         
                     });
                 }
                 index++;
             }
         }
         
         [self.tableView endUpdates];
         self.tableViewHeightConstraint.constant = [self calculateTableViewHeight];
         [UIView animateWithDuration:0.3 animations:^{
             [self.view layoutIfNeeded];
         }];
         
     } failureBlock:^(NSError * error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];         
     }];
}

#pragma mark - Private -

-(void)setChildSelectedButtonVisible:(BOOL)isVisible
{
    if(isVisible)
    {
        if(self.navigationItem.rightBarButtonItem == nil)
        {
            if(self.type == SelectChildViewControllerTypeAuthenticate)
            {
                [self.navigationItem
                 setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"CHILD_BTN1_TXT", @"")
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(childSelectedAction:)] animated:YES];
            }
            else
            {
                [self.navigationItem
                 setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"CHILD_BTN2_TXT", @"")
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(childSelectedAction:)] animated:YES];
            }
        }
    }
    else
    {
        if(self.navigationItem.rightBarButtonItem)
        {
            [self.navigationItem setRightBarButtonItem:nil animated:YES];
        }
    }
}

-(void)childSelectedAction:(id)sender
{
    Child* currentChild = self.childsDataSource[[self.tableView indexPathForSelectedRow].row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkManager pairDevice:[Utilities uuid]
                     withChild:currentChild.uuid
               usingDeviceName:[Utilities deviceName]
              withSuccessBlock:^(PairChildResponse* response)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(response.success.boolValue)
        {
            [Utilities storeChildUUID:currentChild.uuid];
            [Utilities storeChildName:currentChild.name];
            if(self.type == SelectChildViewControllerTypeAuthenticate)
            {
                [self performSegueWithIdentifier:@"showSegue" sender:nil];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
                  failureBlock:^(NSError * error)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
    

}

-(CGFloat)heightForRow
{
    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
    {
        return 44.f;
    }
    else
    {
        return 60.f;
    }
}

-(CGFloat)calculateTableViewHeight
{
    
    CGFloat constraintBackup = self.tableViewHeightConstraint.constant;
    
    self.tableViewHeightConstraint.constant = 0.f;
    [self.view layoutIfNeeded];
    
    CGFloat freeSpace = self.view.frame.size.height -( self.createAccountLabel.frame.size.height + self.createAccountLabel.frame.origin.y);
    
    NSInteger rowCount = MIN(floor(freeSpace / [self heightForRow]),self.childsDataSource.count);

    self.tableViewHeightConstraint.constant = constraintBackup;
    [self.view layoutIfNeeded];
    
    return rowCount * [self heightForRow];
}

#pragma  mark - UITableView - 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.type == SelectChildViewControllerTypeSettings)
    {
        return 30.f;
    }
    else
    {
        return 0.f;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.childsDataSource.count)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.childsDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectChildTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell fillWithChild:self.childsDataSource[indexPath.row]];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRow];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setChildSelectedButtonVisible:YES];
}

@end
