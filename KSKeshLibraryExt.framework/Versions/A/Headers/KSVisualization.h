//
//  KSVisualization.h
//  kesh-ios-library
//
//  Created by A-Team on 24.09.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSVisualization : NSObject

@property(copy,readonly) NSString *title;
@property(copy,readonly) NSString *displayData;
@property(copy,readonly) NSString *buttonText;

- (id)initWithTitle:(NSString*)title displayData:(NSString*)displayData buttonText:(NSString *)buttonText;

@end
