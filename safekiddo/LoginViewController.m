//
//  LoginViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 12.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticateTableViewCell.h"
#import "NetworkManager+Authentication.h"
#import "NetworkManager+Children.h"
#import "Utilities.h"
#import <MBProgressHUD/MBProgressHUD.h>
#define kNumberOfRows 2

#define kEMailRowIndex 0
#define kPasswordRowIndex 1

#define kKeyboardMargin 5.f

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

-(AuthenticateTableViewCell*)eMailCell;
-(AuthenticateTableViewCell*)passwordCell;

-(void)backButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (assign,nonatomic) CGFloat baseVerticalSpaceAlignment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceAlignment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;


-(void)keyboardWillShow:(NSNotification*)notification;
-(void)keyboardWillHide:(NSNotification*)notification;

@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *joinNowButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"LOGIN_BTN1_TXT", @"") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"LOGIN_BACK_TXT", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
    

    [self.forgotPasswordButton setTitle:NSLocalizedString(@"LOGIN_BTN_FORGOT_PASS_TXT", @"") forState:UIControlStateNormal];
    [self.joinNowButton setTitle:NSLocalizedString(@"LOGIN_BTN_JOIN_NOW_TXT", @"") forState:UIControlStateNormal];
    
    self.baseVerticalSpaceAlignment = self.verticalSpaceAlignment.constant;

    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
    {
        self.tableViewHeightConstraint.constant = 88.f;
    }
    else
    {
        self.tableViewHeightConstraint.constant = 120.f;
    }
    
    [self.tableView reloadData];
    
    [self eMailCell].entryTextField.text = [Utilities retrieveUsername];
    

    if(self.preLoadedPassword && self.preLoadedPassword)
    {
        self.eMailCell.entryTextField.text = self.preLoadedLogin;
        self.passwordCell.entryTextField.text = self.preLoadedPassword;
        [self loginAction:nil];
        
    }
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private - 
-(AuthenticateTableViewCell*)eMailCell
{
    return (id)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kEMailRowIndex inSection:0]];
}

-(AuthenticateTableViewCell*)passwordCell
{
    return (id)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kPasswordRowIndex inSection:0]];
}

-(void)backButtonAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    if (IS_IPHONE)
    {
        
        
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        
        CGFloat offset =  (self.view.frame.size.height - keyboardSize.height) - (self.loginButton.frame.size.height+ self.loginButton.frame.origin.y + kKeyboardMargin);
        
        
        CGFloat newVerticalAlignment = MIN(self.verticalSpaceAlignment.constant + offset,self.baseVerticalSpaceAlignment);
        
        self.verticalSpaceAlignment.constant =  newVerticalAlignment;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }

}

-(void)keyboardWillHide:(NSNotification*)notification
{
    if(IS_IPHONE)
    {
        self.verticalSpaceAlignment.constant = self.baseVerticalSpaceAlignment;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - UITableView - 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuthenticateTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (indexPath.row)
    {
        case kEMailRowIndex:
        {
            cell.entryTextField.placeholder = NSLocalizedString(@"LOGIN_TXT1", @"");
            cell.iconImageView.image = [UIImage imageNamed:@"icon-envelope"];
            cell.entryTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.entryTextField.returnKeyType = UIReturnKeyNext;
            cell.entryTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.entryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            cell.entryTextField.delegate = self;
            cell.entryTextField.secureTextEntry = NO;
        }
            break;
        case kPasswordRowIndex:
        {
            cell.entryTextField.placeholder = NSLocalizedString(@"LOGIN_TXT2", @"");
            cell.iconImageView.image = [UIImage imageNamed:@"icon-lock"];
            cell.entryTextField.returnKeyType = UIReturnKeyJoin;
            cell.entryTextField.delegate = self;
            cell.entryTextField.secureTextEntry = YES;
            
        }
            break;
    }
    
    return cell;
    
}

#pragma mark - UITextFieldDelegate -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [self eMailCell].entryTextField)
    {
        [[self passwordCell].entryTextField becomeFirstResponder];
    }else if(textField == [self passwordCell].entryTextField)
    {
        [textField resignFirstResponder];
        [self loginAction:nil];
    }
    
    return NO;
}

#pragma mark - IBActions - 

- (IBAction)loginAction:(id)sender
{
    
    
#if defined(DEBUG)
    
#if defined(DEV)
    [self eMailCell].entryTextField.text = @"jdlugosz@test.com";
    [self passwordCell].entryTextField.text = @"jdlugosz";
#else
    [self eMailCell].entryTextField.text = @"dlugosz.jakub@gmail.com";
    [self passwordCell].entryTextField.text = @"Repp#R11";
#endif
    
#endif
     
    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetworkManager loginWithLogin:[self eMailCell].entryTextField.text
                          password:[self passwordCell].entryTextField.text
                      successBlock:^(LoginResponse *response)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if(response.success.boolValue)
         {
             NSString* childUUID = [Utilities retrieveChildUUID];
             if(childUUID)
             {
                 [NetworkManager pairDevice:[Utilities uuid] withChild:childUUID usingDeviceName:[Utilities deviceName] withSuccessBlock:^(PairChildResponse * response)
                 {

                 } failureBlock:nil];
             }
             
             [Utilities storeProfilePin:response.pin_ios];
             [Utilities storeUsername:[self eMailCell].entryTextField.text];
             [Utilities storePassword:[self passwordCell].entryTextField.text];
             [Utilities storePin:response.pin];
             
             
             [self performSegueWithIdentifier:@"showSegue" sender:self];
         }
         else
         {
                 [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"LOGIN_ERROR", @"") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
         }
     }
                      failureBlock:^(NSError *error)
     {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}
- (IBAction)forgotPasswordAction:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://my.safekiddo.com/password_reset"]];
}

- (IBAction)joinNowAction:(id)sender
{
  
    UIViewController* controlerReferenceCopy = self.presentingViewController;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        UIViewController* createUserViewController = [[UIStoryboard storyboardWithName:@"Register" bundle:nil]instantiateInitialViewController];
        
        if(IS_IPAD)
        {
            [createUserViewController setModalPresentationStyle:UIModalPresentationFormSheet];
            [createUserViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        }
        
        [controlerReferenceCopy presentViewController:createUserViewController animated:YES completion:nil];
    }];
}
@end
