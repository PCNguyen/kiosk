//
//  NSManagedObjectContext+DL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSManagedObjectContext+DL.h"

@implementation NSManagedObjectContext (DL)

#pragma mark - Child MOC Handling

- (void)dl_recursiveSaveWithCompletion:(NSManagedObjectContextSaveCompletion)saveCompletion
{
    [self dl_recursiveSaveWithCompletion:saveCompletion detectChange:YES];
}

- (void)dl_recursiveSaveWithCompletion:(NSManagedObjectContextSaveCompletion)saveCompletion
						  detectChange:(BOOL)shouldDetect
{
    BOOL shouldSave = [self hasChanges] || !shouldDetect;
    
	if (shouldSave) {
        __block BOOL childSuccess = NO;
        __block NSError *saveError = nil;
        
        [self performBlockAndWait:^{
            childSuccess = [self save:&saveError];
        }];
        
        if (childSuccess) {
            [self __saveParentMOC:self.parentContext withCompletion:saveCompletion];
        } else {
            [self __performCompletion:saveCompletion success:NO error:saveError];
        }
        
	} else {
        
		[self __performCompletion:saveCompletion success:YES error:nil];
	}
}

#pragma mark - Private

- (void)__saveParentMOC:(NSManagedObjectContext*)parentMOC
       withCompletion:(NSManagedObjectContextSaveCompletion)completion
{
    if (parentMOC) {
        __block BOOL parentSuccess = NO;
        __block NSError *error = nil;
        
        [parentMOC performBlockAndWait:^{
            parentSuccess = [parentMOC save:&error];
        }];
        
        if (parentSuccess) {
            [self __saveParentMOC:parentMOC.parentContext withCompletion:completion];
        } else {
            [self __performCompletion:completion success:NO error:error];
        }
        
    } else {
        
        [self __performCompletion:completion success:YES error:nil];
    }
}

- (void)__performCompletion:(NSManagedObjectContextSaveCompletion)completion
                  success:(BOOL)success
                    error:(NSError *)error
{
    if (completion) {
        completion(success, error);
    }
}

@end
