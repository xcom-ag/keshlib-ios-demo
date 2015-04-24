//
//  KSUpgradedUserNotificationData.h
//  KSKeshLibrary
//
//  Created by Alexander Nöske on 14.04.15.
//  Copyright (c) 2015 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSManager.h"

@class KSTOUserUpgradedNotification;

@interface KSUserUpgradedNotificationData : NSObject

@property (copy, readonly) NSString *phoneNumber;
@property (copy, readonly) NSString *accountNumber;
@property (nonatomic) KSKeshType keshType;

- (id)initWithUserUpgradedNotification:(KSTOUserUpgradedNotification*)notification;

@end
