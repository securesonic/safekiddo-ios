//
//  SuggestionViewController.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 24.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webpage.h"

@class SuggestionViewController;
@protocol SuggestionViewControllerDelegate <NSObject>

-(void)suggestionViewController:(SuggestionViewController*)suggestionViewController didSelectSuggestion:(Webpage*)webpage;

-(void)suggestionViewController:(SuggestionViewController*)suggestionViewController didSelectSuggestionInNewTab:(Webpage*)webpage;

-(void)suggestionViewControllerDidTapToDismiss:(SuggestionViewController*)suggestionViewController;

@end

@interface SuggestionViewController : UIViewController

@property(weak,nonatomic)id<SuggestionViewControllerDelegate> delegate;

-(void)updateSuggestions:(NSArray*)newSuggestions;

@end
