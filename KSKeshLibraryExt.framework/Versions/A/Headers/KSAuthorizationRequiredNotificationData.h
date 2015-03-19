//
//  KSTOWebshopPaymentTokenResponse.h
//  kesh-ios-library
//
//  Created by A-Team on 07.08.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

@class KSTOAuthorizationRequiredNotification;
@class KSInitiator, KSAmount, KSUserData, KSVisualization;

@interface KSAuthorizationRequiredNotificationData : NSObject

@property(copy,readonly) NSString *type;
@property(copy,readonly) NSString *token;
@property(strong,readonly) KSInitiator *initiator;
@property(strong,readonly) KSAmount *payment;
@property(strong,readonly) KSUserData *userData;
@property(strong,readonly) KSVisualization *visualization;

- (id)initWithAuthorizationRequiredNotification:(KSTOAuthorizationRequiredNotification*)notification;

@end
