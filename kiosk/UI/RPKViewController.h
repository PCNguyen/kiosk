//
//  RPKViewController.h
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKUIKit.h"
#import "RPKAnalyticEvent.h"

@protocol RPKAdministratorDelegate <NSObject>

- (void)handleAdministratorTask;

@end

@interface RPKViewController : UIViewController

@property (nonatomic, weak) id<RPKAdministratorDelegate>administratorDelegate;

/**
*  Provide a paddings surround element in the view
*/
@property (nonatomic, assign) UIEdgeInsets paddings;

/**
*  Provide the spacings vertical and horizontal
*/
@property (nonatomic, assign) CGSize spacings;

- (void)toggleLoadingView:(BOOL)isVisible;

#pragma mark - Subclass Hook

- (void)handleAdministratorGesture:(UIGestureRecognizer *)gesture;

@end
