//
//  KSLoginResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 25.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSUserDefaults;

typedef enum {
    KSLoginUserErrorLoginDataWrong = 10,
    KSLoginUserErrorLoginAccountClosed = 11,
    KSLoginUserErrorLoginDataWrongWithMessage = 12,
    KSLoginUserErrorLoginNeedsVersionUpdate = 15
} KSLoginUserErrorCodes;

@interface KSLoginUserResponseData : KSResponseData

@property (copy, readonly) NSString *sessionToken;
@property (strong, readonly) NSNumber *userId;
@property (copy, readonly) NSString *accountNumber;
@property (readonly, getter = isMerchant) BOOL merchant;
@property (strong, readonly) KSUserDefaults *userDefaults;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
