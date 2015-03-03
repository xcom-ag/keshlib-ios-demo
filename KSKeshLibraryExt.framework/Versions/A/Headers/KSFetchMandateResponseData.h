//
//  KSFetchMandateResponseData.h
//  KSKeshLibrary
//
//  Created by A-Team on 23.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSResponseData.h"

@class KSUserData, KSCreditor;

@interface KSFetchMandateResponseData : KSResponseData

@property (copy,readonly) NSString *mandateStatus;
@property (copy,readonly) NSString *mandateType;
@property (strong,readonly) KSCreditor *creditor;
@property (strong,readonly) KSUserData *userData;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
