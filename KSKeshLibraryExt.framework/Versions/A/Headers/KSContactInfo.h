//
//  KSContactInfo.h
//  kesh-ios-library
//
//  Created by A-Team on 02.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSContactInfo : NSObject

@property(copy,readonly) NSString *phoneNumber;
@property(copy,readonly) NSString *eMail;

- (id)initWithPhoneNumber:(NSString*)phoneNumber
            eMail:(NSString *)eMail;

@end
