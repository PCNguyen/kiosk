//
//  DLMOCMonitor.h
//  DataSDK
//
//  Created by PC Nguyen on 1/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLMOCInteraction.h"

typedef enum {
    MOCMonitorStatusDisable = 0,
    MOCMonitorStatusEnable
} DLMOCMonitorStatus;

extern NSString *const DLMOCMonitorSectionKey;
extern NSString *const DLMOCMonitorPredicateKey;
extern NSString *const DLMOCMonitorFilterPredicateKey;
extern NSString *const DLMOCMonitorFetchedResultsKey;

@class DLMOCMonitor;

@protocol DLMOCMonitorDelegate <NSObject>

@optional
- (void)MOCMonitor:(DLMOCMonitor *)MOCMonitor willUpdateEntity:(NSEntityDescription *)entity;
- (void)MOCMonitor:(DLMOCMonitor *)MOCMonitor didUpdateEntity:(NSEntityDescription *)entity;

- (void)MOCMonitor:(DLMOCMonitor *)MOCMonitor
			entity:(NSEntityDescription *)entity
   didChangeObject:(id)anObject
		   itemRow:(NSInteger)row
     forChangeType:(NSFetchedResultsChangeType)type
			newRow:(NSInteger)newRow;

- (void)MOCMonitor:(DLMOCMonitor *)MOCMonitor
			entity:(NSEntityDescription *)entity
   didChangeObject:(id)anObject
		 indexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath;

@end

@interface DLMOCMonitor : DLMOCInteraction

@property (nonatomic, strong) NSMutableSet *lockedIndexPath;
@property (nonatomic, weak) id<DLMOCMonitorDelegate>delegate;

#pragma mark - Adding Monitoring

/***
 * @param:sortKeys is a dictionary
 * with keys are the keys to sort with
 * and values are BOOL values for ascending order.
 */
- (void)monitorEntity:(NSEntityDescription *)entity
		withPredicate:(NSPredicate *)predicate
			 sortKeys:(NSDictionary *)sortKeys;

/***
 * @param:sortKeys is a dictionary
 * with keys are the keys to sort with
 * and values are BOOL values for ascending order.
 */
- (void)monitorEntity:(NSEntityDescription *)entity
		withPredicate:(NSPredicate *)predicate
			 sortKeys:(NSDictionary *)sortKeys
	 fetchImmediately:(BOOL)shouldFetch;

- (void)monitorWithFetchRequest:(NSFetchRequest *)fetchRequest;

- (void)monitorFetchRequest:(NSFetchRequest *)fetchRequest fetchImmediately:(BOOL)shouldFetch;

#pragma mark - Refresh

- (void)refreshEntity:(NSEntityDescription *)entity withPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch;

- (void)refreshEntity:(NSEntityDescription *)entity filterPredicate:(NSPredicate *)predicate fetchImmediately:(BOOL)shouldFetch;

- (void)removeFilterPredicateOnEntity:(NSEntityDescription *)entity fetchImmediately:(BOOL)shouldFetch;

- (void)fetchMonitoredEntity:(NSEntityDescription *)entity;

- (void)fetchAllMonitoredEntity;

#pragma mark - Locking

- (void)setMonitoringStatus:(DLMOCMonitorStatus)status;

- (void)setMonitoringStatus:(DLMOCMonitorStatus)status
				  forEntity:(NSEntityDescription *)entity;

- (void)setMonitoringStatus:(DLMOCMonitorStatus)status
				  forEntity:(NSEntityDescription *)entity
				  itemIndex:(NSInteger)itemIndex;

- (void)enableMonitoringForAllIndexPath;

#pragma mark - Data Retrieving

- (NSManagedObject *)objectForEntity:(NSEntityDescription *)entity atItemIndex:(NSInteger)index;

- (NSInteger)fetchedCountForEntity:(NSEntityDescription *)entity;

- (NSInteger)totalFetchCount;

#pragma mark - Mapping

- (NSEntityDescription *)entityInSection:(NSInteger)section;

#pragma mark - Fetched Info

- (NSDictionary *)fetchedInfoForEntity:(NSEntityDescription *)entity;

- (NSInteger)sectionIndexForEntity:(NSEntityDescription *)entity;

- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSEntityDescription *)entity;

@end
