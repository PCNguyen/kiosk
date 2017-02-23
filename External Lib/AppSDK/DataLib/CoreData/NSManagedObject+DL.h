//
//  NSManagedObject+DL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (DL)

/***
 * Retrieving an identical object in different context
 * Return nil if nothing found
 */
- (id)dl_retrievedFromContext:(NSManagedObjectContext *)context;

#pragma mark - Fetching Helpers

/***
 * create the entity description for fetch request on context
 */
+ (NSEntityDescription *)dl_entityDescriptionInContext:(NSManagedObjectContext *)context;

#pragma mark - Insert Helpers

/***
 * insert a new entity of this type in context
 */
+ (instancetype)dl_insertIntoContext:(NSManagedObjectContext *)context;

/***
 * setting value of the entity from dictionary
 * using the date formatter for date type
 */
- (void)dl_setValueWithDictionary:(NSDictionary *)keyedValues
					dateFormatter:(NSDateFormatter *)dateFormatter;

#pragma mark - Delete Helpers

- (void)dl_deleteFromContext:(NSManagedObjectContext *)context;
- (void)dl_deleteFromCurrentContext;

@end
