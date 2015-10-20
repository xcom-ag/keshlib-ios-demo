/*
//  KSListContactsResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 22.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
*/
#import "KSResponseData.h"

@interface KSListContactsResponseData : KSResponseData

@property (strong, readonly) NSArray *contacts;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
