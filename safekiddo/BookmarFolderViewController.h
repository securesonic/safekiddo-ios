//
//  BookmarFolderViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 09.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkFolder.h"

@class BookmarFolderViewController;

@protocol BookmarFolderViewControllerDelegate <NSObject>

-(void)bookmarFolderViewControllerDidEndEdit:(BookmarFolderViewController*)bookmarkViewController;

@end

@interface BookmarFolderViewController : UIViewController

@property(weak,nonatomic)id<BookmarFolderViewControllerDelegate>delegate;
@property(strong,nonatomic)BookmarkFolder* folder;

@end
