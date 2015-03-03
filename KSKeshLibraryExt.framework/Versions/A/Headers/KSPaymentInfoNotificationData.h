//
//  KSPaymentInfoNotificationData.h
//  kesh-ios-library
//
//  Created by A-Team on 07.08.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

@class KSTOPaymentInfoNotification, KSTransaction;

typedef enum {
    PAYMENTINFOTYPE_CONFIRM_PAYMENT,
    PAYMENTINFOTYPE_PAYMENT_CHANGED,
    PAYMENTINFOTYPE_PAYMENT_RECEIVED,
    PAYMENTINFOTYPE_UNSPECIFIED = -1
} KSPaymentInfoType;

@interface KSPaymentInfoNotificationData : NSObject

@property(assign,readonly) KSPaymentInfoType type;
@property(strong,readonly) KSTransaction *transaction;

- (id)initWithPaymentInfoNotification:(KSTOPaymentInfoNotification*)notification;

@end
