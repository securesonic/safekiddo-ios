//
//  BrowserCollectionViewCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "BrowserCollectionViewCell.h"

@interface BrowserCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BrowserCollectionViewCell

-(void)fillWithTitle:(NSString*)title andImage:(UIImage*)image
{
    self.titleLabel.text = title;
    self.snapshotImagView.image = image;
}

- (IBAction)closeAction:(id)sender
{
    [self.delegate browserCellDelete:self];
}

@end
