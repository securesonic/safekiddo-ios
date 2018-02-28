//
//  Appearance.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Appearance : NSObject

+(void)setupAppearance;

/**
 *  General SafeKiddo tint color
 *
 *  @return tint UIColor
 */
+(UIColor*)tintColor;

+(UIColor*)barButtonTintColor;

+(UIColor*)orangeColor;

@end
