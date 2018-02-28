//
//  UnisntallInstructionsViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "UnisntallInstructionsViewController.h"
#import "Utilities.h"
#import "ProfileInstaller.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface UnisntallInstructionsViewController()

@property(strong,nonatomic)IBOutletCollection(NSLayoutConstraint) NSArray* marginConstraints;

@property (weak, nonatomic) IBOutlet UILabel *logoutInstructionHead;
@property (weak, nonatomic) IBOutlet UILabel *logoutInstructionPath;
@property (weak, nonatomic) IBOutlet UILabel *logoutInstructionCode;
@property (weak, nonatomic) IBOutlet UILabel *logoutInstructionPIN;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *logoutInstructionCopyPaste;


@end

@implementation UnisntallInstructionsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
        for(NSLayoutConstraint* constraint in self.marginConstraints)
        {
            constraint.constant = constraint.constant/2.f;
        }
    }
    self.navigationItem.title = NSLocalizedString(@"LOGOUT_TITLE", @"");
    self.logoutInstructionHead.text = NSLocalizedString(@"LOGOUT_TXT1", @"");
    self.logoutInstructionPath.text = NSLocalizedString(@"LOGOUT_TXT2", @"");
    self.logoutInstructionCode.text = NSLocalizedString(@"LOGOUT_TXT3", @"");
    self.logoutInstructionPIN.text = NSLocalizedString(@"LOGOUT_TXT4", @"");

    [self.logoutButton setTitle: [Utilities retrieveProfilePin] forState:UIControlStateNormal];
    
    self.logoutInstructionCopyPaste.text = NSLocalizedString(@"LOGOUT_TXT5", @"");
    
    [self.view layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - IBActions -

- (IBAction)copyUninstallPin:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:[Utilities retrieveProfilePin]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"LOGOUT_TXT6", @"");
    

    

    
    [hud hide:YES afterDelay:1];
}

@end
