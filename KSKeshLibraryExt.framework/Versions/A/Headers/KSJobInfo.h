//
//  KSJobInfo.h
//  KSKeshLibrary
//
//  Created by A-Team on 25.11.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSJobInfo : NSObject

@property(copy,readonly) NSString *group;
@property(copy,readonly) NSString *position;
@property(copy,readonly) NSString *industrySector;

- (id)initWithGroup:(NSString*)group position:(NSString *)position industrySector:(NSString *)industrySector;

@end
