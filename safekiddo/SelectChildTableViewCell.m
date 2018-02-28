//
//  SelectChildTableViewCell.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SelectChildTableViewCell.h"
#import "Utilities.h"
#import "UIImageView+AFNetworking.h"
#import "SafeURLProtocol.h"
@interface SelectChildTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@end

@implementation SelectChildTableViewCell



- (void)awakeFromNib {
    // Initialization code
    
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
        self.leftMarginConstraint.constant = self.leftMarginConstraint.constant/2.f;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected)
    {
        self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessory_check"]];
    }
    else
    {
        self.accessoryView = nil;
    }
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect newRect = self.accessoryView.frame;
    newRect.origin = (CGPoint){self.frame.size.width - (self.leftMarginConstraint.constant + newRect.size.width),newRect.origin.y};
    
   self.accessoryView.frame = newRect;
}

#pragma mark - Public -

-(void)fillWithChild:(Child*)child
{
    self.childNameLabel.text = child.name;
    
    if(child.avatarUrl)
    {
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:child.avatarUrl]];
        [request setValue:@(YES).stringValue forHTTPHeaderField:kIgnoreSafeURLProtocolHTTPHeader];
  
        [self.childIconImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"icon-child"]
                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                    self.childIconImageView.image = image;
                                                    
                                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                    
                                                }];
//        [self.childIconImageView setimage placeholderImage:[UIImage imageNamed:@"icon-child"]];
    }
    else
    {
    [self.childIconImageView setImage:[UIImage imageNamed:@"icon-child"]];
    }

}

@end
