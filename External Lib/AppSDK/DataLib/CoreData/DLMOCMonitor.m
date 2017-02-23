//
//  DLMOCMonitor.m
//  DataSDK
//
//  Created by PC Nguyen on 1/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DLMOCMonitor.h"
#import "DLMOCInteraction_Private.h"

NSString *const DLMOCMonitorSectionKey                  = @"DLMOCMonitorSectionKey";
NSString *const DLMOCMonitorPredicateKey                = @"DLMOCMonitorPredicateKey";
NSString *const DLMOCMonitorFilterPredicateKey          = @"DLMOCMonitorFilterPredicateKey";
NSString *const DLMOCMonitorFetchedResultsKey           = @"DLMOCMonitorFetchedResultsKey";

@interface DLMOCMonitor () <NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) BOOL shouldMonitor;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, strong) NSMutableDictionary *fetchedControllers;

@end

@implementation DLMOCMonitor

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
	if (self = [super initWithManagedObjectContext:context]) {
		_shouldMonitor = YES;
		_currentSection = 0;
		_fetchedControllers = [NSMutableDictionary dictionary];
	}
	
	return self;
}

#pragma mark - Adding Monitoring

- (void)monitorEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate sortKeys:(NSDictionary *)sortKeys
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = predicate;
	NSMutableArray *sortDescriptors = [NSMutableArray array];
	[sortKeys enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *order, BOOL *stop) {
		NSSortDescriptor *sortItem = [NSSortDescriptor sortDescriptorWithKey:key ascending:[order boolValue]];
		[sortDescriptors addObject:sortItem];
	}];
	fetchRequest.sortDescriptors = sortDescriptors;
	
    [self monitorWithFetchRequest:fetchRequest];
}

- (void)monitorEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate sortKeys:(NSDictionary *)sortKeys fetchImmediately:(BOOL)shouldFetch
{
	[self monitorEntity:entity withPredicate:predicate sortKeys:sortKeys];
	
	if (shouldFetch) {
		[self fetchMonitoredEntity:entity];
	}
}

- (void)monitorWithFetchRequest:(NSFetchRequest *)fetchRequest
{
	NSString *cacheName = NSStringFromClass([fetchRequest.entity class]);
	
    NSFetchedResultsController *fetchedResultController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.currentMOC
                                          sectionNameKeyPath:nil
                                                   cacheName:cacheName];
    fetchedResultController.delegate = self;
	
    NSMutableDictionary *fetchedInfo = [[NSMutableDictionary alloc] init];
    [fetchedInfo setValue:fetchedResultController forKey:DLMOCMonitorFetchedResultsKey];
    [fetchedInfo setValue:fetchRequest.predicate forKey:DLMOCMonitorPredicateKey];
    [fetchedInfo setValue:@(self.currentSection) forKey:DLMOCMonitorSectionKey];
    [fetchedInfo setValue:nil forKey:DLMOCMonitorFilterPredicateKey];
    
    [self.fetchedControllers setObject:fetchedInfo forKey:fetchRequest.entity];
	
	self.currentSection++;
}

- (void)monitorFetchRequest:(NSFetchRequest *)fetchRequest fetchImmediately:(BOOL)shouldFetch
{
	[self monitorWithFetchRequest:fetchRequest];
	
	if (shouldFetch) {
		[self fetchMonitoredEntity:fetchRequest.entity];
	}
}

#pragma mark - Refresh

- (void)refreshEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch
{
	[self updateFetchedInfoForEntity:entity setValue:predicate forKey:DLMOCMonitorPredicateKey];
	[self updateFetchedResultsControllerForEntity:entity];
	
	if (shouldFetch) {
		[self fetchMonitoredEntity:entity];
	}
}

- (void)refreshEntity:(NSEntityDescription *)entity filterPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch
{
	[self updateFetchedInfoForEntity:entity setValue:predicate forKey:DLMOCMonitorFilterPredicateKey];
	[self updateFetchedResultsControllerForEntity:entity];
	
	if (shouldFetch) {
		[self fetchMonitoredEntity:entity];
	}
}

- (void)removeFilterPredicateOnEntity:(NSEntityDescription *)entity fetchImmediately:(BOOL)shouldFetch
{
	[self refreshEntity:entity filterPredicate:nil fetchImmediately:shouldFetch];
}

- (void)fetchMonitoredEntity:(NSEntityDescription *)entity
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForEntity:entity];
	[self performFetch:fetchedResultsController];
}

- (void)fetchAllMonitoredEntity
{
	[self.fetchedControllers enumerateKeysAndObjectsUsingBlock:^(NSEntityDescription *entity, NSDictionary *fetchedInfo, BOOL *stop) {
		[self performFetch:[fetchedInfo valueForKey:DLMOCMonitorFetchedResultsKey]];
	}];
}

#pragma mark - Locking

- (void)setMonitoringStatus:(DLMOCMonitorStatus)status
{
	self.shouldMonitor = (status == MOCMonitorStatusEnable);
}

- (void)setMonitoringStatus:(DLMOCMonitorStatus)status
				  forEntity:(NSEntityDescription *)entity
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForEntity:entity];
	
	for (int i = 0; i < [[fetchedResultsController fetchedObjects] count]; i++) {
		[self setMonitoringStatus:status forEntity:entity itemIndex:i];
	}
}

- (void)setMonitoringStatus:(DLMOCMonitorStatus)status forEntity:(NSEntityDescription *)entity itemIndex:(NSInteger)itemIndex
{
	NSDictionary *fetchedInfo = [self fetchedInfoForEntity:entity];
	NSInteger section = [[fetchedInfo valueForKey:DLMOCMonitorSectionKey] integerValue];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemIndex inSection:section];
	
	if (status == MOCMonitorStatusEnable) {
		[self.lockedIndexPath removeObject:indexPath];
	} else if (status == MOCMonitorStatusDisable) {
		[self.lockedIndexPath addObject:indexPath];
	}
}

- (void)enableMonitoringForAllIndexPath
{
	self.shouldMonitor = YES;
	
	[self.lockedIndexPath removeAllObjects];
}

#pragma mark - Data Retrieving

- (NSManagedObject *)objectForEntity:(NSEntityDescription *)entity atItemIndex:(NSInteger)index
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForEntity:entity];
	
	NSManagedObject *fetchedObject = nil;
	NSArray *fetchedObjects = [fetchedResultsController fetchedObjects];
	
	if (index < [fetchedObjects count]) {
		fetchedObject = [fetchedObjects objectAtIndex:index];
	}
	
	return fetchedObject;
}

- (NSInteger)fetchedCountForEntity:(NSEntityDescription *)entity
{
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForEntity:entity];
	
	NSInteger count = [[fetchedResultsController fetchedObjects] count];
	
	return count;
}

- (NSInteger)totalFetchCount
{
	__block NSInteger count = 0;
	
    [self.fetchedControllers enumerateKeysAndObjectsUsingBlock:^(NSEntityDescription *key, NSDictionary *fetchedInfo, BOOL *stop) {
		NSFetchedResultsController *fetchedResultsController = [fetchedInfo valueForKey:DLMOCMonitorFetchedResultsKey];
		count += [[fetchedResultsController fetchedObjects] count];
	}];
	
	return count;
}

#pragma mark - FetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	if (self.shouldMonitor) {
		if ([self.delegate respondsToSelector:@selector(MOCMonitor:willUpdateEntity:)]) {
			[self.delegate MOCMonitor:self willUpdateEntity:controller.fetchRequest.entity];
		}
	}
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
	NSInteger section = [self sectionIndexForEntity:controller.fetchRequest.entity];
	NSIndexPath *checkedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:section];

	BOOL isLock = [self.lockedIndexPath containsObject:checkedIndexPath];
	
    if (self.shouldMonitor && !isLock) {
		NSEntityDescription *entity = controller.fetchRequest.entity;
		
		if ([self.delegate respondsToSelector:@selector(MOCMonitor:entity:didChangeObject:itemRow:forChangeType:newRow:)]) {
			[self.delegate MOCMonitor:self
							   entity:entity
					  didChangeObject:anObject
							  itemRow:indexPath.row
						forChangeType:type
							   newRow:newIndexPath.row];
		} else if ([self.delegate respondsToSelector:@selector(MOCMonitor:entity:didChangeObject:indexPath:forChangeType:newIndexPath:)]) {
			[self.delegate MOCMonitor:self
							   entity:entity
					  didChangeObject:anObject
							indexPath:indexPath
						forChangeType:type
						 newIndexPath:newIndexPath];
		}
	}
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
	//--TODO: Figure out how we want to do this
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	if (self.shouldMonitor) {
		if ([self.delegate respondsToSelector:@selector(MOCMonitor:didUpdateEntity:)]) {
			[self.delegate MOCMonitor:self didUpdateEntity:controller.fetchRequest.entity];
		}
	}
}

#pragma mark - Section Mapping

- (void)reloadFetchedResultController:(NSFetchedResultsController *)fetchedResultsController
							inSection:(NSInteger)section
{
    NSError *fetchedError = nil;
    
    [fetchedResultsController performFetch:&fetchedError];
    
    if (fetchedError) {
        //--TODO: logging
    }
}

#pragma mark - Mapping

- (NSEntityDescription *)entityInSection:(NSInteger)section
{
	__block NSEntityDescription *entityDescription = nil;
	
	[self.fetchedControllers enumerateKeysAndObjectsUsingBlock:^(NSEntityDescription *key, NSDictionary *fetchedInfo, BOOL *stop) {
		if ([[fetchedInfo valueForKey:DLMOCMonitorSectionKey] integerValue] == section) {
			entityDescription = key;
		}
	}];
	
	return entityDescription;
}

#pragma mark - Fetched Info

- (NSDictionary *)fetchedInfoForEntity:(NSEntityDescription *)entity
{
	NSDictionary *fetchedInfo = [self.fetchedControllers objectForKey:entity];
	
	return fetchedInfo;
}

- (NSInteger)sectionIndexForEntity:(NSEntityDescription *)entity
{
	NSDictionary *fetchedInfo = [self fetchedInfoForEntity:entity];
	NSInteger sectionIndex = [[fetchedInfo valueForKey:DLMOCMonitorSectionKey] integerValue];
	
	return sectionIndex;
}

- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSEntityDescription *)entity
{
	NSDictionary *fetchedInfo = [self fetchedInfoForEntity:entity];
	NSFetchedResultsController *fetchedResultsController = [fetchedInfo valueForKey:DLMOCMonitorFetchedResultsKey];
	
	return fetchedResultsController;
}

- (NSPredicate *)predicateForEntity:(NSEntityDescription *)entity
{
	NSDictionary *fetchedInfo = [self fetchedInfoForEntity:entity];
	NSPredicate *predicate = [fetchedInfo valueForKey:DLMOCMonitorPredicateKey];
	
	return predicate;
}

- (NSPredicate *)filterPredicateForEntity:(NSEntityDescription *)entity
{
	NSDictionary *fetchedInfo = [self fetchedInfoForEntity:entity];
	NSPredicate *filterPredicate = [fetchedInfo valueForKey:DLMOCMonitorFilterPredicateKey];
	
	return filterPredicate;
}

#pragma mark - Update Helpers

- (void)updateFetchedInfoForEntity:(NSEntityDescription *)entity setValue:(id)value forKey:(NSString *)key
{
    NSDictionary *fetchedInfo = [self fetchedInfoForEntity:entity];
    
    NSMutableDictionary *modifiedFetchedInfo = [fetchedInfo mutableCopy];
    [modifiedFetchedInfo setValue:value forKey:key];
    
	//--defensive
	if (fetchedInfo) {
		[self.fetchedControllers setObject:modifiedFetchedInfo forKey:entity];
	}
}

- (void)updateFetchedResultsControllerForEntity:(NSEntityDescription *)entity
{
    NSDictionary *fetchedInfo = [self fetchedInfoForEntity:entity];
    
    NSFetchedResultsController *fetchedResultsController = [fetchedInfo valueForKey:DLMOCMonitorFetchedResultsKey];
    NSPredicate *predicate = [fetchedInfo valueForKey:DLMOCMonitorPredicateKey];
    NSPredicate *filterPredicate = [fetchedInfo valueForKey:DLMOCMonitorFilterPredicateKey];
    
    NSMutableArray *combinedPredicates = [NSMutableArray array];
    
    if (predicate) {
        [combinedPredicates addObject:predicate];
    }
    
    if (filterPredicate) {
        [combinedPredicates addObject:filterPredicate];
    }
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:combinedPredicates];
    
    fetchedResultsController.fetchRequest.predicate = compoundPredicate;
    
	[self updateFetchedInfoForEntity:entity
							setValue:fetchedResultsController
							  forKey:DLMOCMonitorFetchedResultsKey];
}

#pragma mark - Private

- (void)performFetch:(NSFetchedResultsController *)fetchedResultsController
{
	NSError *error = nil;
	[fetchedResultsController performFetch:&error];
	
	if (error) {
		//--TODO: Logging
	}
}

@end
