//
//  PinViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 18.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "PinViewController.h"
#import "Utilities.h"
#import "SettingsRow.h"
#import "SettingsSection.h"
#import "SettingsEnum.h"
#import "SettingsViewController.h"
#import "PinProtection.h"
@interface PinViewController ()

@property(strong,nonatomic)IBOutletCollection(UIButton) NSArray* enterButtons;
@property(strong,nonatomic)IBOutletCollection(UIView) NSArray* selectedButtons;
@property(strong,nonatomic)IBOutlet UIButton* clearButton;
@property(weak,nonatomic)IBOutlet UILabel* instructionsLabel;

@property (weak, nonatomic) IBOutlet UIView *leadingSpacerVew;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

/**
 *  Pin entered by user
 */
@property(strong,nonatomic)NSString* currentPin;

/**
 *  Returns sorted array with UIViews, the viewss are sorted by Y then by X
 *
 *  @param input array to sort
 *
 *  @return sorted array of views
 */
-(NSArray*)sortedViews:(NSArray*)input;

/**
 *  Styles given view and sets it's border and color
 *
 *  @param view       View to style
 *  @param isSelected If selected - the view will be a filled white circle, if false, it will be a white ring.
 */
-(void)styleView:(UIView*)view selected:(BOOL)isSelected;

/**
 *  Styles the given view as red cicrle
 *
 *  @param view view to style
 */
-(void)markViewAsError:(UIView*)view;

/**
 *  Action for Pin buttons
 *
 *  @param sender Sender object
 */
-(void)pinAction:(id)sender;

/**
 *  Prepares datasource for next settings step
 *
 *  @return Array of SettingsSections
 */
-(NSArray*)prepareSettingsData;

-(NSArray*)createSelectedButtons;



@property(assign,nonatomic)NSInteger pinLength;

@property(strong,nonatomic)NSTimer* pinTimer;
@property(strong,nonatomic)NSTimer* infoLabelUpdateTimer;

-(void)pinTimeoutAction:(id)sender;
-(void)infoLabelUpdateAction:(id)sender;
-(void)setControlsLocked:(BOOL)locked;

@end

@implementation PinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pinLength = [Utilities retrievePin].length;
    
    self.navigationItem.title = NSLocalizedString(@"SETTINGS_PARENT_MODE", @"");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"SETTINGS_TITLE", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.instructionsLabel.text = NSLocalizedString(@"SETTINGS_PARENT_MODE_INSTRUCTION", @"");
    
    self.enterButtons = [self sortedViews:self.enterButtons];
    
    //Those views are there only for the presentation
    for(UIView* v in self.selectedButtons)
    {
        [v removeFromSuperview];
    }
    
    self.selectedButtons = [self createSelectedButtons];
    
    int i=1;
    
    [self.view layoutIfNeeded];
    for(UIButton* button in self.enterButtons)
    {
        [button setTitle:@((i++)%10).stringValue forState:UIControlStateNormal];
        button.layer.cornerRadius = button.frame.size.width/2.f;
        [button addTarget:self action:@selector(pinAction:) forControlEvents:UIControlEventTouchUpInside];
        button.clipsToBounds = YES;
        [button setBackgroundImage:[self.class imageWithColor:[UIColor colorWithRed:298/255.f green:195/255.f blue:40/255.f alpha:1]] forState:UIControlStateHighlighted];
    }
    
    self.currentPin = @"";
    
    for (UIView* view in self.selectedButtons)
    {
        [self styleView:view selected:NO];
    }
    
    self.clearButton.layer.cornerRadius = 5;
    self.clearButton.clipsToBounds=YES;
    [self.clearButton setBackgroundImage:[self.class imageWithColor:[UIColor colorWithRed:298/255.f green:195/255.f blue:40/255.f alpha:1]] forState:UIControlStateHighlighted];
    
    self.infoLabel.hidden = YES;
    
    if([PinProtection sharedPinProtection].triesLeft == 0)
    {
        NSTimeInterval interval = [[PinProtection sharedPinProtection].timeOutDate timeIntervalSinceNow];
        
        if(interval > 0)
        {
            self.pinTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(pinTimeoutAction:) userInfo:nil repeats:NO];
            [self setControlsLocked:YES];
            [self infoLabelUpdateAction:nil];
            self.infoLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(infoLabelUpdateAction:) userInfo:nil repeats:YES];
        }
        else
        {
            [PinProtection sharedPinProtection].triesLeft = kPINProtectionMaxTriesLeft;
            [PinProtection sharedPinProtection].timeOutDate = nil;
        }
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self.pinTimer invalidate];
    [self.infoLabelUpdateTimer invalidate];
}

#pragma mark - IBActions - 

- (IBAction)clearAction:(id)sender
{
    if(self.currentPin.length>1)
    {
        self.currentPin = [self.currentPin substringToIndex:self.currentPin.length-1];
    }else if(self.currentPin.length == 1)
    {
        self.currentPin = @"";
    }
    
    for(int i=0;i<self.currentPin.length; i++)
    {
        [self styleView:self.selectedButtons[i] selected:YES];
    }
    
    for (NSInteger i=self.currentPin.length; i< self.pinLength; i++)
    {
        [self styleView:self.selectedButtons[i] selected:NO];
    }
}

#pragma mark - Private -

-(void)pinTimeoutAction:(id)sender
{
    [self.infoLabelUpdateTimer invalidate];
    [PinProtection sharedPinProtection].triesLeft = kPINProtectionMaxTriesLeft;
    [PinProtection sharedPinProtection].timeOutDate = nil;
    [self setControlsLocked:NO];

}

-(NSArray *)prepareSettingsData
{
    
    //
    
    
    NSArray* returnArray = @[
                      [SettingsSection sectionWithTitle:NSLocalizedString(@"SETTINGS_SECTION_GENERAL", @"") andRows:@[
                                                                                                                    [SettingsRow rowWithType:SettingsAssingAcount],
                                                                                                                    [SettingsRow rowWithType:SettingsManageSafeKiddo],
                                                                                                                    [SettingsRow rowWithType:SettingsLogout],
                                                                                                                    [SettingsRow rowWithType:SettingsAbout]
                                                                                                                    ]]
                      ];

    return returnArray;
}

-(void)pinAction:(id)sender
{
    if(self.currentPin.length < self.pinLength)
    {
        [self styleView:self.selectedButtons[self.currentPin.length] selected:YES];
        self.currentPin = [self.currentPin stringByAppendingString:@(([self.enterButtons indexOfObject:sender] + 1 )%10).stringValue];
        
        if(self.currentPin.length == self.pinLength)
        {
            if([self.currentPin isEqualToString:[Utilities retrievePin]])
            {
                [PinProtection sharedPinProtection].triesLeft = kPINProtectionMaxTriesLeft;
                SettingsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
                vc.dataSource = [self prepareSettingsData];
                vc.navigationItem.title = NSLocalizedString(@"SETTINGS_PARENT_MODE", @"");
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                if(--[PinProtection sharedPinProtection].triesLeft == 0)
                {
                    [PinProtection sharedPinProtection].timeOutDate = [NSDate dateWithTimeIntervalSinceNow:kPINProtectionTimeoutSeconds];
                    self.pinTimer = [NSTimer scheduledTimerWithTimeInterval:kPINProtectionTimeoutSeconds target:self selector:@selector(pinTimeoutAction:) userInfo:nil repeats:NO];
                    
                    [self setControlsLocked:YES];
                    self.infoLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(infoLabelUpdateAction:) userInfo:nil repeats:YES];
                }
                else
                {
                    for (UIView* view in self.selectedButtons)
                    {
                        [self markViewAsError:view];
                    }
                    self.infoLabel.hidden = NO;
                    
                    if([PinProtection sharedPinProtection].triesLeft == 2)
                    {
                        self.infoLabel.text = NSLocalizedString(@"PIN_TRIES_LEFT_2", @"");
                    }else if([PinProtection sharedPinProtection].triesLeft ==1)
                    {
                        self.infoLabel.text = NSLocalizedString(@"PIN_TRIES_LEFT_1", @"");
                    }else
                    {
                        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"PIN_TRIES_LEFT", @""),[PinProtection sharedPinProtection].triesLeft];
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        for (UIView* view in self.selectedButtons)
                        {
                            [self styleView:view selected:NO];
                            self.currentPin = @"";
                            self.infoLabel.hidden = YES;
                        }
                    });
                }
                
            }
        }
    }
}

-(NSArray*)sortedViews:(NSArray*)input
{
    return [input sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        UIView* v1 = obj1;
        UIView* v2 = obj2;
        
        NSComparisonResult result = [@(v1.frame.origin.y) compare:@(v2.frame.origin.y)];
        
        if(result == NSOrderedSame)
        {
            result = [@(v1.frame.origin.x) compare:@(v2.frame.origin.x)];
        }
        
        return result;
    }];
}

-(void)styleView:(UIView*)view selected:(BOOL)isSelected
{
    view.layer.cornerRadius = view.frame.size.width/2.f;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 2.f;
    
    if(isSelected)
    {
        view.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        view.backgroundColor = [UIColor clearColor];
    }
}

-(void)markViewAsError:(UIView*)view
{
    
    view.layer.cornerRadius = view.frame.size.width/2.f;
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 5.f;
    
    view.backgroundColor = [UIColor redColor];
    
}

//TODO - move
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSArray*)createSelectedButtons
{
    NSMutableArray* selectedButtonsArray = [NSMutableArray array];
    
    UIView* fromView;
    int fromValue;
    for(int i=0;i<self.pinLength;i++)
    {
        UIView* newView = [UIView new];
        newView.translatesAutoresizingMaskIntoConstraints = NO;
        if(i==0)
        {
            fromView = self.leadingSpacerVew;
            fromValue = 20;
        }
        else
        {
            fromValue = 8;
        }
        
        
        
        [self.view addSubview:newView];
        
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[fromView]-fromValue-[view(20)]" options:0 metrics:@{@"fromValue":@(fromValue)} views:@{@"view":newView,
                                                                                                                                                                             @"fromView":fromView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(20)]" options:0 metrics:nil views:@{@"view":newView}]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:newView
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:fromView
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:0]];
        
        
        
        [selectedButtonsArray addObject:newView];
        fromView = newView;
    }
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[fromView]-16-[toView]" options:0 metrics:nil views:@{@"fromView":fromView,@"toView":self.clearButton}]];
    
    
    return [selectedButtonsArray copy];
}

-(void)setControlsLocked:(BOOL)locked
{
    for(UIButton* btn in self.enterButtons)
    {
        btn.hidden = locked;
    }
    

    self.clearButton.hidden = locked;
    
    for(UIView* view in self.selectedButtons)
    {
        view.hidden = locked;
    }
    
    self.infoLabel.hidden = !locked;
    
    [self infoLabelUpdateAction:nil];
}

-(void)infoLabelUpdateAction:(id)sender
{
    NSTimeInterval interval = [[PinProtection sharedPinProtection].timeOutDate timeIntervalSinceNow];
    if(interval > 0)
    {
        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"PIN_TIMEOUT", @""),(int)interval];
    }
    else
    {
        self.infoLabel.text = @"";
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
