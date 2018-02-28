//
//  BookmarkItem.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 09.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BookmarkItem <NSObject>

@property(readonly,nonatomic)BOOL isFolder;
@property(strong,nonatomic)NSString* title;

@end
