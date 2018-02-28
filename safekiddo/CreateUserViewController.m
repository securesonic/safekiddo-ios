//
//  CreateUserViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "CreateUserViewController.h"
#import "Utilities.h"
#import "AuthenticateTableViewCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "Appearance.h"
#import "CreateProfileViewController.h"
#import "RegisterRequestData.h"

#define kRowHeight ((IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 44.f : 60.f);
#define kRowCount         5

#define kEMailRowIndex    0
#define kPasswordRowIndex 1
#define kNameRowIndex     2
#define kLastNameRowIndex 3
#define kPINRowIndex      4

@interface CreateUserViewController () <UITableViewDataSource,
                                        UITableViewDelegate, UITextFieldDelegate,
                                        TTTAttributedLabelDelegate>

- (void)backButtonAction:(id)sender;

@property(strong, nonatomic) AuthenticateTableViewCell *emailCell;
@property(strong, nonatomic) AuthenticateTableViewCell *passwordCell;
@property(strong, nonatomic) AuthenticateTableViewCell *nameCell;
@property(strong, nonatomic) AuthenticateTableViewCell *lastNameCell;
@property(strong, nonatomic) AuthenticateTableViewCell *pinCell;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property(weak, nonatomic) IBOutlet UILabel *headerLabel;
@property(weak, nonatomic) IBOutlet UIButton *nextButton;
@property(weak, nonatomic) IBOutlet TTTAttributedLabel *termsAndPolicyLabel;
@property(weak, nonatomic) IBOutlet UISwitch *termsAndPolicySwitch;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *shareDataLabel;
@property (weak, nonatomic) IBOutlet UISwitch *shareDataSwitch;

@property(strong,nonatomic) CreateProfileViewController* createProfileViewController;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

- (BOOL)shouldEditPin:(NSString *)newPin;
- (IBAction)nextAction:(id)sender;


@property(strong,nonatomic) RegisterRequestData* requestData;

@end

@implementation CreateUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.scrollEnabled = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:NSLocalizedString(@"REGISTER_BTN1_TXT", @"")
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(backButtonAction:)];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:NSLocalizedString(@"REGISTER_BACK", @"")
                style:UIBarButtonItemStylePlain
               target:nil
               action:nil];

    self.tableViewHeightConstraint.constant = kRowCount * kRowHeight;
    // Do any additional setup after loading the view.

    [self.nextButton setTitle:NSLocalizedString(@"REGISTER_BTN2_TXT", @"")
                     forState:UIControlStateNormal];

    self.headerLabel.text = NSLocalizedString(@"REGISTER_TXT", @"");

    NSString *termsAndPolicyText = NSLocalizedString(@"REGISTER_TERMS_AND_REGULATIONS", @"");
    self.termsAndPolicyLabel.text = termsAndPolicyText;

    self.termsAndPolicyLabel.linkAttributes = @{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:15],
        NSUnderlineStyleAttributeName : @(1)
    };

    self.termsAndPolicyLabel.activeLinkAttributes = @{
        NSForegroundColorAttributeName : [Appearance orangeColor],
        NSFontAttributeName : [UIFont systemFontOfSize:15],
        NSUnderlineStyleAttributeName : @(1)
    };

    [self.termsAndPolicyLabel
        addLinkToURL:
            [NSURL URLWithString:@"https://www.safekiddo.com/mobile/privacy"]
           withRange:[termsAndPolicyText
                         rangeOfString:NSLocalizedString(
                                           @"REGISTER_TERMS_KEYWORD", @"")]];

    [self.termsAndPolicyLabel
        addLinkToURL:[NSURL
                         URLWithString:@"https://www.safekiddo.com/mobile/terms"]
           withRange:[termsAndPolicyText
                         rangeOfString:NSLocalizedString(
                                           @"REGISTER_POLICY_KEYWORD", @"")]];
    
    [self.shareDataLabel setText:NSLocalizedString(@"REGISTER_SHARE_DATA", @"")];
    
    
    self.requestData = [RegisterRequestData new];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWillHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions -

- (IBAction)nextAction:(id)sender
{
    self.requestData.shareData = self.shareDataSwitch.isOn;
    
    NSString *message;
    if (![self.requestData validateEmail])
    {
        message = NSLocalizedString(@"REGISTER_VALIDATE_EMAIL", @"");
    }
    else if (![self.requestData validatePassword])
    {
        message = NSLocalizedString(@"REGISTER_VALIDATE_PASSWORD", @"");
    }
    else if (![self.requestData validateFirstName])
    {
        message = NSLocalizedString(@"REGISTER_VALIDATE_FIRSTNAME", @"");
    }
    else if (![self.requestData validatePin])
    {
        message = NSLocalizedString(@"REGISTER_VALIDATE_PIN", @"");
    }else if(!self.termsAndPolicySwitch.isOn)
    {
        message = NSLocalizedString(@"REGISTER_VALIDATE_ACEPT_TERMS", @"");
    }

    if (message)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"REGISTER_VALIDATION_TITLE", @"")
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"REGISTER_VALIDATION_OK", @"")
                          otherButtonTitles:nil] show];
    }
    else
    {
        CreateProfileViewController *cpvc;
        if (self.createProfileViewController)
        {
            cpvc = self.createProfileViewController;
        }
        else
        {
            cpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateProfileViewController"];
            cpvc.requestData = self.requestData;
        }
        [self.navigationController pushViewController:cpvc animated:YES];
    }
}

#pragma mark - Private -

- (void)backButtonAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (BOOL)shouldEditPin:(NSString *)newPin
{
    if (newPin.length <= 8)
    {
        NSCharacterSet *nonNumbers =
            [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return [newPin rangeOfCharacterFromSet:nonNumbers].location == NSNotFound;
    }
    return NO;
}

#pragma mark - UITableView -

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuthenticateTableViewCell *cell = nil;

    switch (indexPath.row)
    {
    case kEMailRowIndex:
    {
        if (self.emailCell)
        {
            cell = self.emailCell;
        }
        else
        {
            cell = (AuthenticateTableViewCell *)
                [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell.entryTextField.placeholder = NSLocalizedString(@"REGISTER_TXT1", @"");
            cell.iconImageView.image = [UIImage imageNamed:@"icon-envelope"];
            cell.entryTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.entryTextField.returnKeyType = UIReturnKeyNext;
            cell.entryTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.entryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            cell.entryTextField.delegate = self;
            cell.entryTextField.secureTextEntry = NO;
            self.emailCell = cell;
        }
    }
    break;
    case kPasswordRowIndex:
    {
        if (self.passwordCell)
        {
            cell = self.passwordCell;
        }
        else
        {
            cell = (AuthenticateTableViewCell *)
                [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell.entryTextField.placeholder = NSLocalizedString(@"REGISTER_TXT2", @"");
            cell.iconImageView.image = [UIImage imageNamed:@"icon-lock"];
            cell.entryTextField.keyboardType = UIKeyboardTypeAlphabet;
            cell.entryTextField.returnKeyType = UIReturnKeyNext;
            cell.entryTextField.delegate = self;
            cell.entryTextField.secureTextEntry = YES;
            self.passwordCell = cell;
        }
    }
    break;

    case kNameRowIndex:
    {
        if (self.nameCell)
        {
            return self.nameCell;
        }
        else
        {
            cell = (AuthenticateTableViewCell *)
                [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell.entryTextField.placeholder = NSLocalizedString(@"REGISTER_TXT3", @"");
            cell.iconImageView.image = [UIImage imageNamed:@"icon-profile"];
            cell.entryTextField.keyboardType = UIKeyboardTypeAlphabet;
            cell.entryTextField.returnKeyType = UIReturnKeyNext;
            cell.entryTextField.delegate = self;
            cell.entryTextField.secureTextEntry = NO;
            self.nameCell = cell;
        }
    }
    break;
        case kLastNameRowIndex:
        {
            if (self.lastNameCell)
            {
                return self.lastNameCell;
            }
            else
            {
                cell = (AuthenticateTableViewCell *)
                [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
                cell.entryTextField.placeholder = NSLocalizedString(@"REGISTER_TXT5", @"");
                cell.iconImageView.image = [UIImage imageNamed:@"icon-profile"];
                cell.entryTextField.keyboardType = UIKeyboardTypeAlphabet;
                cell.entryTextField.returnKeyType = UIReturnKeyNext;
                cell.entryTextField.delegate = self;
                cell.entryTextField.secureTextEntry = NO;
                self.lastNameCell = cell;
            }
        }
            break;
            
            
    case kPINRowIndex:
    {
        if (self.pinCell)
        {
            return self.pinCell;
        }
        else
        {
            cell = (AuthenticateTableViewCell *)
                [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
            cell.entryTextField.placeholder = NSLocalizedString(@"REGISTER_TXT4", @"");
            cell.iconImageView.image = [UIImage imageNamed:@"icon-lock"];
            cell.entryTextField.keyboardType = UIKeyboardTypeAlphabet;
            cell.entryTextField.returnKeyType = UIReturnKeyDone;
            cell.entryTextField.delegate = self;
            cell.entryTextField.secureTextEntry = YES;
            self.pinCell = cell;
        }
    }
    break;
    default:
    {
        @throw [NSString stringWithFormat:@"Index %@ Not supported", indexPath];
    }
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return kRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

#pragma mark - UITextField -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailCell.entryTextField)
    {
        [self.passwordCell.entryTextField becomeFirstResponder];
    }
    else if (textField == self.passwordCell.entryTextField)
    {
        [self.nameCell.entryTextField becomeFirstResponder];
    }
    else if (textField == self.nameCell.entryTextField)
    {
        [self.pinCell.entryTextField becomeFirstResponder];
    }
    else if (textField == self.pinCell.entryTextField)
    {
        [self.pinCell.entryTextField resignFirstResponder];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string
{
    
    NSString* finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField == self.emailCell.entryTextField)
    {
        self.requestData.email = finalString;
    }else if (textField == self.passwordCell.entryTextField)
    {
        self.requestData.password = finalString;
    }else if(textField == self.nameCell.entryTextField)
    {
        self.requestData.firstName = finalString;
    }else if(textField == self.lastNameCell.entryTextField)
    {
        self.requestData.lastName = finalString;
    }else if (textField == self.pinCell.entryTextField)
    {
        BOOL shouldEdit = [self shouldEditPin:[textField.text
                                       stringByReplacingCharactersInRange:range
                                                               withString:string]];
        
        if(shouldEdit)
        {
            self.requestData.pin = finalString;
        }
        
        return shouldEdit;
    }
    
    return YES;
}

#pragma mark - UIKeyboard -

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSValue *keyboardFrameBegin = [notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardFrameBegin CGRectValue];

    CGFloat offset = MAX(0, (self.tableView.frame.size.height + self.tableView.frame.origin.y) - (self.view.frame.size.height - keyboardRect.size.height));

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, offset, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, offset, 0);
    self.tableView.scrollEnabled= YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        self.tableView.scrollEnabled= NO;
}

#pragma mark - TTTAttributedLabel -

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

@end
