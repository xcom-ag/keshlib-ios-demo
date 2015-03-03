/*
//  KeshAccount.h
//  kesh
//
//  Created by Alexander Nöske on 19.02.13.
//  Copyright (c) 2013 XCOM. All rights reserved.
*/
#import <Foundation/Foundation.h>

@interface KSAmount : NSObject

@property(copy,nonatomic) NSNumber *value;
@property(copy,readonly) NSString *currency;

+ (id)amountWithValue:(NSNumber *)value currency:(NSString *)currency;
- (id)initWithValue:(NSNumber *)value currency:(NSString *)currency;
- (NSString*)balanceString;

@end
