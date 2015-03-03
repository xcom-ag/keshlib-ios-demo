//
//  KSDischargeAccountResponseData.h
//  KSKeshLibrary
//
//  Created by A-Team on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSTransaction;

@interface KSDischargeAccountResponseData : KSResponseData

@property (strong,readonly) KSTransaction *transaction;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
