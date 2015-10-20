//
//  KSGroup.h
//  KSKeshLibrary
//
//  Created by Alexander Nöske on 24.06.15.
//  Copyright (c) 2015 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSGroup : NSObject

@property (strong,readonly) NSNumber *groupId;
@property (copy,readonly) NSString *name;
@property (strong,readonly) NSNumber *imageId;
@property (strong,readonly) NSArray *groupMembers;

- (instancetype)initWithGroupId:(NSNumber*)groupId name:(NSString*)name imageId:(NSNumber*)imageId groupMembers:(NSArray*)groupMembers;

@end
