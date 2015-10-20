/*
//  KSPromoCodeResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 24.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
*/
#import "KSResponseData.h"

@interface KSPromoCodeResponseData : KSResponseData

@property (strong, readonly) NSString *message;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
