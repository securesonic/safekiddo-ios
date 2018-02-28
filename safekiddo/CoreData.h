//
//  CoreData.h
//  RSSReader
//
//  Created by Jakub Dlugosz on 15.08.2014.
//  Copyright (c) 2014 codesurf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject


/**
 * Singleton access property
 */
+(CoreDataManager*)sharedInstance;

//removes all data
-(void)purge;

/**
 * Saves changes in CoreData
 */
- (void)saveContext;

/**
 * Disacrds changes in CoreData
 */
-(void)discardChanges;

/**
 * Creates entity in CoreData for given entity name
 *
 * @param entityName entity name for created object
 * @return Created entity object
 */
- (id)createEntity:(NSString*)entityName;

/**
 * Deletes given entity object from CoreData
 *
 * @param entityObject entity object for deletion
 */
-(void)deleteEntity:(NSManagedObject*)entityObject;

/**
 *  Refreshes properties of an object
 *
 *  @param entityObject entity object to refresh
 */
-(void)refreshEntity:(NSManagedObject*)entityObject;

/**
 * Returns an array of entities of given Name from CoreData
 *
 * @param entityName Name of entities to return
 * @return Array of entities
 */
-(NSArray*)getEntitiesWithName:(NSString*)entityName;

/**
 * Returns an array of entities of given Name sorted in given order from CoreData
 *
 * @param entityName Name of entities to return
 * @param sortDescriptor Sort descriptor for given entites
 * @param sortAscending Is Sorting ascending
 * @return Array of entities
 */
-(NSArray*)getEntitiesWithName:(NSString *)entityName sortDescriptior:(NSString*)sortDescriptor sortAscending:(BOOL)sortAscending;

/**
 * Returns an array of entities of given Name sorted in given order filtered by given predicate from CoreData
 *
 * @param entityName Name of entities to return
 * @param sortDescriptor Sort descriptor for given entites
 * @param sortAscending Is Sorting ascending
 * @param predicate Predicate used to filter results
 * @return Array of entities
 */
-(NSArray*)getEntitiesWithName:(NSString *)entityName sortDescriptior:(NSString*)sortDescriptor sortAscending:(BOOL)sortAscending predicate:(NSPredicate*)predicate;


@end
