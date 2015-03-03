//
//  KSDataFormatterCache.h
//  kesh-ios-library
//
//  Created by Terry Dye on 04.03.13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSDataFormatter : NSObject

+ (id)dataFormatter;
+ (id)dataFormatterWithLocale:(NSLocale*)locale;
- (id)initWithLocale:(NSLocale*)locale;

- (NSDate*)dateFromPOSIXLocalizedString:(NSString*)posixLocalizedString;
- (NSDate*)dateFromyyyyMMdd:(NSString*)yyyyMMdd;
- (NSDate*)dateFromString:(NSString*)dateString;
- (NSNumber*)numberFromDecimalStyleString:(NSString*)decimalStyleString;
- (NSString*)stringFromNumber:(NSNumber*)number withCurrency:(NSString*)currency;

@end

extern NSString *const NOT_AVAILABLE_TEXT;