//
//  KSGroupMember.h
//  KSKeshLibrary
//
//  Created by Alexander Nöske on 24.06.15.
//  Copyright (c) 2015 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSGroupMember : NSObject

@property(copy,readonly) NSString *accountNumber;
@property(copy,readonly) NSString *name;
@property(copy,readonly) NSString *phoneNumber;

- (id)initWithAccountNumber:(NSString*)accountNumber name:(NSString*)name phoneNumber:(NSString*)phoneNumber;

@end
