//
//  DSFileManager.h
//  DataSDK
//
//  Created by PC Nguyen on 4/30/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DLFileManagerCleanUpBeginNotification;
extern NSString *const DLFileManagerCleanUpCompleteNotification;

@interface DLFileManager : NSFileManager

/**
 *  The time interval that metadata should be persisted
 *	Default to 0 which is immediately
 */
@property (nonatomic, assign) NSTimeInterval metaDataPersistInterval;

/**
 *  The time interval that expired file should be checked and remove
 */
@property (nonatomic, assign) NSTimeInterval cleanUpInterval;

/**
 *  The sub directory to clean up, TODO: handle multiple directories
 */
@property (nonatomic, strong) NSString *subDirectory;

/**
 *  Create the shared instance
 *  this should be called in AppDidFinishLaunching
 */
+ (void)configure;

/**
 *  Accessing the share instance
 *
 *  @return the shared instance
 */
+ (DLFileManager *)sharedManager;

/**
 *  Accessing the share cache for file
 *
 *  @return the share cache
 */
+ (NSCache *)sharedCache;

#pragma mark - Directory Helper

/**
 *  Convenient method to access the document directory
 *
 *  @return the url for document dir
 */
- (NSURL *)urlForDocumentsDirectory;

/**
 *  Convenient method to access the cache directory
 *
 *  @return the url for cache dir
 */
- (NSURL *)urlForCacheDirectory;

#pragma mark - Security

/**
 *  Protect the file at path with class B security compliance
 *
 *  @param path the file path to protect
 */
- (void)applyClassBProtectionForFileAtPath:(NSString *)path;

#pragma mark - File Maintenance

/**
 *  Tracking a file with expiration date. Upon the date reach,
 *	the file will be wiped
 *
 *  @param fileURL        the fileURL to track
 *  @param expirationDate the expiration date
 */
- (void)trackFileURL:(NSURL *)fileURL expirationDate:(NSDate *)expirationDate;

/**
 *  Execute file clean up directly. Any expired file will be removed
 */
- (void)handleFileCleanUp;

@end
