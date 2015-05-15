//
//  KSSendMoneyResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 30.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSTransaction;

typedef enum {
    KSConfirmPaymentError = 10,
    KSConfirmPaymentErrorReceiverUnknown = 11,
    KSConfirmPaymentErrorReceiverEqualsSender = 12,
    KSConfirmPaymentErrorUnderMinimumAmount = 13,
    KSConfirmPaymentErrorUpgradeNeeded = 14,
    KSConfirmPaymentErrorPhoneNumberNotConfirmed = 15,
    KSConfirmPaymentErrorReceiverNeedsVerify = 16,
    KSConfirmPaymentErrorReceiverNeedsUpgrade = 17,
    KSConfirmPaymentErrorReferenceAccountUnconfirmed = 18,
    KSConfirmPaymentErrorNotAllowed = 19,
    KSConfirmPaymentErrorNotEnoughMoney = 20,
    KSConfirmPaymentErrorMonthlyLimit = 21,
    KSConfirmPaymentErrorBookingError = 30
} KSConfirmPaymentErrorCodes;


@interface KSConfirmPaymentResponseData : KSResponseData

@property(strong,readonly) KSTransaction *transaction;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
