//
//  DLMOCManager.h
//  DataSDK
//
//  Created by PC Nguyen on 1/21/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSManagedObjectContext+DL.h"

typedef enum {
    MOCManagerStoreTypeSQL = 0,
    MOCManagerStoreTypeInmemory,
} DLMOCManagerPersitentStoreType;

typedef void(^DLMOCManagerProtectionBlock)(NSURL *fileURL);




@interface DLMOCManager : NSObject

@property (readwrite, copy) DLMOCManagerProtectionBlock sqliteProtectionBlock;

+ (DLMOCManager *)sharedManager;

#pragma mark - Setup - Required

- (void)configurePersistentStoreDirectory:(NSURL *)directoryURL;
- (void)configureModelResource:(NSString *)resourceName withExtension:(NSString *)extension;
- (void)configureSqliteFileName:(NSString *)sqliteFileName;
- (BOOL)validateConfiguration;

#pragma mark - Setup - Optional

/***
 * default is sqlite
 */
- (void)configurePersistentStoreType:(DLMOCManagerPersitentStoreType)storeType;

#pragma mark - Main MOC

/***
 * Top Level MOC that connect to the persistent store
 * Changes in this MOC will not be reflected in UI
 */
- (NSManagedObjectContext *)mainMOC;

/***
 * Saving main MOC synchronously on current thread
 * Completion block called back on current thread
 */
- (void)saveMainMOCWithCompletion:(NSManagedObjectContextSaveCompletion)completion;

/***
 * Saving main MOC asynchrounously on background thread
 * Completion block call back on background thread
 * TODO:NEED TESTING - THE SAVE MAY NOT PROPAGATE
 */
- (void)saveMainMOCAsyncWithCompletion:(NSManagedObjectContextSaveCompletion)completion;

#pragma mark - UI MOC

/***
 * A Shared MOC for UI Elements that need to implement fetch result controller
 * Changes in this MOC will be reflected in UI
 */
- (NSManagedObjectContext *)sharedUIMOC;

/***
 * Saving UI MOC sync on current thread
 * This should be called only from main thread
 * Changes are propagated and saved to main MOC
 */
- (void)saveSharedUIMOCWithCompletion:(NSManagedObjectContextSaveCompletion)completion;

#pragma mark - Background MOC

/***
 * Create a background MOC for background process if not already exist
 * Reuse the existing background MOC for the same process if called multiple time
 * Changes in this MOC will propagate and reflected in UI
 */
- (NSManagedObjectContext *)backgroundMOCForProcessID:(NSString *)pid;

/***
 * Saving background MOC synchronously on current thread
 * Changes are propagated and saved to UI MOC on main thread
 * And then to main MOC on current thread
 * Completion called back on current thread
 * This should be called only on BACKGROUND operation
 */
- (void)saveBackgroundMOCForProcessID:(NSString *)pid
                           completion:(NSManagedObjectContextSaveCompletion)completion;

/***
 * Saving background MOC Asynchronously on background thread
 * Changes are propagated and saved to UI MOC on main thread
 * And then to main MOC on background thread
 * Completion called back on background thread
 */
- (void)saveBackgroundMOCAsyncForProcessID:(NSString *)pid
                                completion:(NSManagedObjectContextSaveCompletion)completion;

/***
 * remove previously created background MOC for background process,
 * make sure you call this after finish accessing background MOC,
 * otherwise, you would have pretty good HEADACHE time debugging
 */
- (void)removeBackgroundMOCWithProcessID:(NSString *)pid;

/***
 * A "catch-all" method, clean up all background MOC from memory
 */
- (void)removeAllBackgroundMOCs;

#pragma mark - Reset

/***
 *  This reset all new change on main MOC
 */
- (void)resetAllChanges;

/***
 * Use with caution, this method remove all current app data
 */
- (void)wipeCoreData;

@end