//
//  KSUserDefaults.h
//  kesh-ios-library
//
//  Created by Terry Dye on 21.01.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSManager.h"

@interface KSUserDefaults : NSObject

@property (nonatomic, getter = isInitialPin)            BOOL initialPin;
@property (nonatomic)                                   KSKeshType keshType;
@property (nonatomic, getter = isSmsConfirmed)          BOOL smsConfirmed;
@property (nonatomic, getter = isBankAccountConfirmed)  BOOL bankAccountConfirmed;
@property (nonatomic, getter = hasAcceptedAgb)          BOOL agbAccepted;
@property (nonatomic)                                   int behaviorLevel;
@property (nonatomic, getter = hasPhonebookSyncAccepted) BOOL phonebookSyncAccepted;
@property (nonatomic, getter = hasMandateReference)     BOOL mandateReference;
@property (nonatomic, getter = hasOneCtTransferred)     BOOL oneCtTransferred;

@end
