//
//  SegmentViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 30.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webpage.h"
typedef enum
{
    SegmentViewControllerSegmentHistory,
    SegmentViewControllerSegmentBookmark
}SegmentViewControllerSegment;

@class SegmentViewController;

@protocol SegmentViewControllerDelegate <NSObject>

-(void)segmentedViewControllerDidTapToDismiss:(SegmentViewController*)segmentedViewController;
-(void)segmentedViewController:(SegmentViewController*)segmentedViewController didSelectWebPage:(Webpage*)webpage;

@end

@interface SegmentViewController : UIViewController

@property(weak,nonatomic)id<SegmentViewControllerDelegate>delegate;


+(NSString*)stringForSegmentedViewControllerSegment:(SegmentViewControllerSegment)segment;

@end
