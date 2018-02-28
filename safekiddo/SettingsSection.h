//
//  SettingsSection.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsSection : NSObject


+(SettingsSection*)sectionWithTitle:(NSString*)title andRows:(NSArray*)array;

@property(strong,nonatomic)NSString* sectionTitle;
@property(strong,nonatomic)NSArray* sectionRows;

@end
