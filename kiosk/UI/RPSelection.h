//
//  RPSelectionInfo.h
//  Reputation
//
//  Created by PC Nguyen on 9/4/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPSelection : NSObject

@property (nonatomic, strong) NSString *selectionID;
@property (nonatomic, strong) NSString *selectionLabel;
@property (nonatomic, assign) BOOL isSelected;

@end
