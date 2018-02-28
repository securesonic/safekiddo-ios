//
//  Child.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "JSONModel.h"

/**
 *  Class represents a childe
 */
@interface Child : JSONModel

@property(strong,nonatomic) NSString<Optional>* avatarUrl;

/**
 *  Name of a child
 */
@property(strong,nonatomic) NSString* name;
/**
 *  Unique universal identifier of a children
 */
@property(strong,nonatomic) NSString* uuid;



@end
