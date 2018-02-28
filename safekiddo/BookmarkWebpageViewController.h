//
//  BookmarkWebpageViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 12.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebpageBookmark.h"

@class BookmarkWebpageViewController;

@protocol BookmarkWebpageViewControllerDelegate <NSObject>

-(void)bookmarkWebPageViewControllerDidEndEdit:(BookmarkWebpageViewController*)bookmarkViewController shouldSave:(BOOL)shouldSave;

@end

typedef enum
{
    BookmarkWebpageViewControllerViewController,
    BookmarkWebpageViewControllerAlone,
}BookmarkWebpageViewControllerType;

@interface BookmarkWebpageViewController : UIViewController

@property(assign,nonatomic) BookmarkWebpageViewControllerType type;
@property(weak,nonatomic) IBOutlet UITableView* tableView;
@property(strong,nonatomic)WebpageBookmark* webPage;
@property(weak,nonatomic) id<BookmarkWebpageViewControllerDelegate> delegate;
@end
