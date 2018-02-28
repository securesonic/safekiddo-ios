//
//  BookmarkFolderFolderTableViewCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarkFolderFolderTableViewCell.h"

@interface BookmarkFolderFolderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *folderNameLabel;

@end

@implementation BookmarkFolderFolderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public -

-(void)fillWithTitle:(NSString*)title
{
    self.descriptionLabel.text = NSLocalizedString(@"BOOKMARK_FLD_NAME", @"");
    self.folderNameLabel.text = title;
}

@end
