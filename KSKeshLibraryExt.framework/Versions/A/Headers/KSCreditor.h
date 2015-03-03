//
//  KSCreditor.h
//  KSKeshLibrary
//
//  Created by A-Team on 07.11.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSAddress;

@interface KSCreditor : NSObject

@property(copy,readonly) NSString *creditorId;
@property(copy,readonly) NSString *creditorName;
@property(strong,readonly) KSAddress *address;

- (id)initWithCreditorId:(NSString*)creditorId creditorName:(NSString*)creditorName address:(KSAddress*)address;

@end
