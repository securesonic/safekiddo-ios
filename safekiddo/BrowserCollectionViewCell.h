//
//  BrowserCollectionViewCell.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrowserCollectionViewCell;

@protocol BrowserCollectionViewCellDelegate <NSObject>

-(void)browserCellDelete:(BrowserCollectionViewCell*)cell;

@end

@interface BrowserCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *snapshotImagView;
@property(weak,nonatomic)id<BrowserCollectionViewCellDelegate> delegate;

-(void)fillWithTitle:(NSString*)title andImage:(UIImage*)image;

@end
