//
//  HourFromToTableViewCell.m
//  safekiddo
//
//  Created by Jakub Długosz on 10.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "HourFromToTableViewCell.h"
#import "Appearance.h"
@interface HourFromToTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *hourFromButton;
@property (weak, nonatomic) IBOutlet UIButton *hourToButton;

@property (strong, nonatomic) NSDateFormatter* hourFormatter;

@end

@implementation HourFromToTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.hourFormatter = [[NSDateFormatter alloc]init];
    self.hourFormatter.dateFormat = @"HH:mm";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions -

- (IBAction)hourFromAction:(id)sender
{
    NSDate* hourFromDate = [self.hourFormatter dateFromString:self.hourFromButton.titleLabel.attributedText.string];
    [self.delegate cell:self didSelectHourFrom:hourFromDate];
}


- (IBAction)hourToAction:(id)sender
{
    NSDate* hourToDate = [self.hourFormatter dateFromString:self.hourToButton.titleLabel.attributedText.string];
    [self.delegate cell:self didSelectHourTo:hourToDate];
}

#pragma mark - Public -

-(void)fillWithTitle:(NSString*)title hourFrom:(NSDate*)hourFrom hourTo:(NSDate*)hourTo
{
    self.titleLabel.text = title;
    
    NSDictionary* dateStyle = @{NSForegroundColorAttributeName: [Appearance orangeColor],
                                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    [self.hourFromButton setAttributedTitle:
     [[NSAttributedString alloc]initWithString:[self.hourFormatter stringFromDate:hourFrom]
                                    attributes:dateStyle]
                                   forState:UIControlStateNormal];
    
    [self.hourToButton setAttributedTitle:
     [[NSAttributedString alloc]initWithString:[self.hourFormatter stringFromDate:hourTo]
                                    attributes:dateStyle]
                                   forState:UIControlStateNormal];
    
    
    
}

@end
