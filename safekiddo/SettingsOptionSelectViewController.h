//
//  SettingsOptionSelectViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsEnum.h"

@class SettingsOptionSelectViewController;
@protocol SettingsOptionSelectViewControllerDelegate <NSObject>

-(void)settingsOptionSelectViewController:(SettingsOptionSelectViewController*)controller didSelectKey:(id)key;

@end

@interface SettingsOptionSelectViewController : UIViewController

@property(weak,nonatomic)id<SettingsOptionSelectViewControllerDelegate> delegate;
@property(assign,nonatomic)SettingsEnum settingsOption;
@property(strong,nonatomic)id currentKey;
@property(strong,nonatomic)NSMutableArray* arrayOfTitles;
@property(strong,nonatomic)NSMutableArray* arrayOfKeys;

@end
