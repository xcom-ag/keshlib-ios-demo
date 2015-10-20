//
//  KSContact.h
//  kesh-ios-library
//
//  Created by A-Team on 02.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSManager.h"

@interface KSContact : NSObject

@property(copy,readonly) NSString *phoneNumber;
@property(copy,readonly) NSString *accountNumber;
@property(copy,readonly) NSString *firstName;
@property(copy,readonly) NSString *lastName;
@property(copy,readonly) NSString *companyName;
@property(assign,readonly) KSKeshType keshType;
@property(strong,readonly) NSNumber *userId;
@property(strong,readonly) NSNumber *merchantFlag;
@property(strong,readonly) NSNumber *onContactListFlag;
@property(strong,readonly) NSNumber *favoriteFlag;
@property(strong,readonly) NSNumber *imageId;

- (id)initWithPhoneNumber:(NSString *)phoneNumber
            accountNumber:(NSString *)accountNumber
                   userId:(NSNumber *)userId
                firstName:(NSString *)firstName
                 lastName:(NSString *)lastName
              companyName:(NSString *)companyName
             merchantFlag:(NSNumber *)merchantFlag
        onContactListFlag:(NSNumber *)onContactListFlag
             favoriteFlag:(NSNumber *)favoriteFlag
                  imageId:(NSNumber *)imageId
                 keshType:(KSKeshType)keshType;
- (NSString *)name;
- (BOOL)isMerchant;
- (BOOL)isOnContactList;
- (BOOL)isFavorite;

@end
