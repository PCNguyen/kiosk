//
//  DLMOCManager.m
//  DataSDK
//
//  Created by PC Nguyen on 1/21/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLMOCManager_Private.h"

@interface DLMOCManager ()

@property (nonatomic, strong) NSManagedObjectContext *mainMOC;
@property (nonatomic, strong) NSManagedObjectContext *sharedUIMOC;

@end

@implementation DLMOCManager

+ (DLMOCManager *)sharedManager {
	
	static DLMOCManager *managedObjectContextManager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		managedObjectContextManager = [[DLMOCManager alloc] init];
		
	});
	
	return managedObjectContextManager;
}

- (id)init
{
    if (self = [super init]) {
        self.storeType = MOCManagerStoreTypeSQL;
    }
    
    return self;
}

#pragma mark - Setup

- (void)configurePersistentStoreDirectory:(NSURL *)directoryURL
{
    self.persistentStoreDirectoryURL = directoryURL;
}

- (void)configureModelResource:(NSString *)resourceName withExtension:(NSString *)extension
{
    self.resourceName = resourceName;
    self.resourceExtension = extension;
}

- (void)configureSqliteFileName:(NSString *)sqliteFileName
{
    self.sqliteFileName = sqliteFileName;
}

- (void)configurePersistentStoreType:(DLMOCManagerPersitentStoreType)storeType
{
    self.storeType = storeType;
}

- (BOOL)validateConfiguration
{
    BOOL success = ((self.resourceName.length > 0) && (self.resourceExtension.length > 0));
    
    if (self.storeType == MOCManagerStoreTypeSQL) {
        success = (success && (self.persistentStoreDirectoryURL != nil));
        success = (success && (self.sqliteFileName.length > 0));
    }
    
    return success;
}

#pragma mark - Main MOC

- (NSManagedObjectContext *)mainMOC
{
    if (!_mainMOC) {
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        
        if (coordinator != nil) {
            _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _mainMOC.persistentStoreCoordinator = self.persistentStoreCoordinator;
            _mainMOC.mergePolicy = NSOverwriteMergePolicy;
        }
    }
    
    return _mainMOC;
}

- (void)saveMainMOCWithCompletion:(NSManagedObjectContextSaveCompletion)completion
{
    [self.mainMOC dl_recursiveSaveWithCompletion:completion];
}

- (void)saveMainMOCAsyncWithCompletion:(NSManagedObjectContextSaveCompletion)completion
{
    [self.mainMOC performBlock:^{
        [self.mainMOC dl_recursiveSaveWithCompletion:completion];
    }];
}

#pragma mark - UI MOC

- (NSManagedObjectContext *)sharedUIMOC
{
    if (!_sharedUIMOC) {
        _sharedUIMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_sharedUIMOC.parentContext = [self mainMOC];
    }
    
    return _sharedUIMOC;
}

- (void)saveSharedUIMOCWithCompletion:(NSManagedObjectContextSaveCompletion)completion
{
    [self.sharedUIMOC dl_recursiveSaveWithCompletion:completion];
}

#pragma mark - Background MOC

- (NSManagedObjectContext *)backgroundMOCForProcessID:(NSString *)pid
{
    NSManagedObjectContext *backgroundMOC = [self.processMOCDictionary valueForKey:pid];
    
    if (!backgroundMOC) {
        backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundMOC.parentContext = [self sharedUIMOC];
        backgroundMOC.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        [self.processMOCDictionary setValue:backgroundMOC forKey:pid];
    }
    
    return backgroundMOC;
}

- (void)saveBackgroundMOCForProcessID:(NSString *)pid
                           completion:(NSManagedObjectContextSaveCompletion)completion
{
    NSManagedObjectContext *backgroundMOC = [self backgroundMOCForProcessID:pid];
    
    [backgroundMOC dl_recursiveSaveWithCompletion:completion];
}

- (void)saveBackgroundMOCAsyncForProcessID:(NSString *)pid
                                completion:(NSManagedObjectContextSaveCompletion)completion
{
    NSManagedObjectContext *backgroundMOC = [self backgroundMOCForProcessID:pid];
    
    [backgroundMOC performBlock:^{
        [backgroundMOC dl_recursiveSaveWithCompletion:completion];
    }];
}

- (void)removeBackgroundMOCWithProcessID:(NSString *)pid
{
    [self.processMOCDictionary setValue:nil forKey:pid];
}

- (void)removeAllBackgroundMOCs
{
    self.processMOCDictionary = nil;
}

#pragma mark - Reset

- (void)resetAllChanges
{
    //--TODO: this is not thread safe yet
    [[self mainMOC] reset];
}

- (void)wipeCoreData
{
    //--TODO: this is not thread safe yet
    [self removeAllBackgroundMOCs];
    [self resetAllChanges];
    
    self.mainMOC = nil;
    self.sharedUIMOC = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    
    NSURL *storeURL = [self persistentStoreURL];
    NSError *removedError = nil;
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&removedError];
}

#pragma mark - Store Coordinator

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.resourceName withExtension:self.resourceExtension];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setObject:@(YES) forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setObject:@(YES) forKey:NSInferMappingModelAutomaticallyOption];
		
		NSError *error = nil;
		NSURL *storeURL = [self persistentStoreURL];
		NSManagedObjectModel *model = [self managedObjectModel];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
		
        NSString *storeTypeString = NSSQLiteStoreType;
        
        if (self.storeType == MOCManagerStoreTypeInmemory) {
            storeTypeString = NSInMemoryStoreType;
        }
        
		if (![_persistentStoreCoordinator addPersistentStoreWithType:storeTypeString
													   configuration:nil
                                                                 URL:storeURL
															 options:options
															   error:&error])
        {
            [self abortWithErrorMessage:@"Unresolved error" error:error];
		}
        
        if (self.sqliteProtectionBlock) {
            self.sqliteProtectionBlock(storeURL);
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Background Processing

- (NSMutableDictionary *)processMOCDictionary
{
    if (!_processMOCDictionary) {
        _processMOCDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _processMOCDictionary;
}

#pragma mark - Exception

- (NSURL *)persistentStoreDirectoryURL
{
    if (!_persistentStoreDirectoryURL) {
        [self abortWithErrorMessage:@"Must set persistentstore directory" error:nil];
    }
    
    return _persistentStoreDirectoryURL;
}

- (NSString *)resourceName
{
    if (!_resourceName) {
        [self abortWithErrorMessage:@"Must set resource name" error:nil];
    }
    
    return _resourceName;
}

- (NSString *)resourceExtension
{
    if (!_resourceExtension) {
        [self abortWithErrorMessage:@"Must set resource extension" error:nil];
    }
    
    return _resourceExtension;
}

- (NSString *)sqliteFileName
{
    if (!_sqliteFileName) {
        [self abortWithErrorMessage:@"Must set sqlite filename" error:nil];
    }
    
    return _sqliteFileName;
}

- (void)abortWithErrorMessage:(NSString *)message error:(NSError *)error
{
    NSLog(@"%@", message);
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    abort();
}

#pragma mark - Private

- (NSURL *)persistentStoreURL
{
    NSURL *storeURL = [self.persistentStoreDirectoryURL URLByAppendingPathComponent:self.sqliteFileName];
    
    return storeURL;
}

@end
