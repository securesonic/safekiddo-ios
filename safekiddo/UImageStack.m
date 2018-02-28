//
//  UImageStack.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "UImageStack.h"
#import <Mint.h>
#import <UIKit/UIKit.h>

@interface UImageStack()

@property(strong,nonatomic)UIImage* lastImage;

@end

@implementation UImageStack



-(instancetype)init
{
    self = [super init];
    if(self)
    {
        //self.imageArray = [NSMutableArray arrayWithObject:[NSNull null]];
        //self.currentIndex = 0;
    }
    return self;
}


-(void)pushToStack:(UIImage*)image
{
    self.lastImage = image;
    // [self.imageArray replaceObjectAtIndex:self.currentIndex withObject:image];
    // NSRange range = NSMakeRange(self.currentIndex + 1, self.imageArray.count - (self.currentIndex + 1));
    // [self.imageArray removeObjectsInRange:range];
    // [self.imageArray addObject:[NSNull null]];
    //self.currentIndex += 1;
}

-(void)moveBackInStack:(UIImage*)image
{
    self.lastImage = image;
    // [self.imageArray replaceObjectAtIndex:self.currentIndex withObject:image];
    //self.currentIndex -= 1;
    // [self.imageArray replaceObjectAtIndex:self.currentIndex withObject:[NSNull null]];
}

-(void)moveForwardIntStack:(UIImage*)image
{
    self.lastImage = image;
    // [self.imageArray replaceObjectAtIndex:self.currentIndex withObject:image];
    //self.currentIndex += 1;
    // [self.imageArray replaceObjectAtIndex:self.currentIndex withObject:[NSNull null]];
}

-(UIImage*)getBackImage
{
    return [UImageStack imageWithColor:[UIColor lightGrayColor]];
  //  return [UIImage imageNamed:@"WelcomeBackground1"];
   // if(self.currentIndex > 0)
   // {
   //     return nil;
        //return [self.imageArray objectAtIndex:self.currentIndex-1];
   // }
   // else
   // {
   //     return nil;
   // }
}
-(UIImage*)getForwardImage
{
    return [UImageStack imageWithColor:[UIColor lightGrayColor]];
//     return [UIImage imageNamed:@"WelcomeBackground1"];
  //  if(self.currentIndex +1 < self.imageArray.count)
  /*  {
        return nil;
        //return  self.imageArray[self.currentIndex+1];
    }
    else
    {
        return nil;
    }*/
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
