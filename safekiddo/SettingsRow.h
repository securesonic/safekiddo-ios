//
//  SettingsRow.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SettingsEnum.h"

@interface SettingsRow : NSObject

+(SettingsRow*)rowWithType:(SettingsEnum)type;

@property(assign,nonatomic)SettingsEnum type;
@property(readonly,nonatomic)NSString* title;

@end
