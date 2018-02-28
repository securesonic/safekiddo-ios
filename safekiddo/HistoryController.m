//
//  HistoryController.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 21.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "HistoryController.h"
#import "CoreData.h"
#import "NSDate+Util.h"
#import "WebpageHistory.h"
HistoryController* _instance;

@interface HistoryController()

@end


@implementation HistoryController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+(HistoryController*)sharedHistoryController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [HistoryController new];
    });
    return _instance;
}

#pragma mark - Public -

#pragma mark Events

-(void)webViewDidFinishLoadURL:(NSURL*)url inWebView:(UIWebView*)webView withTitle:(NSString*)pageTitle
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSPredicate* predicateToUse = [NSPredicate predicateWithFormat:@"url = %@ AND dateOnly = %@",url.absoluteString,[[NSDate date] dateOnly]];
        NSArray* entities=   [[CoreDataManager sharedInstance] getEntitiesWithName:[WebpageHistory description]
                                                                   sortDescriptior:@"dateAndTime"
                                                                     sortAscending:NO
                                                                         predicate:predicateToUse];
        
        if(entities.count ==0)
        {
            WebpageHistory* newWebPage = [[CoreDataManager sharedInstance] createEntity:[WebpageHistory description]];
            newWebPage.url = url.absoluteString;
            newWebPage.dateAndTime = [NSDate date];
            newWebPage.dateOnly = [newWebPage.dateAndTime dateOnly];
            newWebPage.title = pageTitle;
        }
        else
        {
            WebpageHistory* newWebPage = entities[0];
            newWebPage.dateAndTime = [NSDate date];
            newWebPage.title = pageTitle;
        }
        [[CoreDataManager sharedInstance]saveContext];
        
    });
}

-(void)userNavigatedToURL:(NSURL*)url
{
   // NSLog(@"User navigated to URL: %@",url);
}

#pragma mark Operations

-(NSArray*)arrayOfSuggestedWebPagesForString:(NSString*)str
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"url CONTAINS[cd] %@",str];
    NSMutableArray* pagesArray = [[[CoreDataManager sharedInstance] getEntitiesWithName:@"WebpageHistory" sortDescriptior:@"dateAndTime" sortAscending:NO predicate:predicate] mutableCopy];
    
    for(NSInteger i=pagesArray.count-1; i>=0; i--)
    {
        WebpageHistory* page1 = pagesArray[i];
        for(NSInteger j=i-1;j>=0;j--)
        {
            WebpageHistory* page2 = pagesArray[j];
            if([page1.url isEqualToString:page2.url])
            {
                [pagesArray removeObject:page2];
                break;
            }
        }
    }
    
    return pagesArray;
}

-(NSArray*)arrayOfHistoryWebPages
{
    return [[CoreDataManager sharedInstance] getEntitiesWithName:@"WebpageHistory" sortDescriptior:@"dateAndTime" sortAscending:NO];
}

-(void)deleteWebPagesHistory
{
    NSArray* wholeHistory = [[CoreDataManager sharedInstance] getEntitiesWithName:@"WebpageHistory"];
    for (NSManagedObject* obj in wholeHistory)
    {
        [[CoreDataManager sharedInstance] deleteEntity:obj];
    }
    
    [[CoreDataManager sharedInstance]saveContext];
}
@end
