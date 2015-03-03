//
//  KSImageData.h
//  kesh-ios-library
//
//  Created by A-Team on 06.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSResponseData.h"

@interface KSImageData : NSObject

@property(copy,readonly) NSString *imageBase64String;
@property(copy,readonly) NSString *mimeType;

- (id)initWithImageBase64String:(NSString*)imageBase64String mimeType:(NSString *)mimeType;

@end
