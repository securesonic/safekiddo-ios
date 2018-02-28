//
//  DelayedTextField.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 30.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "DelayedTextField.h"


@interface DelayedTextField()<UITextFieldDelegate>

@property(strong,nonatomic)NSString* delayedText;


@end

@implementation DelayedTextField

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.delegate = self;
    }
    return self;
}

-(void)awakeFromNib
{
      self.delegate = self;
}

-(void)setText:(NSString *)text
{
    if(self.isFirstResponder)
    {
        self.delayedText = text;
    }
    else
    {
        [super setText:text];
    }
}


#pragma mark - UITextFieldDelegate -

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.externalDelegate)
    {
        return [self.externalDelegate textFieldShouldReturn:textField];
    }
    else
    {
        return NO;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.externalDelegate)
    {
        return [self.externalDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    else
    {
        return YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.externalDelegate)
    {
        return [self.externalDelegate textFieldDidBeginEditing:textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.delayedText)
    {
        [super setText:self.delayedText];
        self.delayedText = nil;
    }
}


@end
