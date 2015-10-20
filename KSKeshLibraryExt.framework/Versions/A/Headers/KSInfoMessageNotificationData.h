//
//  KSInfoMessageNotificationData.h
//  KSKeshLibrary
//
//  Created by A-Team on 14.11.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSTOInfoMessageNotification;
@class KSVisualization;

@interface KSInfoMessageNotificationData : NSObject

@property(strong,readonly) KSVisualization *visualization;

- (id)initWithInfoMessageNotification:(KSTOInfoMessageNotification*)notification;

@end
