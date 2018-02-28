//
//  CustomPickerCloseBar.m
//  safekiddo
//
//  Created by Jakub Długosz on 08.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "CustomPickerCloseBar.h"

@interface CustomPickerCloseBar()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation CustomPickerCloseBar

#pragma mark - Private -
-(void)awakeFromNib
{
    [self.closeButton setTitle:NSLocalizedString(@"CLOSEBAR_CLOSE", @"")];
}

#pragma mark - Public Properties -

-(UIColor *)tintColor
{
    return self.toolbar.tintColor;
}

-(void)setTintColor:(UIColor *)tintColor
{
    self.toolbar.tintColor = tintColor;
}

- (IBAction)closeAction:(id)sender
{
    [self.delegate closeBarClose:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
