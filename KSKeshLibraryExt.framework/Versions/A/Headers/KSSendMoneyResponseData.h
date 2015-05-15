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
    KSSendMoneyError = 10,
    KSSendMoneyErrorReceiverUnknown = 11,
    KSSendMoneyErrorReceiverEqualsSender = 12,
    KSSendMoneyErrorUnderMinimumAmount = 13,
    KSSendMoneyErrorUpgradeNeeded = 14,
    KSSendMoneyErrorPhoneNumberNotConfirmed = 15,
    KSSendMoneyErrorReceiverNeedsVerify = 16,
    KSSendMoneyErrorReceiverNeedsUpgrade = 17,
    KSSendMoneyErrorReferenceAccountUnconfirmed = 18,
    KSSendMoneyErrorNotAllowed = 19,
    KSSendMoneyErrorNotEnoughMoney = 20,
    KSSendMoneyErrorMonthlyLimit = 21,
    KSSendMoneyErrorBookingError = 30,
    KSSendMoneyErrorInvalidPaypoint = 31
} KSSendMoneyErrorCodes;


@interface KSSendMoneyResponseData : KSResponseData

@property(strong,readonly) KSTransaction *transaction;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
