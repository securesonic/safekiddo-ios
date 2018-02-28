//
//  CreateProfileViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 05.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "CreateProfileViewController.h"
#import "Utilities.h"
#import "Appearance.h"
#import "AuthenticateTableViewCell.h"
#import "YearPickerInput.h"
#import "CustomPickerCloseBar.h"
#import "HourFromToTableViewCell.h"
#import "NetworkManager+Register.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LoginViewController.h"
#import "Constants.h"

#define kRowHeight ((IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 44.f : 60.f)

#define kProfileTableCount        2
#define kProfileTableNameIndex    0
#define kProfileTableBirthIndex   1

#define kInternetTableCount       2
#define kInternetTableMonFriIndex 0
#define kInternetTableSatSunIndex 1

typedef enum {
    CurrentHourWeekFrom,
    CurrentHourWeekTo,
    CurrentHourWeekendFrom,
    CurrentHourWeekendTo
} CurrentHour;

@interface CreateProfileViewController ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, YearPickerInputDelegate, CustomPickerCloseBarDelegate, HourFromToTableViewCellDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel     *createProfileLabel;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel     *internetAccessLabel;
@property (weak, nonatomic) IBOutlet UITableView *internetAccessTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *internetTableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property(weak,nonatomic)  AuthenticateTableViewCell *profileNameCell;
@property(weak,nonatomic) AuthenticateTableViewCell *birthYearCell;


//Custom Pickers
@property(strong,nonatomic) YearPickerInput* yearPickerInput;
@property(strong,nonatomic) CustomPickerCloseBar* closeBar;

@property(strong,nonatomic) NSDate* weekFromHour;
@property(strong,nonatomic) NSDate* weekToHour;
@property(strong,nonatomic) NSDate* weekendFromHour;
@property(strong,nonatomic) NSDate* weekendToHour;

@property(weak,nonatomic) HourFromToTableViewCell* weekCell;
@property(weak,nonatomic) HourFromToTableViewCell* weekendCell;


@property(strong,nonatomic) UITextField* fakeTextField;
@property(assign,nonatomic) CurrentHour currentHour;
@property(strong,nonatomic) UIDatePicker* hourPicker;
-(void)hourPickerValueChanged:(id)sender;
@end


@implementation CreateProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.yearPickerInput = [[NSBundle mainBundle]loadNibNamed:@"YearPickerInput" owner:nil options:nil][0];
    self.yearPickerInput.delegate = self;
    
    self.yearPickerInput.maxYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    self.yearPickerInput.minYear = self.yearPickerInput.maxYear - 17;
    self.yearPickerInput.currentYear = self.yearPickerInput.maxYear;
    
    self.closeBar = [[NSBundle mainBundle] loadNibNamed:@"CustomPickerCloseBar" owner:nil options:nil][0];
    self.closeBar.delegate = self;
    // Do any additional setup after loading the view.
    
    self.profileTableViewHeightConstraint.constant = kRowHeight * kProfileTableCount;
    self.internetTableViewHeightConstraint.constant = kRowHeight * kProfileTableCount;
    
    

    
    NSDateComponents* todaysComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay| NSCalendarUnitMonth| NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSDateComponents* dateFromComponents = [[NSDateComponents alloc]init];
    dateFromComponents.year = todaysComponents.year;
    dateFromComponents.month = todaysComponents.month;
    dateFromComponents.day = todaysComponents.day;
    dateFromComponents.hour = 8;
    dateFromComponents.minute = 0;
    
    NSDateComponents* dateToComponents = [[NSDateComponents alloc]init];
    dateFromComponents.year = todaysComponents.year;
    dateFromComponents.month = todaysComponents.month;
    dateFromComponents.day = todaysComponents.day;
    dateToComponents.hour = 16;
    dateToComponents.minute = 0;
    
    
    self.weekFromHour = [[NSCalendar currentCalendar] dateFromComponents:dateFromComponents];
    self.weekToHour = [[NSCalendar currentCalendar] dateFromComponents:dateToComponents];
    
    self.weekendFromHour = [[NSCalendar currentCalendar] dateFromComponents:dateFromComponents];
    self.weekendToHour = [[NSCalendar currentCalendar] dateFromComponents:dateToComponents];
    
    self.hourPicker = [[UIDatePicker alloc]init];
    self.hourPicker.datePickerMode = UIDatePickerModeTime;
    [self.hourPicker addTarget:self action:@selector(hourPickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.fakeTextField = [[UITextField alloc]init];
    self.fakeTextField.alpha = 0.f;
    [self.view addSubview:self.fakeTextField];
    self.fakeTextField.inputView = self.hourPicker;
    self.fakeTextField.inputAccessoryView = self.closeBar;
    
    
    self.createProfileLabel.text = NSLocalizedString(@"CREATE_PROFILE_HEADER", @"");
    self.internetAccessLabel.text = NSLocalizedString(@"CREATE_PROFILE_HEADER_INTERNET", @"");
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary* parameters= @{
                                kLoginNotificationLoginParameter:self.requestData.email,
                                kLoginNotificationPasswordParameter:self.requestData.password
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotificationName
                                                        object:nil userInfo:parameters];
}

#pragma mark - IBActions -

- (IBAction)registerAction:(id)sender
{
    NSString *validationMessage;

    if (![self.requestData validateProfileName])
    {
        validationMessage = NSLocalizedString(@"REGISTER_VALIDATE_PROFILE_NAME", @"");
    }
    else if (![self.requestData validateBirthYear])
    {
        validationMessage = NSLocalizedString(@"REGISTER_VALIDATE_PROFILE_BIRTHYEAR", @"");
    }

    if (validationMessage)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"REGISTER_VALIDATION_TITLE", @"")
                                    message:validationMessage
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"REGISTER_VALIDATION_OK", @"")
                          otherButtonTitles:nil] show];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        [NetworkManager registerData:self.requestData successBlock:^(RegisterResponse *response)
        {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            if(response.success.boolValue)
            {
                [[[UIAlertView alloc]initWithTitle:@"Sukces"
                                          message:@"Pomyślnie założono konto, kliknij ok aby przejść dalej."
                                          delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil]show];
                
                
                
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"REGISTER_ERROR_TITLE", @"")
                                          message:response.message
                                         delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"REGISTER_ERROR_OK", @"") otherButtonTitles:nil]show];
            }
        } failureBlock:^(NSError *error)
        {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"REGISTER_ERROR_TITLE", @"")
                                       message:NSLocalizedString(@"REGISTER_ERROR_UNKNOWN", @"")
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"REGISTER_ERROR_OK", @"") otherButtonTitles:nil]show];
            
        }];
        
    }
}

#pragma mark - Private -

-(void)hourPickerValueChanged:(id)sender
{
    switch (self.currentHour)
    {
        case CurrentHourWeekTo:
        {
            self.weekToHour = self.hourPicker.date;
            if([self.weekToHour timeIntervalSinceDate:self.weekFromHour] < 0)
            {
                self.weekFromHour = self.weekToHour;
            }
            
            [self.weekCell fillWithTitle:NSLocalizedString(@"CREATE_PROFILE_WEEK", @"") hourFrom:self.weekFromHour hourTo:self.weekToHour];
        }
            break;
        case CurrentHourWeekFrom:
        {
            self.weekFromHour = self.hourPicker.date;
         
            if([self.weekToHour timeIntervalSinceDate:self.weekFromHour] < 0)
            {
                self.weekToHour = self.weekFromHour;
            }
        
            
            
            [self.weekCell fillWithTitle:NSLocalizedString(@"CREATE_PROFILE_WEEK", @"") hourFrom:self.weekFromHour hourTo:self.weekToHour];
        }
            break;
        case CurrentHourWeekendFrom:
        {
            self.weekendFromHour = self.hourPicker.date;
            
            if([self.weekendToHour timeIntervalSinceDate:self.weekendFromHour] < 0)
            {
                self.weekendToHour = self.weekendFromHour;
            }
            
            [self.weekendCell fillWithTitle:NSLocalizedString(@"CREATE_PROFILE_WEEKEND", @"") hourFrom:self.weekendFromHour hourTo:self.weekendToHour];
        }
            break;
        case CurrentHourWeekendTo:
        {
            self.weekendToHour = self.hourPicker.date;
            
            if([self.weekendToHour timeIntervalSinceDate:self.weekendFromHour] < 0)
            {
                self.weekendFromHour = self.weekendToHour;
            }
            
            [self.weekendCell fillWithTitle:NSLocalizedString(@"CREATE_PROFILE_WEEKEND", @"") hourFrom:self.weekendFromHour hourTo:self.weekendToHour];
        }
            break;
    }
    
    [self.requestData populateInternetUsageTimeWithWeekStart:self.weekFromHour weekEnd:self.weekToHour weekendStart:self.weekendFromHour weekendEnd:self.weekendToHour];
}

#pragma mark - UITableView -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.profileTableView)
    {
        return kProfileTableCount;
    }
    else
    {
        return kInternetTableCount;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.profileTableView)
    {
        AuthenticateTableViewCell *cell = nil;

        switch (indexPath.row)
        {
            case kProfileTableNameIndex:
                if(self.profileNameCell)
                {
                    cell = self.profileNameCell;
                }
                else
                {
                    cell = (AuthenticateTableViewCell *)
                    [tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    cell.entryTextField.placeholder = NSLocalizedString(@"CREATE_PROFILE_TXT_1", @"");
                    cell.iconImageView.image = [UIImage imageNamed:@"icon-child"];
                    cell.entryTextField.keyboardType = UIKeyboardTypeASCIICapable;
                    cell.entryTextField.returnKeyType = UIReturnKeyNext;
                    cell.entryTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    cell.entryTextField.autocorrectionType = UITextAutocorrectionTypeNo;
                    cell.entryTextField.delegate = self;
                    cell.entryTextField.secureTextEntry = NO;
                    self.profileNameCell = cell;
                }
                break;
            case kProfileTableBirthIndex:
                if(self.birthYearCell)
                {
                    cell = self.birthYearCell;
                }
                else
                {
                    cell = (AuthenticateTableViewCell *)
                    [tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    cell.entryTextField.placeholder = NSLocalizedString(@"CREATE_PROFILE_TXT_2", @"");
                    cell.iconImageView.image = [UIImage imageNamed:@"icon-calendar"];
                    cell.entryTextField.inputView = self.yearPickerInput;
                    cell.entryTextField.inputAccessoryView = self.closeBar;
                    cell.entryTextField.delegate = self;
                    cell.entryTextField.secureTextEntry = NO;
                    self.birthYearCell = cell;

                }
                break;
        }
        
        return  cell;
    }
    else
    {
        HourFromToTableViewCell* cell;
        
        switch (indexPath.row)
        {
            case kInternetTableMonFriIndex:
                if(self.weekCell)
                {
                    cell = self.weekCell;
                }
                else
                {
                    cell = (HourFromToTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    [cell fillWithTitle:NSLocalizedString(@"CREATE_PROFILE_WEEK", @"") hourFrom:self.weekFromHour hourTo:self.weekToHour];
                    cell.delegate = self;
                    self.weekCell = cell;
                }
                break;
            case kInternetTableSatSunIndex:
                if(self.weekendCell)
                {
                    cell = self.weekendCell;
                }
                else
                {
                    cell = (HourFromToTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    [cell fillWithTitle:NSLocalizedString(@"CREATE_PROFILE_WEEKEND", @"") hourFrom:self.weekendFromHour hourTo:self.weekendToHour];
                    cell.delegate = self;
                    self.weekendCell = cell;
                }
                
                break;
            default:
                break;
        }
        
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

#pragma mark - UITextFieldDelegate -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.profileNameCell.entryTextField)
    {
        [self.birthYearCell.entryTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.birthYearCell.entryTextField)
    {
        [self picker:self.yearPickerInput yearChanged:self.yearPickerInput.currentYear];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     
     @property(weak,nonatomic)  AuthenticateTableViewCell *profileNameCell;
     @property(weak,nonatomic) AuthenticateTableViewCell *birthYearCell;
     */
    
    NSString* finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField == self.profileNameCell.entryTextField)
    {
        self.requestData.profileName = finalString;
    }else if(textField == self.birthYearCell.entryTextField)
    {
        self.requestData.profileBirthYear = finalString.intValue;
    }
    return  YES;
}

#pragma mark - YearPickerInputDelegate -

-(void)picker:(YearPickerInput *)picker yearChanged:(NSUInteger)newYear
{
    self.birthYearCell.entryTextField.text = [NSString stringWithFormat:@"%lu",newYear];
    self.requestData.profileBirthYear = newYear;
}

#pragma mark - CustomPickerCloseBarDelegate -

-(void)closeBarClose:(CustomPickerCloseBar *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - HourFromToTableViewCellDelegate - 

-(void)cell:(HourFromToTableViewCell *)cell didSelectHourTo:(NSDate *)hourTo
{
    [self.fakeTextField becomeFirstResponder];
    if(cell == self.weekCell)
    {
        self.currentHour = CurrentHourWeekTo;
    }
    else
    {
        self.currentHour = CurrentHourWeekendTo;
    }
    
    [self.hourPicker setDate:hourTo animated:YES];
}

-(void)cell:(HourFromToTableViewCell *)cell didSelectHourFrom:(NSDate *)hourFrom
{
    [self.fakeTextField becomeFirstResponder];
    if(cell == self.weekCell)
    {
        self.currentHour = CurrentHourWeekFrom;
    }
    else
    {
        self.currentHour = CurrentHourWeekendFrom;
    }
    [self.hourPicker setDate:hourFrom animated:YES];
}

@end
