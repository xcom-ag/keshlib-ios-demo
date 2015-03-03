//
//  KSRegistrationDelegate.h
//  KSKeshDemo
//
//  Created by Alexander Nöske on 16.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

@protocol KSRegistrationDelegate <NSObject>

- (void)didRegister:(NSString *)phoneNumber;

@end
