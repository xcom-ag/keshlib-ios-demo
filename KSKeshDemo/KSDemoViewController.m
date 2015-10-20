//
//  KSDemoViewController.m
//  KSKeshDemo
//
//  Created by Alexander Nöske on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSDemoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <KSKeshLibraryExt/KSUserDefaults.h>
#import <KSKeshLibraryExt/KSAmount.h>
#import <KSKeshLibraryExt/KSTransaction.h>
#import <KSKeshLibraryExt/KSImageData.h>
#import <KSKeshLibraryExt/KSPaymentInfoNotificationData.h>
#import "KSKeshClientManager.h"
#import "KSWebRegistrationViewController.h"
#import "MF_Base64Additions.h"

@interface KSDemoViewController ()

@property (strong, nonatomic) KSKeshClientManager *keshClientManager;
@property (weak, nonatomic) IBOutlet UITextView  *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) NSMutableArray *imagePickerSources;
@property (strong, nonatomic) NSMutableArray *saveAvatarButtonTitles;
@property (strong, nonatomic) UIActionSheet *connectActionSheet;
@property (strong, nonatomic) UIActionSheet *saveAvatarActionSheet;
@property (strong, nonatomic) UIActionSheet *registrationActionSheet;
@property (strong, nonatomic) UIActionSheet *upgradeActionSheet;
@property (assign, nonatomic) BOOL pageControlBeingUsed;
@property (strong, nonatomic) UIAlertView *loginAlertView;
@property (strong, nonatomic) UIAlertView *sendMoneyAlertView;
@property (strong, nonatomic) UIAlertView *sendMoneyEnterAmountAlertView;
@property (strong, nonatomic) UIAlertView *changePasswordAlertView;
@property (strong, nonatomic) UIAlertView *authorizeRequestAlertView;
@property (strong, nonatomic) UIAlertView *declineRequestAlertView;
@property (strong, nonatomic) UIAlertView *requestPaymentAlertView;
@property (strong, nonatomic) UIAlertView *listTransactionsAlertView;
@property (strong, nonatomic) UIAlertView *fetchAvatarAlertView;
@property (strong, nonatomic) UIAlertView *confirmPhoneAlertView;
@property (strong, nonatomic) UIAlertView *confirmPaymentAlertView;
@property (strong, nonatomic) UIAlertView *declinePaymentAlertView;
@property (strong, nonatomic) UIAlertView *sendTokenAlertView;
@property (strong, nonatomic) UIAlertView *sendPromoCodeAlertView;
@property (assign, nonatomic) BOOL autoScrollTextView;

@end

@implementation KSDemoViewController

- (instancetype)initWithManager:(KSKeshClientManager *)keshClientManager {
    self = [super init];
    if (self) {
        keshClientManager.uiDelegate = self;
        self.keshClientManager = keshClientManager;
        self.autoScrollTextView = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"KSKeshDemo";
    
    self.pageControlBeingUsed = NO;
    
    [self.textView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.textView.layer setBorderWidth:1.5];
    
    self.imagePickerSources = [NSMutableArray array];
    self.saveAvatarButtonTitles = [NSMutableArray array];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.imagePickerSources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.saveAvatarButtonTitles addObject:@"Camera"];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.imagePickerSources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [self.saveAvatarButtonTitles addObject:@"Gallery"];
    }
    
    [self.contentView enableSubviews:NO ofType:[UIButton class]];
    self.connectButton.enabled = YES;
    self.registerButton.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!self.pageControlBeingUsed) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}

- (void)appendText:(NSString *)text {
    self.textView.text = [self.textView.text stringByAppendingString:text];
    if (self.autoScrollTextView) {        
        NSRange range = NSMakeRange(self.textView.text.length - 1, 1);
        [self.textView scrollRangeToVisible:range];
    }
}

- (IBAction)clearTextViewPressed:(id)sender {
    self.textView.text = @"";
}

- (IBAction)pageChanged {
    // Update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    // Keep track of when scrolls happen in response to the page control
    // value changing. If we don't do this, a noticeable "flashing" occurs
    // as the the scroll delegate will temporarily switch back the page
    // number.
    self.pageControlBeingUsed = YES;
}

#pragma mark - KeyBoardToolBar

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setInputAccessoryView:_keyboardToolBar];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - connect/disconnect

- (IBAction)connect:(id)sender {
     self.textView.text = [self.textView.text stringByAppendingString:@"\nConnectionAttempt ..."];
    [self.keshClientManager connect];    
}

- (IBAction)disconnect:(id)sender {
    [self appendText:@"\nDisconnecting ..."];
    [self.keshClientManager disconnect];
}

- (void)didConnect {
    [self appendText:@"\nconnected"];
    self.connectButton.enabled = NO;
    self.loginButton.enabled = YES;
    self.disconnectButton.enabled = YES;
}

- (void)connectionLost:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nconnection Lost: %@", [error localizedDescription]]];
    [self.contentView enableSubviews:NO ofType:[UIButton class]];
    self.connectButton.enabled = YES;
    self.registerButton.enabled = YES;
}

- (void)connectionClosed:(NSString *)message {
    [self appendText:[NSString stringWithFormat:@"\nconnection Closed: %@", message]];
    [self.contentView enableSubviews:NO ofType:[UIButton class]];
    self.connectButton.enabled = YES;
    self.registerButton.enabled = YES;
}

- (void)needsAuthentication {
    [self appendText:@"\nneeds authentication"];
    [self.contentView enableSubviews:NO ofType:[UIButton class]];
    self.loginButton.enabled = YES;
    self.disconnectButton.enabled = YES;
    self.registerButton.enabled = YES;
}


#pragma mark - login

- (IBAction)login:(id)sender {
    self.loginAlertView = [[UIAlertView alloc] initWithTitle:@"Login"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Login", nil];
    self.loginAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [self.loginAlertView textFieldAtIndex:0].placeholder = @"Phone number";    
    [self.loginAlertView textFieldAtIndex:1].placeholder = @"PIN";
    [self.loginAlertView show];
}

- (void)didLogin:(KSUserDefaults *)userDefaults {
    [self.contentView enableSubviews:YES];
    self.loginButton.enabled = NO;
    NSString* pin = [NSString stringWithFormat:@"isInitialPin: %@",userDefaults.isInitialPin ? @"YES" : @"NO"];
    NSString* bank = [NSString stringWithFormat:@"bankAccountConfirmed: %@",userDefaults.bankAccountConfirmed ? @"YES" : @"NO"];
    NSString* agb = [NSString stringWithFormat:@"agbAccepted: %@",userDefaults.agbAccepted ? @"YES" : @"NO"];
    NSString* mandate = [NSString stringWithFormat:@"hasMandateReference: %@",userDefaults.hasMandateReference ? @"YES" : @"NO"];
    NSString* oneCent = [NSString stringWithFormat:@"oneCentTransferred: %@",userDefaults.hasOneCtTransferred ? @"YES" : @"NO"];
    NSString *keshTypeString = @"";
    if (userDefaults.keshType == KSKeshTypePremium) {
        keshTypeString = @"Premium";
    } else if (userDefaults.keshType == KSKeshTypeStarter) {
        keshTypeString = @"Starter";
    } else if (userDefaults.keshType == KSKeshTypeBasic) {
        keshTypeString = @"Basic";
    } else {
        keshTypeString = @"Unknown";
    }
    NSString* keshType = [NSString stringWithFormat:@"keshType: %@", keshTypeString];
    NSString* userDef = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@\n%@\n%@",pin,bank,agb,mandate, oneCent, keshType];

    
    [self appendText:userDef];
}

- (void)loginFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nLogin failed: %@", [error localizedDescription]]];
}


#pragma mark - logout

- (IBAction)logout:(id)sender {
    [self appendText:@"\nLogoutAttempt ..."];
    [self.keshClientManager logout];
}

- (void)didLogout {
    [self appendText:@"\nLogout done..."];
    [self.contentView enableSubviews:NO ofType:[UIButton class]];
    self.loginButton.enabled = YES;
    self.disconnectButton.enabled = YES;
    self.registerButton.enabled = YES;
}

- (void)logoutFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nLogout failed: %@", [error localizedDescription]]];
}


#pragma mark - sendMoney

- (IBAction)sendMoney:(id)sender {
    self.sendMoneyAlertView = [[UIAlertView alloc] initWithTitle:@"Send Money"
                                                         message:@"Only one field!"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Send", nil];
    self.sendMoneyAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [self.sendMoneyAlertView textFieldAtIndex:0].placeholder = @"Phone number";
    [self.sendMoneyAlertView textFieldAtIndex:1].placeholder = @"Account number";
    [self.sendMoneyAlertView textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
    [self.sendMoneyAlertView textFieldAtIndex:1].secureTextEntry = NO;
    [self.sendMoneyAlertView show];
}

- (void)didSendMoney:(NSNumber *)internal_transaction_id {
    [self appendText:[NSString stringWithFormat:@"\nDid send money, transactionId: %@",internal_transaction_id]];
}

- (void)sendMoneyFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nsendMoney failed: %@", [error localizedDescription]]];
}


#pragma mark - chargeAccount

- (IBAction)chargeAccount:(id)sender {
    [self appendText:@"\nCharging account..."];
    KSAmount *amount = [KSAmount amountWithValue:@(10) currency:@"EUR"];
    [self.keshClientManager chargeAccountWithAmount:amount];
}

- (void)didChargeAccount:(KSAmount *)fee {
    [self appendText:[NSString stringWithFormat:@"\nDid charge account, fee: %@",[fee balanceString]]];
}

- (void)chargeAccountFailedWithError:(NSError *)error{
    [self appendText:[NSString stringWithFormat:@"\ncharge account failed: %@", [error localizedDescription]]];
}


#pragma mark - dischargeAccount

-(IBAction)dischargeAccount:(id)sender {
    [self appendText:@"\nDischarging account..."];
    KSAmount *amount = [KSAmount amountWithValue:@(10) currency:@"EUR"];
    [self.keshClientManager dischargeAccountWithAmount:amount];
}

- (void)didDischargeAccount:(KSAmount *)fee {
    [self appendText:[NSString stringWithFormat:@"\nDid discharge account, fee: %@",[fee balanceString]]];
}

- (void)dischargeAccountFailedWithError:(NSError *)error{
    [self appendText:[NSString stringWithFormat:@"\ndischarge account failed: %@", [error localizedDescription]]];
}


#pragma mark - fetchAccountBalance

- (IBAction)fetchAccountBalance:(id)sender {
    [self appendText:@"\nFetching account balance..."];
    [self.keshClientManager fetchAccountBalance];
}

- (void)didFetchAccountBalance:(KSAmount *)balanceDechargable {
    [self appendText:[NSString stringWithFormat:@"\nDechargable balance: %@",[balanceDechargable balanceString]]];
}

- (void)fetchAccountBalanceFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nFetching account balance failed: %@", [error localizedDescription]]];
}


#pragma mark - fetchAvatar

- (IBAction)fetchOwnAvatar {
    [self appendText:@"\nFetching own avatar..."];
    [self.keshClientManager fetchOwnAvatarWithSize:KSAvatarSizeSmall style:KSAvatarStyleRounded];
}

- (IBAction)fetchAvatar {
    self.fetchAvatarAlertView = [[UIAlertView alloc] initWithTitle:@"Fetch Avatar"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Fetch", nil];
    self.fetchAvatarAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.fetchAvatarAlertView textFieldAtIndex:0].placeholder = @"Avatar ID";
    [self.fetchAvatarAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [self.fetchAvatarAlertView show];
}

- (void)didFetchAvatar:(UIImage *)image {
    [self appendText:@"\nFetched avatar"];
    self.imageView.image = image;
}

- (void)fetchAvatarFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nFetching avatar failed: %@", [error localizedDescription]]];
}


#pragma mark - saveAvatar

- (IBAction)chooseImagePressed:(id)sender {
    if ([self.imagePickerSources count] > 0) {
        self.saveAvatarActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        for (NSString *title in self.saveAvatarButtonTitles) {
            [self.saveAvatarActionSheet addButtonWithTitle:title];
        }
        self.saveAvatarActionSheet.cancelButtonIndex = self.imagePickerSources.count;
        [self.saveAvatarActionSheet addButtonWithTitle:@"Cancel"];
        [self.saveAvatarActionSheet showInView:self.view];
    } else {
        [self appendText:@"no available image sources"];
    }
}

- (void)saveAvatar:(UIImage *)image {
    [self appendText:@"\nSaving avatar..."];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imageBase64String = [MF_Base64Codec base64StringFromData:imageData];
    KSImageData *avatarData = [[KSImageData alloc] initWithImageBase64String:imageBase64String mimeType:@"image/png"];
    [self.keshClientManager saveAvatar:avatarData];
}

- (void)didSaveAvatar:(NSNumber *)imageId {
    [self appendText:[NSString stringWithFormat:@"\nSaved avatar, new Id: %@", imageId]];
}

- (void)saveAvatarFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nSaving avatar failed: %@", [error localizedDescription]]];
}


#pragma mark - changePassword

- (IBAction)changePassword {
    self.changePasswordAlertView = [[UIAlertView alloc] initWithTitle:@"Change Password"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Change", nil];
    self.changePasswordAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [self.changePasswordAlertView textFieldAtIndex:0].placeholder = @"Old Password";
    [self.changePasswordAlertView textFieldAtIndex:1].placeholder = @"New Password";
    [self.changePasswordAlertView textFieldAtIndex:1].secureTextEntry = NO;
    [self.changePasswordAlertView show];
}

- (void)didChangePassword {
    [self appendText:@"\nChanged password"];
}

- (void)changePasswordFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nChanging password failed: %@", [error localizedDescription]]];
}


#pragma mark - confirmCentTransaction

- (IBAction)confirmCentTransaction {
    [self appendText:@"\nConfirming cent transaction..."];
    [self.keshClientManager confirmCentTransaction:@"12345"];
}

- (void)didConfirmCentTransaction {
    [self appendText:@"\nConfirmed cent transaction"];
}

- (void)confirmCentTransactionFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nConfirming cent transaction failed: %@", [error localizedDescription]]];
}


#pragma mark - sendToken

- (IBAction)sendToken:(id)sender {
    self.sendTokenAlertView = [[UIAlertView alloc] initWithTitle:@"Send Token"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Send", nil];
    self.sendTokenAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.sendTokenAlertView textFieldAtIndex:0].placeholder = @"Token";
    [self.sendTokenAlertView show];
}

- (void)didSendToken {
    [self appendText:@"\nToken sent"];
}

- (void)sendTokenFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nSending token failed: %@", [error localizedDescription]]];
}


#pragma mark - AuthorizeRequest

- (IBAction)authorizeRequest:(id)sender {
    self.authorizeRequestAlertView = [[UIAlertView alloc] initWithTitle:@"Authorize Request"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Authorize", nil];
    self.authorizeRequestAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.authorizeRequestAlertView textFieldAtIndex:0].placeholder = @"Token";
    [self.authorizeRequestAlertView show];
}

- (void)didAuthorizeRequest {
    [self appendText:@"\nAuthorized request"];
}

- (void)authorizeRequestFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nAuthorizing request failed: %@", [error localizedDescription]]];
}


#pragma mark - DeclineAuthorizationRequest

- (IBAction)declineAuthorizationRequest:(id)sender {
    self.declineRequestAlertView = [[UIAlertView alloc] initWithTitle:@"Decline Request"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Decline", nil];
    self.declineRequestAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.declineRequestAlertView textFieldAtIndex:0].placeholder = @"Token";
    [self.declineRequestAlertView show];
}

- (void)didDeclineRequest {
    [self appendText:@"\nDeclined request"];
}

- (void)declineRequestFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nDeclining request failed: %@", [error localizedDescription]]];
}


#pragma mark - sendPromoCode

- (IBAction)sendPromoCode:(id)sender {
    self.sendPromoCodeAlertView = [[UIAlertView alloc] initWithTitle:@"Send Promocode"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Send", nil];
    self.sendPromoCodeAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.sendPromoCodeAlertView textFieldAtIndex:0].placeholder = @"Promocode";
    [self.sendPromoCodeAlertView show];
}

- (void)didSendPromoCode:(NSString *)message {
    [self appendText:[NSString stringWithFormat:@"\nPromocode message: %@", message]];
}

- (void)sendPromoCodeFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nSending promocode failed: %@", [error localizedDescription]]];
}


#pragma mark - listContacts

- (IBAction)listContacts:(id)sender {
    [self appendText:@"\nFetching contact list..."];
    [self.keshClientManager listContacts];
}

- (void)didListContacts:(NSUInteger)count {
    [self appendText:[NSString stringWithFormat:@"\nContacts: %lu", (unsigned long)count]];
}

- (void)listContactsFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nListing contacts failed: %@", [error localizedDescription]]];
}


#pragma mark - addContact

- (IBAction)addContact:(id)sender {
    [self appendText:@"\nAdding contact..."];
    [self.keshClientManager addContact:@"015771487472"];
}

- (void)didAddContact:(NSString *)accountNumber {
    [self appendText:[NSString stringWithFormat:@"\nAdded contact: %@", accountNumber]];
}

- (void)addContactFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nAdding contact failed: %@", [error localizedDescription]]];
}


#pragma mark - removeContact

- (IBAction)removeContact:(id)sender {
    [self appendText:@"\nRemoving contact..."];
    [self.keshClientManager removeContact:@"015771487472"];
}

- (void)didRemoveContact {
    [self appendText:@"\nRemoved contact"];
}

- (void)removeContactFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nRemoving contact failed: %@", [error localizedDescription]]];
}


#pragma mark - fetchUserData

- (IBAction)fetchUserData:(id)sender {
    [self appendText:@"\nFetching user data..."];
    [self.keshClientManager fetchUserData];
}

- (void)didFetchUserData:(NSString *)accountNumber {
    [self appendText:[NSString stringWithFormat:@"\nFetched user data: %@", accountNumber]];
}

- (void)fetchUserDataFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nFetching user data failed: %@", [error localizedDescription]]];
}


#pragma mark - requestPayment

- (IBAction)requestPayment:(id)sender {
    self.requestPaymentAlertView = [[UIAlertView alloc] initWithTitle:@"Request payment"
                                                         message:@"Only one field!"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Request", nil];
    self.requestPaymentAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [self.requestPaymentAlertView textFieldAtIndex:0].placeholder = @"Phone number";
    [self.requestPaymentAlertView textFieldAtIndex:1].placeholder = @"Account number";
    [self.requestPaymentAlertView textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
    [self.requestPaymentAlertView textFieldAtIndex:1].secureTextEntry = NO;
    [self.requestPaymentAlertView show];
}

- (void)didRequestPayment:(NSNumber *)transactionId {
    [self appendText:[NSString stringWithFormat:@"\nRequested payment: %@", transactionId]];
}

- (void)requestPaymentFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nRequesting payment failed: %@", [error localizedDescription]]];
}


#pragma mark - confirmPayment

- (IBAction)confirmPayment:(id)sender {
    self.confirmPaymentAlertView = [[UIAlertView alloc] initWithTitle:@"Confirm Payment"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Confirm", nil];
    self.confirmPaymentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.confirmPaymentAlertView textFieldAtIndex:0].placeholder = @"Payment ID";
    [self.confirmPaymentAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [self.confirmPaymentAlertView show];
}

- (void)didConfirmPayment {
    [self appendText:@"\nConfirmed payment"];
}
- (void)confirmPaymentFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nSConfirming payment failed: %@", [error localizedDescription]]];
}


#pragma mark - declinePayment

- (IBAction)declinePayment:(id)sender {
    self.declinePaymentAlertView = [[UIAlertView alloc] initWithTitle:@"Decline Payment"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Decline", nil];
    self.declinePaymentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.declinePaymentAlertView textFieldAtIndex:0].placeholder = @"Payment ID";
    [self.declinePaymentAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [self.declinePaymentAlertView show];
}

- (void)didDeclinePayment {
    [self appendText:@"\nDeclined payment"];
}
- (void)declinePaymentFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nDeclining payment failed: %@", [error localizedDescription]]];
}


#pragma mark - listTransactions

- (IBAction)listTransactions:(id)sender {
    self.listTransactionsAlertView = [[UIAlertView alloc] initWithTitle:@"List Transactions"
                                                              message:@"Only one field!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Request", nil];
    self.listTransactionsAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [self.listTransactionsAlertView textFieldAtIndex:0].placeholder = @"For page (starting from 0)";
    [self.listTransactionsAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [self.listTransactionsAlertView textFieldAtIndex:1].placeholder = @"Since date (YYYY-MM-DD)";
    [self.listTransactionsAlertView textFieldAtIndex:1].secureTextEntry = NO;
    [self.listTransactionsAlertView show];
}

- (void)didListTransactions:(NSUInteger)count {
    [self appendText:[NSString stringWithFormat:@"\nTransactions: %lu", (unsigned long)count]];
}

- (void)listTransactionsFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nListing transactions failed: %@", [error localizedDescription]]];
}


#pragma mark - confirmPhoneNumber

- (IBAction)confirmPhoneNumber:(id)sender {
    self.confirmPhoneAlertView = [[UIAlertView alloc] initWithTitle:@"Confirm Phone Number"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Confirm", nil];
    self.confirmPhoneAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.confirmPhoneAlertView textFieldAtIndex:0].placeholder = @"Confirmation code";
    [self.confirmPhoneAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [self.confirmPhoneAlertView show];
}

- (void)didConfirmPhoneNumber {
    [self appendText:@"\nConfirmed phone number"];
}

- (void)confirmPhoneNumberFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nConfirming phone number failed: %@", [error localizedDescription]]];
}


#pragma mark - fetchMandate

- (IBAction)fetchMandate:(id)sender {
    [self appendText:@"\nFetching mandate..."];
    [self.keshClientManager fetchMandate];
}

- (void)didFetchMandate:(NSString *)mandateReference  {
    [self appendText:[NSString stringWithFormat:@"\nFetched mandate: %@", mandateReference]];
}

- (void)fetchMandateFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nFetching mandate failed: %@", [error localizedDescription]]];
}


#pragma mark - fetchMandatePreview

- (IBAction)fetchMandatePreview:(id)sender {
    [self appendText:@"\nFetching mandate preview..."];
    [self.keshClientManager fetchMandatePreview];
}

- (void)didFetchMandatePreview:(NSString *)creditorName  {
    [self appendText:[NSString stringWithFormat:@"\nFetched mandate preview for creditor: %@", creditorName]];
}

- (void)fetchMandatePreviewFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nFetching mandate preview failed: %@", [error localizedDescription]]];
}


#pragma mark - createMandate

- (IBAction)createMandate:(id)sender {
    [self appendText:@"\nCreating mandate..."];
    [self.keshClientManager createMandate];
}

- (void)didCreateMandate:(NSString *)mandateReference  {
    [self appendText:[NSString stringWithFormat:@"\nCreated mandate: %@", mandateReference]];
}

- (void)createMandateFailedWithError:(NSError *)error {
    [self appendText:[NSString stringWithFormat:@"\nCreating mandate failed: %@", [error localizedDescription]]];
}


#pragma mark - registration

- (IBAction)registerUser {
    [self appendText:@"\nRegister..."];
    KSWebRegistrationViewController *vc = [[KSWebRegistrationViewController alloc] initWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)upgradeUser {
    [self appendText:@"\nUpgrade..."];
    KSWebRegistrationViewController *vc = [[KSWebRegistrationViewController alloc] initUpgradeWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didRegister:(NSString *)phoneNumber {
    [self appendText:[NSString stringWithFormat:@"\nDid register, phone: %@", phoneNumber]];
}


#pragma mark - Notifications

- (void)accountBalanceNotificationReceived:(KSAmount *)balanceDechargable {
    [self appendText:[NSString stringWithFormat:@"\nNotification account balance: %@",[balanceDechargable balanceString]]];
}

- (void)paymentInfoNotificationReceived:(KSPaymentInfoNotificationData *)paymentInfoNotification {
    if (paymentInfoNotification.type == PAYMENTINFOTYPE_CONFIRM_PAYMENT) {
        [self appendText:[NSString stringWithFormat:@"\nNotification payment request: id %@, amount %@",paymentInfoNotification.transaction.internalTransactionId, paymentInfoNotification.transaction.amount.balanceString]];
    } else if (paymentInfoNotification.type == PAYMENTINFOTYPE_PAYMENT_CHANGED) {
        [self appendText:[NSString stringWithFormat:@"\nNotification payment changed: id %@, status %u",paymentInfoNotification.transaction.internalTransactionId, paymentInfoNotification.transaction.status]];
    } else if (paymentInfoNotification.type == PAYMENTINFOTYPE_PAYMENT_RECEIVED) {
        [self appendText:[NSString stringWithFormat:@"\nNotification payment received: type %u, amount %@",paymentInfoNotification.transaction.type, paymentInfoNotification.transaction.amount.balanceString]];
    }
}


#pragma mark - UIImagePickerControllerDelegate protocol

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *scaledImage = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
    [self.imageView setImage:scaledImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self saveAvatar:image];
}


#pragma mark - UIActionSheetDelegate protocol

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if ([actionSheet isEqual:self.saveAvatarActionSheet]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = [[self.imagePickerSources objectAtIndex:buttonIndex] integerValue];
            [imagePicker setDelegate:self];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([alertView isEqual:self.loginAlertView]) {
            [self appendText:@"\nLoginAttempt ..."];
            NSString *phoneNumber = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *password = [[alertView textFieldAtIndex:1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.keshClientManager loginWithUsername:phoneNumber andPassword:password];
            self.loginAlertView = nil;
        } else if ([alertView isEqual:self.sendMoneyAlertView]) {
            [self appendText:@"\nSending Money..."];
            KSAmount *amount = [KSAmount amountWithValue:@(1) currency:@"EUR"];
            NSString *phoneNumber = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *accountNumber = [[alertView textFieldAtIndex:1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (phoneNumber.length > 0) {
                [self.keshClientManager sendAmount:amount
                                     toPhoneNumber:phoneNumber
                                              memo:@"TestSendMoney"
                             externalTransactionId:@"Transaction123"
                                        pictureUrl:@"https://www.biw-bank.de/images/logo.png"];
            } else if (accountNumber.length > 0) {
                [self.keshClientManager sendAmount:amount
                                   toAccountNumber:accountNumber
                                              memo:@"TestSendMoney"
                             externalTransactionId:@"Transaction123"
                                        pictureUrl:@"https://www.biw-bank.de/images/logo.png"];
            }
            self.sendMoneyAlertView = nil;
        } else if ([alertView isEqual:self.changePasswordAlertView]) {
            [self appendText:@"\nChanging password..."];
            NSString *passwordOld = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *passwordNew = [[alertView textFieldAtIndex:1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.keshClientManager changePassword:passwordOld newPassword:passwordNew];
            self.changePasswordAlertView = nil;
        } else if ([alertView isEqual:self.authorizeRequestAlertView]) {
            [self appendText:@"\nAuthorizing request..."];
            NSString *token = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.keshClientManager authorizeRequest:token type:@"webshop_transfer_and_pay"];
            self.authorizeRequestAlertView = nil;
        } else if ([alertView isEqual:self.declineRequestAlertView]) {
            [self appendText:@"\nDeclining request..."];
            NSString *token = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.keshClientManager declineRequest:token type:@"webshop_transfer_and_pay"];
            self.declineRequestAlertView = nil;
        } else if ([alertView isEqual:self.requestPaymentAlertView]) {
            [self appendText:@"\nRequesting payment..."];
            KSAmount *amount = [KSAmount amountWithValue:@(1) currency:@"EUR"];
            NSString *phoneNumber = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *accountNumber = [[alertView textFieldAtIndex:1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (phoneNumber.length > 0) {
                [self.keshClientManager requestPayment:amount
                                       fromPhoneNumber:phoneNumber
                                                  memo:@"TestRequestMoney"];
            } else if (accountNumber.length > 0) {
                [self.keshClientManager requestPayment:amount
                                     fromAccountNumber:accountNumber
                                                  memo:@"TestRequestMoney"];
            }
            self.requestPaymentAlertView = nil;
        } else if ([alertView isEqual:self.listTransactionsAlertView]) {
            [self appendText:@"\nFetching transaction list..."];
            NSInteger page = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].integerValue;
            NSString *dateString = [[alertView textFieldAtIndex:1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (dateString.length > -1) {
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [self.keshClientManager listTransactionsSince:[formatter dateFromString:dateString]];
            } else if (page > -1) {
                [self.keshClientManager listTransactionsForPage:@(page)];
            }
            self.listTransactionsAlertView = nil;
        } else if ([alertView isEqual:self.fetchAvatarAlertView]) {
            NSString *avatarIdString = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSNumber *avatarId = @(avatarIdString.intValue);
            [self appendText:[NSString stringWithFormat:@"\nFetching avatar for number %@...", avatarId]];
            [self.keshClientManager fetchAvatarForImageId:avatarId size:KSAvatarSizeSmall style:KSAvatarStyleRounded];
            self.fetchAvatarAlertView = nil;
        } else if ([alertView isEqual:self.confirmPhoneAlertView]) {
            NSString *confirmationCode = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self appendText:[NSString stringWithFormat:@"\nConfirming phone numer with code %@...", confirmationCode]];
            [self.keshClientManager confirmPhoneNumber:confirmationCode];
            self.confirmPhoneAlertView = nil;
        } else if ([alertView isEqual:self.confirmPaymentAlertView]) {
            NSString *paymentIdString = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSNumber *paymentId = @(paymentIdString.intValue);
            [self appendText:[NSString stringWithFormat:@"\nConfirming payment with id %@...", paymentId]];
            [self.keshClientManager confirmPayment:paymentId];
            self.confirmPaymentAlertView = nil;
        } else if ([alertView isEqual:self.declinePaymentAlertView]) {
            NSString *paymentIdString = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSNumber *paymentId = @(paymentIdString.intValue);
            [self appendText:[NSString stringWithFormat:@"\nDeclining payment with id %@...", paymentId]];
            [self.keshClientManager declinePayment:paymentId];
            self.declinePaymentAlertView = nil;
        } else if ([alertView isEqual:self.sendTokenAlertView]) {
            [self appendText:@"\nSending token..."];
            NSString *token = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.keshClientManager sendToken:token];
            self.sendTokenAlertView = nil;
        } else if ([alertView isEqual:self.sendPromoCodeAlertView]) {
            [self appendText:@"\nSending promocode..."];
            NSString *promoCode = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [self.keshClientManager sendPromoCode:promoCode];
            self.sendPromoCodeAlertView = nil;
        }
    }
}


#pragma mark - Private methods

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    float deviceScaleFactor = 1.0;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        deviceScaleFactor = [UIScreen mainScreen].scale;
    }
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    } else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height * deviceScaleFactor;
        scaledSize.width = newSize.width / scaleFactor * deviceScaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


@end
