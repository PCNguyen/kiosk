//
//  DSMOCMonitor+Section.m
//  DataSDK
//
//  Created by PC Nguyen on 3/25/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLMOCMonitor+Section.h"

@implementation DLMOCMonitor (Section)

#pragma mark - Refresh

- (void)dl_refreshEntityInSection:(NSInteger)section withPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch
{
	NSEntityDescription *entity = [self entityInSection:section];
	
	[self refreshEntity:entity withPredicate:predicate fetchImmediately:shouldFetch];
}

- (void)dl_refreshEntityInSection:(NSInteger)section filterPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch
{
    NSEntityDescription *entity = [self entityInSection:section];
	
	[self refreshEntity:entity filterPredicate:predicate fetchImmediately:shouldFetch];
}

- (void)dl_removeFilterPredicateOnEntityInSection:(NSInteger)section fetchImmediately:(BOOL)shouldFetch
{
    NSEntityDescription *entity = [self entityInSection:section];
	
	[self removeFilterPredicateOnEntity:entity fetchImmediately:shouldFetch];
}

- (void)dl_refetchEntityInSection:(NSInteger)section
{
	NSEntityDescription *entity = [self entityInSection:section];
	
	[self fetchMonitoredEntity:entity];
}

#pragma mark - Locking

- (void)dl_setMonitoringStatus:(DLMOCMonitorStatus)status forSection:(NSInteger)section
{
	NSFetchedResultsController *fetchedResultsController = [self dl_fetchedResultsControllerInSection:section];
	
	for (int i = 0; i < [[fetchedResultsController fetchedObjects] count]; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
		[self dl_setMonitoringStatus:status forIndexPath:indexPath];
	}
}

- (void)dl_setMonitoringStatus:(DLMOCMonitorStatus)status forIndexPath:(NSIndexPath *)indexPath
{
	[self.lockedIndexPath addObject:indexPath];
}

#pragma mark - Data Retrieving

- (NSManagedObject *)dl_fetchedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionIndex = indexPath.section;
	NSFetchedResultsController *fetchedResultsController = [self dl_fetchedResultsControllerInSection:sectionIndex];
	NSManagedObject *fetchedObject = nil;
	NSArray *fetchedObjects = [fetchedResultsController fetchedObjects];
	
	if (indexPath.row < [fetchedObjects count]) {
		fetchedObject = [fetchedObjects objectAtIndex:indexPath.row];
	}
	
	return fetchedObject;
}

- (NSInteger)dl_fetchCountForEntitySection:(NSInteger)section
{
    NSFetchedResultsController *fetchedResultsController = [self dl_fetchedResultsControllerInSection:section];
	NSInteger count = [[fetchedResultsController fetchedObjects] count];
	return count;
}

#pragma mark - Fetched Info

- (NSFetchedResultsController *)dl_fetchedResultsControllerInSection:(NSInteger)section
{
	NSEntityDescription *entity = [self entityInSection:section];
	NSFetchedResultsController *fetchedResultsController = [self fetchedResultsControllerForEntity:entity];
	
	return fetchedResultsController;
}

@end
