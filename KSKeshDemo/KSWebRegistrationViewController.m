/*
 //  KSWebRegistrationViewController.m
 //  KSKeshDemo
 //
 //  Created by Alexander Nöske on 15.10.14.
 //  Copyright (c) 2014 XCOM AG. All rights reserved.
 */
#import "KSWebRegistrationViewController.h"
#import "KSWebViewController.h"
#import "KSHelper.h"

#define CANCEL @"cancel"
#define MOBILE_NUMBER @"mobile_number"
#define REGISTRATION_STATE @"registration_state"
#define NEW_CUSTOMER_STATE @"new_customer_state"
#define PHONE_NUMBER_NIL @"none"

@interface KSWebRegistrationViewController ()

@property(strong, nonatomic) NSURLRequest *request;
@property(strong, nonatomic) NSURLConnection *urlConnection;
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) id<KSRegistrationDelegate> delegate;
@property(nonatomic) BOOL authenticated;

@end

@implementation KSWebRegistrationViewController

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Registrierung", nil);
        self.url = [[KSHelper appDelegate].clientManager registrationUrl];
        self.delegate = delegate;
    }
    return self;
}

- (id)initUpgradeWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Upgrade", nil);
        self.url = [[KSHelper appDelegate].clientManager upgradeUrl];
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Schließen", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    
    NSURL *websiteURL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:websiteURL];
    
    [self.webView setDelegate:self];
    [self.webView setDataDetectorTypes:UIDataDetectorTypeNone];
    [self.webView setScalesPageToFit:NO];
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setMultipleTouchEnabled:NO];
    
    [self.webView.scrollView setMultipleTouchEnabled:NO];
    [self.webView.scrollView setBounces:NO];
    [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    
    [self.webView loadRequest:request];
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [self setModalView:nil];
    [super viewDidUnload];
}


#pragma mark - Selectors

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - NSURLConnectionDelegate protocol

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge: challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.authenticated = YES;
    [self.webView loadRequest:_request];
    [self.urlConnection cancel];
}


#pragma mark - UIWebViewDelegate protocol

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Request to load %@", [[request URL] absoluteString]);
    if (!self.authenticated) {
        self.request = request;
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
        [self.urlConnection start];
        return NO;
    }
    
    if ([self isExitURL:request.URL]) {
        NSDictionary *parameters = [self parametersAsDictionary:request.URL];
        BOOL cancel = [[parameters objectForKey:CANCEL] boolValue];
        NSString *phoneNumber = [parameters objectForKey:MOBILE_NUMBER];
        
        void (^didRegisterBlock) (void) = nil;
        if ([self shouldLogin:cancel phoneNumber:phoneNumber]) {
            didRegisterBlock = ^{
                if ([self.delegate respondsToSelector:@selector(didRegister:)]) {
                    [self.delegate didRegister:phoneNumber];
                };
            };
        }
        
        [self dismissViewControllerAnimated:YES completion:didRegisterBlock];
        return NO;
        
    } else if ([self isStateChangedURL:request.URL]) {
        return NO;
        
    } else if ([[request.URL absoluteString] hasSuffix:@".pdf"]) {
        KSWebViewController *wv = [[KSWebViewController alloc] initWithURL:request.URL.absoluteString title:NSLocalizedString(@"Vertragsbedingungen", nil) cancelButton:NO];
        [self.navigationController pushViewController:wv animated:YES];
        return NO;
    }
    NSLog(@"Should start loading %@", [[request URL] absoluteString]);
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorCancelled) {
        NSLog(@"Canceled request: %@", [webView.request.URL absoluteString]);
    } else {
        [self setOverlayHidden:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Starting to download request: %@", [webView.request.URL absoluteString]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finished downloading request: %@", [webView.request.URL absoluteString]);
}


#pragma mark - Private methods

- (BOOL)shouldLogin:(BOOL)cancel phoneNumber:(NSString *)phoneNumber {
    return (!cancel && ![phoneNumber isEqualToString:PHONE_NUMBER_NIL] && ![KSHelper appDelegate].clientManager.isLoggedIn);
}

- (BOOL)isExitURL:(NSURL *)url {
    return [url.absoluteString hasPrefix:[[KSHelper appDelegate].clientManager registrationUrl]] && [url.path hasSuffix:@"/exit"];
}

- (BOOL)isStateChangedURL:(NSURL *)url {
    return [url.absoluteString hasPrefix:[[KSHelper appDelegate].clientManager registrationUrl]] && [url.path hasSuffix:@"/changed"];
}

- (NSDictionary *)parametersAsDictionary:(NSURL *)url {
    NSMutableDictionary * pairDictionary = [NSMutableDictionary dictionary];
    
    NSArray * pairs = [[url query] componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *tokens = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[tokens objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [[tokens objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [pairDictionary setObject:value forKey:key];
    }
    return pairDictionary;
}

- (void)setOverlayHidden:(BOOL)hidden {
    if (hidden) {
        [self.activityIndicator stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            [self.modalView setAlpha:0.0];
        }];
        
    } else {
        [self.activityIndicator startAnimating];
        [UIView animateWithDuration:0.0 animations:^{
            [self.modalView setAlpha:1.0];
        }];
    }
}

@end
