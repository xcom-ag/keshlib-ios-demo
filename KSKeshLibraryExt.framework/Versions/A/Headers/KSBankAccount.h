//
//  BankAccount.h
//  kesh
//
//  Created by Alexander Nöske on 19.02.13.
//  Copyright (c) 2013 XCOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSBankAccount : NSObject

@property(copy, nonatomic) NSString *accountHolder;
@property(copy, nonatomic) NSString *accountNumber;
@property(copy, nonatomic) NSString *bankCode;
@property(copy, nonatomic) NSString *iban;
@property(copy, nonatomic) NSString *bic;
@property(copy, nonatomic) NSString *bankName;
@property(copy, nonatomic) NSString *mandateReference;
@property(strong, nonatomic) NSDate *mandateValidFrom;

- (id)initWithAccountHolder:(NSString *)accountHolder accountNumber:(NSString *)accountNumber bankCode:(NSString *)bankCode iban:(NSString *)iban bic:(NSString *)bic bankName:(NSString*)bankName mandateReference:(NSString *)mandateReference mandateValidFrom:(NSDate *)mandateValidFrom;
- (id)initWithAccountHolder:(NSString *)accountHolder iban:(NSString *)iban bic:(NSString *)bic bankName:(NSString*)bankName mandateReference:(NSString *)mandateReference mandateValidFrom:(NSDate *)mandateValidFrom;

@end
