/*
//  KeshManagerDelegate.h
//  kesh-ios-library
//
//  Created by Terry Dye on 18.02.13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
*/
#import <Foundation/Foundation.h>

@protocol KSManagerDelegate <NSObject>

@required

#pragma mark - Connection Feedback

- (void)connectionEstablished;
- (void)connectionLost:(NSError *)error;
- (void)connectionClosed:(NSString *)message;
- (void)needsAuthentication;

@end
