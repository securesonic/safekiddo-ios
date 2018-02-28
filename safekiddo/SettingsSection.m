//
//  SettingsSection.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SettingsSection.h"

@implementation SettingsSection

+(SettingsSection*)sectionWithTitle:(NSString*)title andRows:(NSArray*)array
{
    SettingsSection* section = [SettingsSection new];
    section.sectionTitle = title;
    section.sectionRows = array;
    
    return section;
}

@end
