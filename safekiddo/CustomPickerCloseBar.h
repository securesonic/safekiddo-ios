//
//  CustomPickerCloseBar.h
//  safekiddo
//
//  Created by Jakub Długosz on 08.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPickerCloseBar;

@protocol CustomPickerCloseBarDelegate <NSObject>

-(void)closeBarClose:(CustomPickerCloseBar*)sender;

@end


@interface CustomPickerCloseBar : UIView

@property(weak,nonatomic)id<CustomPickerCloseBarDelegate> delegate;
@property(strong,nonatomic)UIColor* tintColor;


@end
