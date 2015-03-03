//
//  KSAccountBalanceNotificationData.h
//  KSKeshLibrary
//
//  Created by A-Team on 14.11.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSTOAccountBalanceNotification;
@class KSAmount;

@interface KSAccountBalanceNotificationData : NSObject

@property (strong,readonly) KSAmount *balance;
@property (strong,readonly) KSAmount *balanceLocked;
@property (strong,readonly) KSAmount *balanceDechargable;
@property (strong,readonly) NSArray *limitUsages;

- (id)initWithAccountBalanceNotification:(KSTOAccountBalanceNotification*)notification;

@end
