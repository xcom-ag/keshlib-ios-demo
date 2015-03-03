//
//  Address.h
//  kesh
//
//  Created by Alexander Nöske on 19.02.13.
//  Copyright (c) 2013 XCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSAddress : NSObject

@property(copy, nonatomic) NSString *street;
@property(copy, nonatomic) NSString *houseNumber;
@property(copy, nonatomic) NSString *postCode;
@property(copy, nonatomic) NSString *city;
@property(copy, nonatomic) NSString *country;
@property(copy, nonatomic) NSString *addressAddon;

- (id)initWithStreet:(NSString *)street houseNumber:(NSString *)houseNumber addressAddon:(NSString *)addressAddon postCode:(NSString *)postCode city:(NSString *)city country:(NSString *)country;
- (NSString *)fullStreet;
- (NSString *)fullCity;

@end
