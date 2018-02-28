//
//  CoreDataManager+SafeKiddo.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "CoreDataManager+SafeKiddo.h"

@implementation CoreDataManager (SafeKiddo)

-(BookmarkFolder*)rootFolder
{
    NSArray* arrayOfFolders = [[CoreDataManager sharedInstance]getEntitiesWithName:[BookmarkFolder description]];
    BookmarkFolder* rootFolder;
    if(arrayOfFolders.count == 0)
    {
        rootFolder = [[CoreDataManager sharedInstance] createEntity:[BookmarkFolder description]];
        rootFolder.name = NSLocalizedString(@"BOOKMARK_HOME", @"");
        [[CoreDataManager sharedInstance] saveContext];
    }
    else
    {
        rootFolder = arrayOfFolders[0];
    }
    return rootFolder;
}

@end
