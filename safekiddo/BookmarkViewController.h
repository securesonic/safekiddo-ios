//
//  BookmarkViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 30.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkFolder.h"

@class BookmarkViewController;

@protocol BookmarkViewControllerDelegate <NSObject>

-(void)bookmarViewControllerDismiss:(BookmarkViewController*)bookmarkViewController;
-(void)bookmarViewController:(BookmarkViewController*)bookmarkViewController didSelectWebPage:(WebpageBookmark*)webpage;

-(void)bookmarViewController:(BookmarkViewController *)bookmarkViewController didSelectWebPageInNewTab:(WebpageBookmark *)webpage;


@end

@interface BookmarkViewController : UIViewController


@property(weak,nonatomic) id<BookmarkViewControllerDelegate> delegate;
@property(strong,nonatomic) BookmarkFolder* folder;

@end
