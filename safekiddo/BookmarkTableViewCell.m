//
//  BookmarkTableViewCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 09.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BookmarkTableViewCell.h"

@interface BookmarkTableViewCell()

@property (strong,nonatomic) IBOutlet UILongPressGestureRecognizer* gestureRecognizer;

@end

@implementation BookmarkTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.gestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:self.gestureRecognizer];
}

-(IBAction)longPressAction:(UIGestureRecognizer*)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [self.delegate bookmarkTableViewCellDidLongTap:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
