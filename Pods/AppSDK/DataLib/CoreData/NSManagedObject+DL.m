//
//  NSManagedObject+DL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSManagedObject+DL.h"

@implementation NSManagedObject (DL)

- (id)dl_retrievedFromContext:(NSManagedObjectContext *)context
{
    id returnedObject = nil;
    
    if ([context.registeredObjects containsObject:self]) {
		returnedObject = self;
	} else if (self.objectID) {
		returnedObject = [context objectWithID:self.objectID];
	}
    
    return returnedObject;
}

#pragma mark - Fetching Helpers

+ (NSEntityDescription *)dl_entityDescriptionInContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(self)
                                                         inManagedObjectContext:context];
    
    return entityDescription;
}

#pragma mark - Inserting Helpers

+ (instancetype)dl_insertIntoContext:(NSManagedObjectContext *)context
{
    __block id insertedEntity = nil;
    
    NSString *entityName = NSStringFromClass(self);
    
    [context performBlockAndWait:^{
        insertedEntity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                       inManagedObjectContext:context];
    }];
    
    return insertedEntity;
}

- (void)dl_setValueWithDictionary:(NSDictionary *)keyedValues
					dateFormatter:(NSDateFormatter *)dateFormatter
{
    [self.managedObjectContext performBlockAndWait:^{
        
        NSDictionary *attributes = [[self entity] attributesByName];
        for (NSString *attribute in attributes) {
            
            id value = [keyedValues objectForKey:attribute];
            
            if (value) {
                
                NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
                
                if ([self shouldParseStringForAttribute:attributeType matchingValue:value]) {
                    value = [value stringValue];
                } else if ([self shouldParseIntegerForAttribute:attributeType matchingValue:value]) {
                    value = [NSNumber numberWithInteger:[value integerValue]];
                } else if ([self shouldParseDoubleForAttribute:attributeType matchingValue:value]) {
                    value = [NSNumber numberWithDouble:[value doubleValue]];
                } else if ([self shouldParseDateForAttribute:attributeType matchingValue:value]) {
                    if (dateFormatter) {
                        value = [dateFormatter dateFromString:value];
                    } else {
                        value = [[NSManagedObject defaultDateFormatter] dateFromString:value];
                    }
                }
                
                [self setValue:value forKey:attribute];
                
            }
        }
		
    }];
}

#pragma mark - Deleting Helper

- (void)dl_deleteFromContext:(NSManagedObjectContext *)context
{
    [context performBlockAndWait:^{
        NSManagedObject *pendingDelete = [self dl_retrievedFromContext:context];
        [context deleteObject:pendingDelete];
    }];
}

- (void)dl_deleteFromCurrentContext
{
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext deleteObject:self];
    }];
}

#pragma mark - Private

- (BOOL)shouldParseStringForAttribute:(NSAttributeType)attributeType matchingValue:(id)value
{
    BOOL shouldParse = (attributeType == NSStringAttributeType && [value isKindOfClass:[NSNumber class]]);
    
    return shouldParse;
}

- (BOOL)shouldParseIntegerForAttribute:(NSAttributeType)attributeType matchingValue:(id)value
{
    BOOL isCoreDataNumberType = (attributeType == NSInteger16AttributeType
                                 || attributeType == NSInteger32AttributeType
                                 || attributeType == NSInteger64AttributeType
                                 || attributeType == NSBooleanAttributeType);
    
    BOOL shouldParse = (isCoreDataNumberType && [value isKindOfClass:[NSString class]]);
    
    return shouldParse;
}

- (BOOL)shouldParseDoubleForAttribute:(NSAttributeType)attributeType matchingValue:(id)value
{
    BOOL shouldParse = (attributeType == NSFloatAttributeType && [value isKindOfClass:[NSString class]]);
    
    return shouldParse;
}

- (BOOL)shouldParseDateForAttribute:(NSAttributeType)attributeType matchingValue:(id)value
{
    BOOL shouldParse = (attributeType == NSDateAttributeType && [value isKindOfClass:[NSString class]]);
    
    return shouldParse;
}

+ (NSDateFormatter *)defaultDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return formatter;
}

@end
