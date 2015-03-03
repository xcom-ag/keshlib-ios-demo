//
//  KSFetchAvatarResponseData.h
//  kesh-ios-library
//
//  Created by A-Team on 06.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@class KSImageData;

@interface KSFetchAvatarResponseData : KSResponseData

@property (strong,readonly) KSImageData *imageData;
@property (strong,readonly) NSNumber *imageId;

- (id)initWithDictionary:(NSDictionary*)dictionary error:(NSError**)error;

@end
