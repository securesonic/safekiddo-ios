//
//  WelcomeView.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "WelcomeView.h"

@implementation WelcomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textLabel.text = NSLocalizedString(@"WELCOME_TXT1", @"");
}

@end
