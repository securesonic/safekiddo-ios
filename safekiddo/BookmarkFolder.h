//
//  BookmarkFolder.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 15.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BookmarkFolder, WebpageBookmark;

@interface BookmarkFolder : NSManagedObject

@property (nonatomic, retain) NSDate * dateAndTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) BookmarkFolder *parentFolder;
@property (nonatomic, retain) NSSet *subFolders;
@property (nonatomic, retain) NSSet *webpages;
@end

@interface BookmarkFolder (CoreDataGeneratedAccessors)

- (void)addSubFoldersObject:(BookmarkFolder *)value;
- (void)removeSubFoldersObject:(BookmarkFolder *)value;
- (void)addSubFolders:(NSSet *)values;
- (void)removeSubFolders:(NSSet *)values;

- (void)addWebpagesObject:(WebpageBookmark *)value;
- (void)removeWebpagesObject:(WebpageBookmark *)value;
- (void)addWebpages:(NSSet *)values;
- (void)removeWebpages:(NSSet *)values;

@end
