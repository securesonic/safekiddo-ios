//
//  ChildsResponse.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "Response.h"

@protocol Child @end

/**
 *  Child list response object
 */
@interface ChildsResponse : Response

/**
 *  An array of children
 */
@property(strong,nonatomic)NSArray<Child>* childs;

@end
