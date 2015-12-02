//
//  DLMOCFetcher.h
//  DataSDK
//
//  Created by PC Nguyen on 1/21/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLMOCInteraction.h"

@interface DLMOCFetcher : DLMOCInteraction

#pragma mark - Sort

- (void)configureSortKey:(NSString *)key ascending:(BOOL)isAscending;

- (void)configureSortDescriptor:(NSSortDescriptor *)sortDescriptor;

- (void)configureSortDescriptors:(NSArray *)sortDescriptors;

- (void)resetSortDescriptors;

#pragma mark - Wrapper For Threading

- (NSArray *)performFetchRequest:(NSFetchRequest *)fetchRequest;

#pragma mark - Collection Fetching

- (NSArray *)fetchResultsEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate;

- (NSArray *)fetchResultsEntity:(NSEntityDescription *)entity
                  withAttribute:(NSString *)attribute
                     equalValue:(id)value;

#pragma mark - Single Entity Fetching

- (NSManagedObject *)fetchTopEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate;

- (NSManagedObject *)fetchTopEntity:(NSEntityDescription *)entity
                      withAttribute:(NSString *)attribute
                         equalValue:(id)value;

#pragma mark - Class Helper

+ (NSUInteger)maximumFetchLimit;

@end
