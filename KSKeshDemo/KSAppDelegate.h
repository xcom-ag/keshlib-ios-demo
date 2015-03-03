//
//  KSAppDelegate.h
//  KSKeshDemo
//
//  Created by Alexander Nöske on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSKeshClientManager.h"

@interface KSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KSKeshClientManager *clientManager;

@end
