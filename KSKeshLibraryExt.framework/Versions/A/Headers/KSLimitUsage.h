//
//  KSLimitUsage.h
//  kesh-ios-library
//
//  Created by A-Team on 06.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSAmount;

typedef enum LimitType {
    LIMIT_TYPE_UNKNOWN = 0,
    BAREINZAHLUNG_TAG = 1,
    LASTSCHRIFT_MONAT = 2,
    LASTSCHRIFT_TAG = 3,
    PROMO_BAREINZAHLUNG_TAG = 4,
    UMSATZ_MONAT_IN = 5,
    UMSATZ_MONAT_OUT = 6,
} KSLimitType;

@interface KSLimitUsage : NSObject

@property(assign,readonly) KSLimitType limitType;
@property(copy,readonly) KSAmount *currentAmount;
@property(copy,readonly) KSAmount *maxAmount;

- (id)initWithLimitType:(NSString*)limitType currentAmount:(KSAmount *)currentAmount maxAmount:(KSAmount *)maxAmount;
- (float)percentage;
- (NSString *)actualString;
- (NSString *)maximumString;
- (NSString*)remainingString;

@end
