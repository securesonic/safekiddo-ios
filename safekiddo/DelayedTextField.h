//
//  DelayedTextField.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 30.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelayedTextField : UITextField

@property(weak,nonatomic)id<UITextFieldDelegate> externalDelegate;

@end
