//
//  CoreData.m
//  RSSReader
//
//  Created by Jakub Dlugosz on 15.08.2014.
//  Copyright (c) 2014 codesurf. All rights reserved.
//

#import "CoreData.h"
#import "Utilities.h"
#import <CoreData/CoreData.h>
#import "Webpage.h"
#import "WebpageBookmark.h"
#import "WebpageCard.h"
#import "WebpageHistory.h"
#import "BookmarkFolder.h"
@interface CoreDataManager()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic)dispatch_queue_t coreDataQueue;
@end


NSString* const kCoreDataLocation = @"safekiddo.sqlite";
NSString* const kCoreDataModelName = @"safekiddo";
static CoreDataManager* _instance;

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (instancetype)init
{
    self = [super init];
    if (self) {
        _coreDataQueue = dispatch_queue_create("coredataqueue", NULL);
    }
    return self;
}

+(CoreDataManager*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [CoreDataManager new];
        
    });
    return _instance;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kCoreDataModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL* documentsFolderURL = [NSURL fileURLWithPath:[Utilities documentsFolderPath]];
    NSURL *storeURL = [documentsFolderURL URLByAppendingPathComponent:kCoreDataLocation];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
       /// abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - public methods -

-(void)purge
{
    for(id obj in [self getEntitiesWithName:[Webpage description]])
    {
        [self deleteEntity:obj];
    }
    for(id obj in [self getEntitiesWithName:[WebpageCard description]])
    {
        [self deleteEntity:obj];
    }
    for(id obj in [self getEntitiesWithName:[WebpageBookmark description]])
    {
        [self deleteEntity:obj];
    }
    for(id obj in [self getEntitiesWithName:[WebpageHistory description]])
    {
        [self deleteEntity:obj];
    }
    
    for(id obj in [self getEntitiesWithName:[BookmarkFolder description]])
    {
        [self deleteEntity:obj];
    }
    
    
        [self saveContext];
    
}

-(void)deleteEntity:(id)entityObject
{
    dispatch_sync(self.coreDataQueue, ^{
        [self.managedObjectContext deleteObject:entityObject];
    });
}

-(void)refreshEntity:(NSManagedObject*)entityObject
{
    dispatch_sync(self.coreDataQueue, ^{
        [self.managedObjectContext refreshObject:entityObject mergeChanges:YES];
    });
}

- (id)createEntity:(NSString*)entityName
{
    __block id createdObject;
    
    dispatch_sync(self.coreDataQueue, ^{
        createdObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    });
    
    return createdObject;
}

- (void)saveContext
{
    dispatch_sync(self.coreDataQueue, ^{
        NSError *error = nil;
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    });
}

-(void)discardChanges
{
    dispatch_sync(self.coreDataQueue, ^{
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        if(managedObjectContext != nil)
        {
            if([managedObjectContext hasChanges])
            {
                [managedObjectContext rollback];
            }
        }
    });
}

-(NSArray*)getEntitiesWithName:(NSString*)entityName
{
    return [self getEntitiesWithName:entityName sortDescriptior:nil sortAscending:YES];
}

-(NSArray*)getEntitiesWithName:(NSString *)entityName sortDescriptior:(NSString*)sortDescriptor sortAscending:(BOOL)sortAscending
{
    return [self getEntitiesWithName:entityName sortDescriptior:sortDescriptor sortAscending:sortAscending predicate:nil];
}

-(NSArray*)getEntitiesWithName:(NSString *)entityName sortDescriptior:(NSString*)sortDescriptor sortAscending:(BOOL)sortAscending predicate:(NSPredicate*)predicate
{
    __block NSArray* returnArray;
    
    dispatch_sync(self.coreDataQueue, ^{
        
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        if(predicate)
        {
            [request setPredicate:predicate];
        }
        
        if(sortDescriptor)
        {
            NSSortDescriptor *sd = [[NSSortDescriptor alloc]
                                    initWithKey:sortDescriptor ascending:sortAscending];
            
            [request setSortDescriptors:@[sd]];
        }
        
        NSError *error;
        NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
        if (array == nil)
        {
            NSLog(@"%@",error);
            returnArray = nil;
        }
        else
        {
            returnArray = array;
        }
        
    });
    
    return  returnArray;
}

@end
