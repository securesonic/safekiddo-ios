//
//  UIImageView+Util.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 26.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "UIImageView+Util.h"

@implementation UIImageView (Util)

-(CGPoint)originOfSizeToFit
{
    CGSize boundingSize = self.frame.size;
    CGSize aspectRatio = self.image.size;
    
    CGFloat mW = boundingSize.width / aspectRatio.width;
    CGFloat mH = boundingSize.height / aspectRatio.height;
    if( mH < mW )
        boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
    else if( mW < mH )
        boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
    
    //BOunding size is the size.
    
    return CGPointMake(self.frame.origin.x + (self.frame.size.width - boundingSize.width) / 2.f   , self.frame.origin.y + (self.frame.size.height - boundingSize.height) / 2.f);
}

@end
