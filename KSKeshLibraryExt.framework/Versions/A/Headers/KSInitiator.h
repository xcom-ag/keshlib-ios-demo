//
//  KSInitiator.h
//  kesh-ios-library
//
//  Created by A-Team on 02.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSInitiator : NSObject

@property(copy,readonly) NSString *name;
@property(copy,readonly) NSString *accountNumber;
@property(copy,readonly) NSString *webshopUrl;
@property(copy,readonly) NSString *shopCustomerSession;
@property(strong,readonly) NSNumber *shopId;
@property(strong,readonly) NSNumber *imageId;

- (id)initWithAccountNumber:(NSString*)accountNumber name:(NSString *)name shopId:(NSNumber *)shopId webshopUrl:(NSString *)webshopUrl shopCustomerSession:(NSString *)shopCustomerSession imageId:(NSNumber *)imageId;

@end
