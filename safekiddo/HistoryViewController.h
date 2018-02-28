//
//  HistoryViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 26.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebpageHistory.h"
@class HistoryViewController;

@protocol HistoryViewControllerDelegate <NSObject>

-(void)historyViewControllerDismiss:(HistoryViewController*)historyViewController;
-(void)historyViewController:(HistoryViewController*)historyViewController didSelectWebPage:(WebpageHistory*)webpage;

-(void)historyViewController:(HistoryViewController*)historyViewController didSelectWebPageInNewTab:(WebpageHistory*)webpage;
@end

@interface HistoryViewController : UIViewController

@property(weak,nonatomic)id<HistoryViewControllerDelegate>delegate;

@end
