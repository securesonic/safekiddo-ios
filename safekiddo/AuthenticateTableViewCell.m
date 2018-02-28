//
//  AuthenticateTableViewCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 12.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "AuthenticateTableViewCell.h"
#import "Utilities.h"
@interface AuthenticateTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@end

@implementation AuthenticateTableViewCell

- (void)awakeFromNib {
    
    self.leftMarginConstraint.constant = self.leftMarginConstraint.constant/2.f;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
