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

/**
 *  Returns a KSHostConfiguration to use when establishing a connection with KSManager's connectWithHostConfiguration method.
 *
 *  @param hostAddress         The server's host address
 *  @param port                The server port to use
 *  @param securedWithFlag     YES if the connection is made over SSL
 *  @param serverCertPath      The local path to the server's leaf certificate
 *  @param clientCertChainPath The local path to the client certificate chain
 *  @param chainPassphrase     The passPhrase used to secure the client certificate chain
 *
 *  @return KSHostConfiguration
 */
+ (id)hostConfigurationWithAddress:(NSString*)hostAddress port:(int)port securedWithSSL:(BOOL)securedWithFlag serverCertPath:(NSString *)serverCertPath clientCertChainPath:(NSString *)clientCertChainPath chainPassphrase:(NSString *)chainPassphrase;

@end
