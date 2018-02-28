//
//  WelcomeTutorialView.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeTutorialView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *tutorialLogo;
@property (weak, nonatomic) IBOutlet UILabel *tutorialTitle;
@property (weak, nonatomic) IBOutlet UILabel *tutorialSubTitle;

+(WelcomeTutorialView*)tutorialViewWithLogoImage:(UIImage*)logoImage title:(NSString*)title subtitle:(NSString*)subtitle;


@end
