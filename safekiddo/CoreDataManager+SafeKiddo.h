//
//  CoreDataManager+SafeKiddo.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "CoreData.h"
#import "BookmarkFolder.h"
@interface CoreDataManager (SafeKiddo)

-(BookmarkFolder*)rootFolder;

@end
