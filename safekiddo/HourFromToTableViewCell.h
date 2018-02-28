//
//  HourFromToTableViewCell.h
//  safekiddo
//
//  Created by Jakub Długosz on 10.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HourFromToTableViewCell;

@protocol HourFromToTableViewCellDelegate

-(void)cell:(HourFromToTableViewCell*)cell didSelectHourFrom:(NSDate*)hourFrom;
-(void)cell:(HourFromToTableViewCell*)cell didSelectHourTo:(NSDate*)hourTo;

@end

@interface HourFromToTableViewCell : UITableViewCell


@property(weak,nonatomic) id<HourFromToTableViewCellDelegate> delegate;

-(void)fillWithTitle:(NSString*)title hourFrom:(NSDate*)hourFrom hourTo:(NSDate*)hourTo;

@end
