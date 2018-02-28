//
//  SuggestionTableViewCell.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 24.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webpage.h"

@class SuggestionTableViewCell;

@protocol SuggestionTableViewCellDelegate <NSObject>

-(void)suggestionTableViewCellDidLongPress:(id)cell;

@end

@interface SuggestionTableViewCell : UITableViewCell

@property(weak,nonatomic)id<SuggestionTableViewCellDelegate> delegate;

-(void)fillWithWebPage:(Webpage*)webpage;

@end
