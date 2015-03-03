//
//  KSHostConfiguration.h
//  kesh-ios-library
//
//  Created by Terry Dye on 11.03.13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSHostConfiguration : NSObject

@property (copy) NSString *hostAddress;
@property int hostPort;
@property BOOL securedWithSSL;

@property (copy) NSString *leafCertPath;
@property (copy) NSString *clientCertChainPath;
@property (copy) NSString *chainPassphrase;

+ (id)hostConfigurationWithAddress:(NSString*)hostAddress port:(int)port securedWithSSL:(BOOL)securedWithFlag serverCertPath:(NSString *)serverCertPath clientCertChainPath:(NSString *)clientCertChainPath chainPassphrase:(NSString *)chainPassphrase;

@end
