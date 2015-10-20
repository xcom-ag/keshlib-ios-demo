//
//  KSTransaction.h
//  kesh-ios-library
//
//  Created by A-Team on 2/27/13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TRANSACTION_KVO_STATUS_PATH @"status"

@class KSAmount;

typedef enum {
    TRANSACTIONSTATUS_PENDING,
    TRANSACTIONSTATUS_ACCEPTED,
    TRANSACTIONSTATUS_DECLINED,
    TRANSACTIONSTATUS_REVERSED,
    TRANSACTIONSTATUS_CLIENT_DECLINING,
    TRANSACTIONSTATUS_CLIENT_ACCEPTING,
    TRANSACTIONSTATUS_UNKNOWN = 99
} KSTransactionStatus;

typedef enum {
    TRANSACTIONTYPE_TRANSFER,
    TRANSACTIONTYPE_INCOMING_TRANSFER,
    TRANSACTIONTYPE_OUTGOING_TRANSFER,
    TRANSACTIONTYPE_CASH,
    TRANSACTIONTYPE_CASH_DEPOSIT,
    TRANSACTIONTYPE_PURCHASE,
    TRANSACTIONTYPE_ATM,
    TRANSACTIONTYPE_REVERSAL,
    TRANSACTIONTYPE_PROMOTION,
    TRANSACTIONTYPE_MONEY_IN,
    TRANSACTIONTYPE_MONEY_OUT,
    TRANSACTIONTYPE_BIRTHDAY_PRESENT,
    TRANSACTIONTYPE_EXTERNAL_INCOMING_TRANSFER,
    TRANSACTIONTYPE_WEBSHOP,
    TRANSACTIONTYPE_CASH_DEPOSIT_QUICK_LEGI,
    TRANSACTIONTYPE_UNKNOWN = 99
} KSTransactionType;

typedef enum {
    TRANSACTION_DIRECTION_UNKNOWN,
    TRANSACTION_DIRECTION_IN,
    TRANSACTION_DIRECTION_OUT
} KSTransactionDirection;

@interface KSTransaction : NSObject

@property(copy,readonly) NSString *accountNumber;
@property(strong,readonly) NSNumber *internalTransactionId;
@property(copy,readonly) NSString *externalTransactionId;
@property(copy,readonly) NSDate *transactionDate;
@property(copy,readonly) KSAmount *amount;
@property(copy,readonly) KSAmount *feeAmount;
@property(copy,readonly) NSString *displayText;
@property(copy,readonly) NSString *memo;
@property(strong,readonly) NSNumber *imageId;
@property(strong,readonly) NSNumber *reversableFlag;
@property(assign,nonatomic) KSTransactionStatus status;
@property(assign,readonly) KSTransactionType type;
@property(assign,readonly) KSTransactionDirection direction;
@property(strong,readonly) NSNumber *payPointId;
@property(copy,readonly) NSString *payPointName;

-(id)initWithAccountNumber:(NSString*)accountNumber
     internalTransactionId:(NSNumber*)internalTransactionId
     externalTransactionId:(NSString*)externalTransactionId
           transactionDate:(NSDate*)transactionDate
                    amount:(KSAmount*)amount
                 feeAmount:(KSAmount*)feeAmount
               displayText:(NSString*)displayText
                      memo:(NSString*)memo
                   imageId:(NSNumber*)imageId
            reversableFlag:(NSNumber*)reversableFlag
                    status:(KSTransactionStatus)status
                      type:(KSTransactionType)type
                 direction:(KSTransactionDirection)direction
                payPointId:(NSNumber*)payPointId
              payPointName:(NSString*)payPointName;
- (void)updateWithTransaction:(KSTransaction*)transaction;
- (BOOL)isReversable;


@end
