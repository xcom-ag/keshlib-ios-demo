//
//  KSAddContactResponseData.h
//  KSKeshLibrary
//
//  Created by A-Team on 13.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSContact;

@interface KSAddContactResponseData : KSResponseData

@property (strong,readonly) KSContact *contact;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
