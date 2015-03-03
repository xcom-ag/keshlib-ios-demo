//
//  UserData.h
//  kesh
//
//  Created by Alexander Nöske on 19.02.13.
//  Copyright (c) 2013 XCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSPersonalData;
@class KSAddress;
@class KSBankAccount;
@class KSContactInfo;
@class KSJobInfo;

@interface KSUserData : NSObject

@property(strong,nonatomic) KSPersonalData *personalData;
@property(strong,nonatomic) KSContactInfo *contactInfo;
@property(strong,nonatomic) KSAddress *address;
@property(strong,nonatomic) KSBankAccount *bankAccount;
@property(strong,nonatomic) KSJobInfo *jobInfo;
@property(copy,nonatomic) NSString *accountNumber;

- (id)initWithPersonalData:(KSPersonalData *)personalData
                   address:(KSAddress *)address
               bankAccount:(KSBankAccount *)bankAccount
               contactInfo:(KSContactInfo *)contactInfo
                   jobInfo:(KSJobInfo *)jobInfo
             accountNumber:(NSString *)accountNumber;

@end
