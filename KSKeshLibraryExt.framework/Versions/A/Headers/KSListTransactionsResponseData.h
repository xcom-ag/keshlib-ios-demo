/*
//  KSListTransactionsResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 22.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
*/
#import "KSResponseData.h"

@interface KSListTransactionsResponseData : KSResponseData

@property(copy, readonly) NSDate *lastUpdate;
@property(strong, readonly) NSNumber *perPage;
@property(strong, readonly) NSNumber *totalEntries;
@property(strong, readonly) NSNumber *currentPage;
@property(strong, readonly) NSArray *transactions;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
