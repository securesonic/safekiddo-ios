//
//  HistoryController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 21.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryController : NSObject

+(HistoryController*)sharedHistoryController;

-(void)webViewDidFinishLoadURL:(NSURL*)url inWebView:(UIWebView*)webView withTitle:(NSString*)pageTitle;
-(void)userNavigatedToURL:(NSURL*)url;



-(NSArray*)arrayOfSuggestedWebPagesForString:(NSString*)str;
-(NSArray*)arrayOfHistoryWebPages;
-(void)deleteWebPagesHistory;




@end
