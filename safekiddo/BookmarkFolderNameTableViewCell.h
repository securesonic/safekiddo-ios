//
//  BookmarkFolderNameTableViewCell.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 10.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkFolder.h"

@interface BookmarkFolderNameTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
