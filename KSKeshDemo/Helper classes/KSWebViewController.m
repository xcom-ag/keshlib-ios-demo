/*
//  KSWebViewController.m
//  KSKeshDemo
//
//  Created by Alexander Nöske on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
*/
#import "KSWebViewController.h"

@interface KSWebViewController ()

@property(strong, nonatomic) NSString *url;
@property(assign, nonatomic) BOOL showCancelButton;
@property(assign, nonatomic) BOOL zoomable;

@end

@implementation KSWebViewController

- (id)initWithURL:(NSString *)url title:(NSString *)title cancelButton:(BOOL)showCancelButton zoomable:(BOOL)zoomable {
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
        self.showCancelButton = showCancelButton;
        self.zoomable = zoomable;
    }
    return self;
}

- (id)initWithURL:(NSString *)url title:(NSString *)title cancelButton:(BOOL)showCancelButton {
    return [self initWithURL:url title:title cancelButton:showCancelButton zoomable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.zoomable) {
        self.webView.scalesPageToFit = YES;
    }
    
    if (self.showCancelButton) {        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Schließen", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
    
    NSURL *websiteURL = [NSURL URLWithString:self.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:websiteURL];
    
    [self.webView setDelegate:self];
    [self.webView.scrollView setBounces:NO];
    [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    [self.webView loadRequest:requestObj];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)dismiss {
    UIViewController *vc = self.navigationController.presentingViewController;
    if (vc) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController.view removeFromSuperview];
    }
}


#pragma mark - UI

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([self.title length] == 0) {
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = title;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"failed!");
}

@end
