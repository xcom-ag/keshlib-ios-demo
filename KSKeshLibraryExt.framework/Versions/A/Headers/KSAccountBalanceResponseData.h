//
//  KSAccountBalanceResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 06.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSAmount;

@interface KSAccountBalanceResponseData : KSResponseData

@property (strong,readonly) KSAmount *balance;
@property (strong,readonly) KSAmount *balanceLocked;
@property (strong,readonly) KSAmount *balanceDechargable;
@property (strong,readonly) NSArray *limitUsages;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
