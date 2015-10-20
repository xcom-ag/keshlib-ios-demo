//
//  KSChangeGroupResponseData.h
//  KSKeshLibrary
//
//  Created by Alexander Nöske on 29.06.15.
//  Copyright (c) 2015 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSGroup;

@interface KSChangeGroupResponseData : KSResponseData

@property (strong, readonly) KSGroup *group;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
