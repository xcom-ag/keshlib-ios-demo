//
//  KSRetryTime.h
//  kesh-ios-library
//
//  Created by Terry Dye on 05.04.13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSRetryTimeKeeper : NSObject

- (void)reset;
- (void)retryFailed;
- (double)retryDelay;

@end
