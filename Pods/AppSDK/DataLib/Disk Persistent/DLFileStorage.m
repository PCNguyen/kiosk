//
//  DLFileStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 11/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLFileStorage.h"
#import "DLFileManager.h"

@interface DLFileStorage ()

@property (nonatomic, strong) NSURL *directoryURL;

@end

@implementation DLFileStorage

- (instancetype)initWithCache:(NSCache *)cache
{
	if (self = [super initWithCache:cache]) {
		_persistentInterval = kDLFileStorageUnExpiredInterval;
	}
	
	return self;
}

- (void)saveItem:(id<DLFileStorageProtocol>)item toFile:(NSString *)fileName
{
	if ([fileName length] > 0) {
		//--cache writing
		[self updateCacheValue:item forKey:fileName];
		
		//--persistent writing
		NSURL *fileURL = [self fullURLForFileName:fileName];
		if (item) {
			NSData *storedData = [item dataPresentation];
			[storedData writeToURL:fileURL atomically:YES];
			
			//--set expiredDate so the file can be removed from disk automatically by FileManager
			NSDate *expirationDate = nil;
			if (self.persistentInterval > kDLFileStorageUnExpiredInterval) {
				expirationDate = [[NSDate date] dateByAddingTimeInterval:self.persistentInterval];
				[[DLFileManager sharedManager] trackFileURL:fileURL expirationDate:expirationDate];
			}
			
		} else {
			if ([[DLFileManager sharedManager] fileExistsAtPath:[fileURL path]]) {
				[[DLFileManager sharedManager] removeItemAtURL:fileURL error:NULL];
			}
		}
	}
}

- (id)loadItemFromFile:(NSString *)fileName parseRawDataBlock:(id (^)(NSData *))parseBlock
{
	id storedItem = nil;
	
	if ([fileName length] > 0) {
		//--cache reading
		if (self.enableCache) {
			storedItem = [[self cache] objectForKey:fileName];
		}
		
		//--persistent reading
		if (!storedItem) {
			NSURL *fileURL = [self fullURLForFileName:fileName];
			
			if ([[DLFileManager sharedManager] fileExistsAtPath:[fileURL path]]) {
				NSData *fileData = [[DLFileManager sharedManager] contentsAtPath:[fileURL path]];
				if (parseBlock) {
					storedItem = parseBlock(fileData);
				} else {
					storedItem = fileData;
				}
				
				[self updateCacheValue:storedItem forKey:fileName];
			}
		}
	}
	
	return storedItem;
}

- (void)wipeDirectory
{
	NSArray *contents = [[DLFileManager sharedManager] contentsOfDirectoryAtPath:[self.directoryURL path] error:NULL];
	
	[contents enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger index, BOOL *stop) {
		NSURL *fileURL = [self fullURLForFileName:fileName];
		[[DLFileManager sharedManager] removeItemAtURL:fileURL error:NULL];
	}];
}

- (void)wipeStorage
{
	if (self.enableCache) {
		[[self cache] removeAllObjects];
	}
	
	[self wipeDirectory];
}

- (NSURL *)directoryURL
{
	if (!_directoryURL) {
		_directoryURL = [[DLFileManager sharedManager] urlForDocumentsDirectory];
	}
	
	return _directoryURL;
}

- (void)adjustDirectoryURL:(NSURL *)directoryURL
{
	BOOL directoryExist;
	BOOL pathExist = [[DLFileManager sharedManager] fileExistsAtPath:[directoryURL path] isDirectory:&directoryExist];
	if (!pathExist || !directoryExist) {
		[[DLFileManager sharedManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	self.directoryURL = directoryURL;
}

- (NSURL *)fullURLForFileName:(NSString *)fileName
{
	return [self.directoryURL URLByAppendingPathComponent:fileName];
}
@end
