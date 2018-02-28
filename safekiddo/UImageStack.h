//
//  UImageStack.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UImageStack : NSObject

//@property(strong,nonatomic)NSMutableArray* imageArray;
//@property(assign,nonatomic)NSInteger currentIndex;

-(void)pushToStack:(UIImage*)image;
-(void)moveBackInStack:(UIImage*)image;
-(void)moveForwardIntStack:(UIImage*)image;

-(UIImage*)getBackImage;
-(UIImage*)getForwardImage;

@end
