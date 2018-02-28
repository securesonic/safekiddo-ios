//
//  SelectChildTableViewCell.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Child.h"


@interface SelectChildTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *childNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *childIconImageView;

-(void)fillWithChild:(Child*)child;


@end
