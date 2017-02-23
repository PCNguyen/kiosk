//
//  NSManagedObjectContext+DL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void(^NSManagedObjectContextSaveCompletion)(BOOL success, NSError *error);

@interface NSManagedObjectContext (DL)

#pragma mark - Child MOC Handling

/**
 * Save the child moc and propagate to all parent moc
 */
- (void)dl_recursiveSaveWithCompletion:(NSManagedObjectContextSaveCompletion)saveCompletion;

/**
 * For Unit Test Purpose
 */
- (void)dl_recursiveSaveWithCompletion:(NSManagedObjectContextSaveCompletion)saveCompletion
						  detectChange:(BOOL)shouldDetect;
@end
