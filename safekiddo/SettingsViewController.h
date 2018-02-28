//
//  SettingsViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property(strong,nonatomic)NSArray* dataSource;
-(void)openOptionAtIndex:(NSIndexPath*)indexPath;
@end
