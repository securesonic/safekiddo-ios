//
//  SuggestionTableViewCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 24.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SuggestionTableViewCell.h"

@interface SuggestionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageAddressLabel;

@property (strong,nonatomic) IBOutlet UILongPressGestureRecognizer* gestureRecognizer;

@end

@implementation SuggestionTableViewCell

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
        [self.delegate suggestionTableViewCellDidLongPress:self];
    }
}

-(void)fillWithWebPage:(Webpage*)webpage
{
    self.pageTitleLabel.text = webpage.title;
    self.pageAddressLabel.text = webpage.url;
}


@end
