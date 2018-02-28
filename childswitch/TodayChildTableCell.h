//
//  TodayChildTableCell.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 10.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TodayChildTableCell;
@protocol TodayChildTableCellDelegate <NSObject>

-(void)cellDidPickChild:(TodayChildTableCell*)cell;

@end

@interface TodayChildTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *childAvatarImageView;

@property(weak,nonatomic) id<TodayChildTableCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *childNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end
