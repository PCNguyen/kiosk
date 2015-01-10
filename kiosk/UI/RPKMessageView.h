//
//  RPKMessageView.h
//  kiosk
//
//  Created by PC Nguyen on 1/8/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKView.h"

typedef enum {
	MessageSwitchAccount,
	MessageReloadPage,
} RPKMessageType;

@class RPKMessageView;

@protocol RPKMessageViewDelegate <NSObject>

@optional
- (void)messagViewActionTapped:(RPKMessageView *)messageView;

@end

@interface RPKMessageView : RPKView

@property (nonatomic, weak) id<RPKMessageViewDelegate>delegate;
@property (nonatomic, assign) RPKMessageType messageType;

@end
