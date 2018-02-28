//
//  Webpage.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 15.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Webpage : NSManagedObject

@property (nonatomic, retain) NSDate * dateAndTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

@end
