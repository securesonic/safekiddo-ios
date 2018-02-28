//
//  Appearance.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "Appearance.h"
#import "SegmentViewController.h"
@implementation Appearance

+(void)setupAppearance
{
    [[UINavigationBar appearance]setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [[UINavigationBar appearance]setBarTintColor:[self tintColor]];
    [[UINavigationBar appearance]setTintColor:[self barButtonTintColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance]setTranslucent:NO];

    [[UIToolbar appearance]setClipsToBounds:YES];
    [[UIToolbar appearance]setBarTintColor:[self tintColor]];
    [[UIToolbar appearance]setTintColor:[UIColor whiteColor]];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
    

}

+(UIColor*)tintColor
{
       return [UIColor colorWithRed:0.f green:0x95/0255.f blue:0xD9/255.f alpha:1.f];
}

+(UIColor*)barButtonTintColor
{
    return [UIColor colorWithRed:128/255.f green:202/255.f blue:236/255.f alpha:1.f];
}

+(UIColor*)orangeColor
{
    return [UIColor colorWithRed:234/255.f green:97/255.f blue:40/255.f alpha:1.f];
}

@end
