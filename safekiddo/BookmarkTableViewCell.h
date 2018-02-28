//
//  BookmarkTableViewCell.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 09.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookmarkTableViewCell;
@protocol BookmarkTableViewCellDelegate <NSObject>

-(void)bookmarkTableViewCellDidLongTap:(BookmarkTableViewCell*)cell;

@end

@interface BookmarkTableViewCell : UITableViewCell

@property(weak,nonatomic) id<BookmarkTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end
