//
//  KSRequestPaymentResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 30.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSTransaction;

typedef enum {
    KSRequestPaymentError = 10,
    KSRequestPaymentErrorReceiverUnknown = 11,
    KSRequestPaymentErrorReceiverEqualsSender = 12,
    KSRequestPaymentErrorUnderMinimumAmount = 13,
    KSRequestPaymentErrorUpgradeNeeded = 14,
    KSRequestPaymentErrorPhoneNumberNotConfirmed = 15,
    KSRequestPaymentErrorReceiverNeedsVerify = 16,
    KSRequestPaymentErrorReceiverNeedsUpgrade = 17,
    KSRequestPaymentErrorReferenceAccountUnconfirmed = 18,
    KSRequestPaymentErrorNotAllowed = 19,
    KSRequestPaymentErrorNotEnoughMoney = 20,
    KSRequestPaymentErrorMonthlyLimit = 21,
    KSRequestPaymentErrorBookingError = 30
} KSRequestPaymentErrorCodes;

@interface KSRequestPaymentResponseData : KSResponseData

@property(strong,readonly) KSTransaction *transaction;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
