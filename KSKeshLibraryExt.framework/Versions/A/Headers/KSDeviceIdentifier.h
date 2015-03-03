//
//  KSDeviceIdentifier.h
//  kesh-ios-library
//
//  Created by Terry Dye on 2/25/13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDeviceIdentifier : NSObject

+ (NSString*)uuid;

@end
extern NSString *const kKSDeviceIdentifier;
