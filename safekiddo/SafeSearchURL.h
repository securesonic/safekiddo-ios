//
//  SafeSearchURL.h
//  safekiddo
//
//  Created by Jakub Długosz on 17.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SafeSearchAbstract.h"
@interface SafeSearchURL : SafeSearchAbstract

@property(strong,nonatomic)NSString* parameter;
@property(strong,nonatomic)NSString* negativeParameter;



@end
