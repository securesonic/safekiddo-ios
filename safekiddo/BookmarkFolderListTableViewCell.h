//
//  FolderListTableViewCell.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkFolderListTableViewCell : UITableViewCell

-(void)fillWithTitle:(NSString*)title andDepth:(int)depth;

@end
