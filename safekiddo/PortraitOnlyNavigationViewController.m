//
//  AuthenticateNavigationViewController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "PortraitOnlyNavigationViewController.h"

@interface PortraitOnlyNavigationViewController ()

@end

@implementation PortraitOnlyNavigationViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
