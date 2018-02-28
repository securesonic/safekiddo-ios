//
//  FolderListTableViewCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarkFolderListTableViewCell.h"

NSInteger const marginLevel = 12;

@interface BookmarkFolderListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation BookmarkFolderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillWithTitle:(NSString*)title andDepth:(int)depth
{
    self.titleLabel.text = title;
    self.leftMargin.constant = marginLevel* depth;
    [self layoutIfNeeded];
}

@end
