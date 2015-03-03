/*
//  KSWebRegistrationViewController.h
//  KSKeshDemo
//
//  Created by Alexander Nöske on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
*/

#import "KSRegistrationDelegate.h"

@interface KSWebRegistrationViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *modalView;

- (id)initWithDelegate:(id<KSRegistrationDelegate>)delegate;
- (id)initUpgradeWithDelegate:(id<KSRegistrationDelegate>)delegate;

@end
