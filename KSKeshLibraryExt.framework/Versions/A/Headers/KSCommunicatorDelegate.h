//
//  KSCommunicatorDelegate.h
//  kesh-ios-library
//
//  Created by Terry Dye on 2/20/13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSResponse;

@protocol KSCommunicatorDelegate

- (void)connectionEstablished;
- (void)connectionLost:(NSError*)error;
- (void)connectionClosed:(NSString*)message;
- (void)connectionProblem:(NSError*)error;

- (void)needsAuthentication;

- (void)handleKeshResponse:(KSResponse *)response;

@end
