//
//  KSSaveAvatarResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 06.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@interface KSSaveAvatarResponseData : KSResponseData

@property (strong,readonly) NSNumber *imageId;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
