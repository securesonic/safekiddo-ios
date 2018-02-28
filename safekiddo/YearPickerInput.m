//
//  DatePickerInput.m
//  safekiddo
//
//  Created by Jakub Długosz on 08.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "YearPickerInput.h"


@interface YearPickerInput()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *yearPicker;

-(void)alignCurrentYear:(NSUInteger)currentYear;
-(void)reloadPicker;
@end

@implementation YearPickerInput

#pragma mark - Properties -

-(void)setCurrentYear:(NSUInteger)currentYear
{
    [self alignCurrentYear:currentYear];
}

-(void)setMinYear:(NSUInteger)minYear
{
    if(minYear > _maxYear)
    {
        _maxYear = minYear;
    }
    _minYear = minYear;
    [self alignCurrentYear:self.currentYear];
}

-(void)setMaxYear:(NSUInteger)maxYear
{
    if(maxYear < _minYear)

    {
        _minYear = maxYear;
    }
    _maxYear = maxYear;
    [self alignCurrentYear:self.currentYear];
}

#pragma mark - Private -

-(void)alignCurrentYear:(NSUInteger)currentYear
{
    if(currentYear < _minYear)
    {
        _currentYear = _minYear;
    }else if(currentYear > _maxYear)
    {
        _currentYear = _maxYear;
    }
    else
    {
        _currentYear = currentYear;
    }
}

-(void)reloadPicker
{
    [self.yearPicker reloadAllComponents];
    [self.yearPicker selectRow:self.currentYear - self.minYear inComponent:0 animated:YES];
}

#pragma mark - UIPickerView -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (_maxYear - _minYear) + 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%lu",_maxYear - row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate picker:self yearChanged:_maxYear - row];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
