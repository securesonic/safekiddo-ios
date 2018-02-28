//
//  TodayChildTableCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 10.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "TodayChildTableCell.h"

@implementation TodayChildTableCell

- (IBAction)openAction:(id)sender
{
    [self.delegate cellDidPickChild:self];
}

@end
