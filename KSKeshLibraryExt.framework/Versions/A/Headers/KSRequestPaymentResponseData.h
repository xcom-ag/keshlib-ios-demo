//
//  KSSendMoneyResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 30.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSTransaction;

@interface KSRequestPaymentResponseData : KSResponseData

@property(strong,readonly) KSTransaction *transaction;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
