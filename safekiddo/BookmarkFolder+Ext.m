//
//  BookmarkFolder+Ext.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 09.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarkFolder+Ext.h"

@implementation BookmarkFolder (Ext)

-(BOOL)isFolder
{
    return YES;
}

-(NSString *)title
{
    return self.name;
}

-(void)setTitle:(NSString *)title
{
    self.name = title;
}

@end
