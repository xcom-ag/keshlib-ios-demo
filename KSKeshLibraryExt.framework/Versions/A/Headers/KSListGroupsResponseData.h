//
//  KSListGroupsResponseData.h
//  KSKeshLibrary
//
//  Created by Alexander Nöske on 25.06.15.
//  Copyright (c) 2015 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@interface KSListGroupsResponseData : KSResponseData

@property (strong, readonly) NSArray *groups;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
