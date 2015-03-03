/*
 //  KSWebViewController.h
 //  KSKeshDemo
 //
 //  Created by Alexander Nöske on 15.10.14.
 //  Copyright (c) 2014 XCOM AG. All rights reserved.
 */
@interface KSWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithURL:(NSString *)url title:(NSString *)title cancelButton:(BOOL)showCancelButton;
- (id)initWithURL:(NSString *)url title:(NSString *)title cancelButton:(BOOL)showCancelButton zoomable:(BOOL)zoomable;

@end
