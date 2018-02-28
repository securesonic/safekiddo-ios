//
//  BookmarkFolderListViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkFolder.h"
#import "WebpageBookmark.h"

@interface BookmarkFolderListViewController : UIViewController

@property(strong,nonatomic)BookmarkFolder* folder;
@property(strong,nonatomic)WebpageBookmark* webPage;
@end
