//
//  Settings.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>






@interface Settings : NSObject

+(Settings*)sharedSettings;

@property(assign,nonatomic)BOOL useMobileUserAgent;


@end
