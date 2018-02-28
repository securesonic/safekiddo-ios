//
//  DatePickerInput.h
//  safekiddo
//
//  Created by Jakub Długosz on 08.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YearPickerInput;

@protocol YearPickerInputDelegate

-(void)picker:(YearPickerInput*) picker yearChanged:(NSUInteger)newYear;

@end

@interface YearPickerInput : UIView

@property(weak,nonatomic) id<YearPickerInputDelegate> delegate;

@property(assign,nonatomic) NSUInteger minYear;
@property(assign,nonatomic) NSUInteger maxYear;
@property(assign,nonatomic) NSUInteger currentYear;

@end
