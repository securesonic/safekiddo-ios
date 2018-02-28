//
//  WelcomeTutorialView.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 11.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "WelcomeTutorialView.h"

@implementation WelcomeTutorialView

+(WelcomeTutorialView*)tutorialViewWithLogoImage:(UIImage*)logoImage title:(NSString*)title subtitle:(NSString*)subtitle
{
    WelcomeTutorialView* tutorialView = [[NSBundle mainBundle] loadNibNamed:@"WelcomeTutorialView" owner:nil options:nil][0];
    
    tutorialView.tutorialLogo.image = logoImage;
    tutorialView.tutorialTitle.text = title;
    tutorialView.tutorialSubTitle.text = subtitle;
    
    return tutorialView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
