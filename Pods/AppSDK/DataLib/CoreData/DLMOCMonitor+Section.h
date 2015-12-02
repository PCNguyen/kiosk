//
//  DSMOCMonitor+Section.h
//  DataSDK
//
//  Created by PC Nguyen on 3/25/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLMOCMonitor.h"

@interface DLMOCMonitor (Section)

#pragma mark - Refresh

- (void)dl_refreshEntityInSection:(NSInteger)section withPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch;

- (void)dl_refreshEntityInSection:(NSInteger)section filterPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch;

- (void)dl_removeFilterPredicateOnEntityInSection:(NSInteger)section fetchImmediately:(BOOL)shouldFetch;

- (void)dl_refetchEntityInSection:(NSInteger)section;

#pragma mark - Locking

- (void)dl_setMonitoringStatus:(DLMOCMonitorStatus)status forSection:(NSInteger)section;

- (void)dl_setMonitoringStatus:(DLMOCMonitorStatus)status forIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Data Retrieving

- (NSManagedObject *)dl_fetchedObjectAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)dl_fetchCountForEntitySection:(NSInteger)section;

#pragma mark - Fetched Info

- (NSFetchedResultsController *)dl_fetchedResultsControllerInSection:(NSInteger)section;

@end
