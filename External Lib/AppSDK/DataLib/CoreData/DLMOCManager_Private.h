//
//  DLMOCManager_Private.h
//  DataSDK
//
//  Created by PC Nguyen on 1/21/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLMOCManager.h"

@interface DLMOCManager ()

@property (nonatomic, strong) NSURL *persistentStoreDirectoryURL;

@property (nonatomic, copy) NSString *resourceName;
@property (nonatomic, copy) NSString *resourceExtension;
@property (nonatomic, copy) NSString *sqliteFileName;
@property (nonatomic, assign) DLMOCManagerPersitentStoreType storeType;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSMutableDictionary *processMOCDictionary;

@end
