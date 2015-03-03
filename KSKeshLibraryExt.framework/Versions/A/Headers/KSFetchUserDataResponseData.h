//
//  KSFetchUserDataResponseData.h
//  KSKeshLibrary
//
//  Created by A-Team on 23.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSResponseData.h"

@class KSUserData;

@interface KSFetchUserDataResponseData : KSResponseData

@property (strong,readonly) KSUserData *userData;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
