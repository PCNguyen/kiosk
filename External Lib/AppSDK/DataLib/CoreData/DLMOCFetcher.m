//
//  DLMOCFetcher.m
//  DataSDK
//
//  Created by PC Nguyen on 1/21/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLMOCFetcher.h"
#import "DLMOCInteraction_Private.h"

@interface DLMOCFetcher ()

@property (nonatomic, strong) NSArray *sortDescriptors;
@property (nonatomic, assign) NSUInteger fetchLimit;

@end

@implementation DLMOCFetcher

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if (self = [super initWithManagedObjectContext:context]) {
        self.fetchLimit = 0;
    }
    
    return self;
}

#pragma mark - Sort

- (void)configureSortKey:(NSString *)key ascending:(BOOL)isAscending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:isAscending];
    
    [self configureSortDescriptor:sortDescriptor];
}

- (void)configureSortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [self configureSortDescriptors:sortDescriptors];
}

- (void)configureSortDescriptors:(NSArray *)sortDescriptors
{
    self.sortDescriptors = sortDescriptors;
}

- (void)resetSortDescriptors
{
    self.sortDescriptors = nil;
}

#pragma mark - Wrapper For Threading

- (NSArray *)performFetchRequest:(NSFetchRequest *)fetchRequest
{
    __block NSArray *fetchedResult = nil;
    
    [self.currentMOC performBlockAndWait:^{
        
        NSError *error = nil;
        
        fetchedResult = [self.currentMOC executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            
            //--TODO: log error
            fetchedResult = nil;
        }
        
    }];
    
    return fetchedResult;
}

#pragma mark - Wrapper For Fetching

- (NSArray *)performFetchForEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = self.sortDescriptors;
    fetchRequest.fetchLimit = self.fetchLimit;
    
    NSArray *fetchedResults = [self performFetchRequest:fetchRequest];

    return fetchedResults;
}

#pragma mark - Collection Fetching

- (NSArray *)fetchResultsEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate
{
    self.fetchLimit = [DLMOCFetcher maximumFetchLimit];
    
    NSArray *fetchedResults = [self performFetchForEntity:entity withPredicate:predicate];
    
    return fetchedResults;
}

- (NSArray *)fetchResultsEntity:(NSEntityDescription *)entity
                  withAttribute:(NSString *)attribute
                     equalValue:(id)value
{
    NSPredicate *equalPredicate = [NSPredicate predicateWithFormat:@"%K == %@", attribute, value];
    
    NSArray *fetchedResults = [self fetchResultsEntity:entity withPredicate:equalPredicate];
    
    return fetchedResults;
}

#pragma mark - Single Entity Fetching

- (NSManagedObject *)fetchTopEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate
{
    id fetchedEntity = nil;
    
    self.fetchLimit = 1;
    
    NSArray *fetchedResults = [self performFetchForEntity:entity withPredicate:predicate];
    
    if ([fetchedResults count] > 0) {
        fetchedEntity = [fetchedResults firstObject];
    }
    
    return fetchedEntity;
}

- (NSManagedObject *)fetchTopEntity:(NSEntityDescription *)entity
                      withAttribute:(NSString *)attribute
                         equalValue:(id)value
{
    id fetchedEntity = nil;
    
    NSPredicate *equalPredicate = [NSPredicate predicateWithFormat:@"%K == %@", attribute, value];
    
    fetchedEntity = [self fetchTopEntity:entity withPredicate:equalPredicate];
    
    return fetchedEntity;
}

#pragma mark - Class Helper

+ (NSUInteger)maximumFetchLimit
{
    return 0;
}

@end
