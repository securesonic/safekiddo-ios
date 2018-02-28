//
//  InstallProfileViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "InstallProfileViewController.h"
#import "ProfileInstaller.h"
#import "Utilities.h"
@interface InstallProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *marginConstraintArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *installButton;

@end

@implementation InstallProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
        for(NSLayoutConstraint* constraint in self.marginConstraintArray)
        {
            constraint.constant = constraint.constant/2.f;
        }
    }
    
    self.label1.text = NSLocalizedString(@"INSTALL_TXT1", @"");
    self.label2.text = NSLocalizedString(@"INSTALL_TXT2", @"");
    self.label3.text = NSLocalizedString(@"INSTALL_TXT3", @"");
    
    self.installButton.title = NSLocalizedString(@"INSTALL_BTN1_TXT", @"");
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions -

- (IBAction)installAction:(id)sender
{
    NSString* pin = [Utilities retrieveProfilePin];
    
    [[ProfileInstaller sharedInstaller]installProfileWithPin:pin];
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
