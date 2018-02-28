//
//  WebpageBookmark.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 15.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Webpage.h"

@class BookmarkFolder;

@interface WebpageBookmark : Webpage

@property (nonatomic, retain) BookmarkFolder *folder;

@end
