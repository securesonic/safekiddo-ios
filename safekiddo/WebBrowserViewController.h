//
//  WebBrowserViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebBrowserViewController;
@class Webpage;
@protocol WebBrowserViewControllerDelegate <NSObject>

-(void)webBrowserViewController:(WebBrowserViewController*)controller wantToOpenNewTabWitPage:(Webpage*)page;

@end

@interface WebBrowserViewController : UIViewController

@property(weak,nonatomic) id<WebBrowserViewControllerDelegate>delegate;
@property(strong,nonatomic)NSURL* initialURL;

-(NSString*)currentTitle;
-(NSURL*)currentURL;
-(void)openSettings;

@end
