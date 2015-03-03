//
//  KSKeshClientManager.m
//  KSKeshDemo
//
//  Created by Alexander Nöske on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import "KSKeshClientManager.h"
#import <KSKeshLibraryExt/KSKeshLibrary.h>
#import "KSDemoViewController.h"
#import "MF_Base64Additions.h"

@class KSUserDefaults;

@interface KSKeshClientManager () <KSManagerDelegate>

@property (nonatomic,strong)KSManager *keshManager;

@end

@implementation KSKeshClientManager

- (id)init {
    self = [super init];
    if (self) {
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        KSManager *manager = [KSManager managerWithAppType:@"keshlib-ios-demo" appVersion:appVersion autoReconnect:NO];
        [manager setDelegate:self];
        _keshManager = manager;
    }
    return self;
}

- (void)connect {
    // Add certificate filenames and passphrase
    KSHostConfiguration *hostConfiguration = [KSHostConfiguration hostConfigurationWithAddress:@"demo1.kesh.de"
                                                                                          port:743
                                                                                securedWithSSL:YES
                                                                                serverCertPath:[[NSBundle mainBundle] pathForResource:@"NAME DER DER-DATEI" ofType:@"der"]
                                                                           clientCertChainPath:[[NSBundle mainBundle] pathForResource:@"NAME DER P12-DATEI" ofType:@"p12"]
                                                                               chainPassphrase:@"PASSWORT FÜR P12-DATEI"];
    [_keshManager connectWithHostConfiguration:hostConfiguration];
}

- (void)disconnect{
    [self.keshManager disconnect];
}

- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password{
    [self.keshManager loginUserWithPhoneNumber:username password:password onSuccess:^(KSLoginUserResponseData *data) {
        [self didLogin:data.userDefaults];
    } onError:^(NSError *error) {
        [self loginFailedWithError:error];
    }];
}

- (void)logout{
    [self.keshManager logoutUser:^{
        [self didLogout];
    } onError:^(NSError *error) {
        [self logoutFailedWithError:error];
    }];
}

- (void)sendAmount:(KSAmount*)amount toPhoneNumber:(NSString *)phoneNumber description:(NSString*)description externalTransactionId:(NSString*)externalTransactionId pictureUrl:(NSString*)externalPictureUrl {
    [self.keshManager sendMoney:amount
                  toPhoneNumber:phoneNumber
                    description:description
          externalTransactionId:externalTransactionId
             externalPictureUrl:externalPictureUrl
                      onSuccess:^(KSSendMoneyResponseData *data) {
                          [self sendMoneySucceeded:data.transaction.internalTransactionId];
                      } onError:^(NSError *error) {
                          [self sendMoneyFailedWithError:error];
                      }];
}

- (void)sendAmount:(KSAmount*)amount toAccountNumber:(NSString *)accountNumber description:(NSString*)description externalTransactionId:(NSString*)externalTransactionId pictureUrl:(NSString*)externalPictureUrl {
    [self.keshManager sendMoney:amount
                toAccountNumber:accountNumber
                    description:description
          externalTransactionId:externalTransactionId
             externalPictureUrl:externalPictureUrl
                      onSuccess:^(KSSendMoneyResponseData *data) {
                          [self sendMoneySucceeded:data.transaction.internalTransactionId];
                      } onError:^(NSError *error) {
                          [self sendMoneyFailedWithError:error];
                      }];
}

- (void)chargeAccountWithAmount:(KSAmount *)amount {
    [self.keshManager chargeAccountWithAmount:amount onSuccess:^(KSChargeAccountResponseData *data) {
        [self didChargeAccount:data.transaction.feeAmount];
    } onError:^(NSError *error) {
        [self chargeAccountFailedWithError:error];
    }];
}

- (void)dischargeAccountWithAmount:(KSAmount *)amount {
    [self.keshManager chargeAccountWithAmount:amount onSuccess:^(KSChargeAccountResponseData *data) {
        [self didDischargeAccount:data.transaction.feeAmount];
    } onError:^(NSError *error) {
        [self dischargeAccountFailedWithError:error];
    }];
}

- (void)fetchAccountBalance {
    [self.keshManager fetchAccountBalance:^(KSAccountBalanceResponseData *data) {
        [self didFetchAccountBalance:data.balanceDechargable];
    } onError:^(NSError *error) {
        [self fetchAccountBalanceFailedWithError:error];
    }];
}

- (void)fetchOwnAvatarWithSize:(KSAvatarSize)size style:(KSAvatarStyle)style {
    [self.keshManager fetchOwnAvatarWithSize:size style:style onSuccess:^(KSFetchAvatarResponseData *data) {
        NSData *imageData = [NSData dataWithBase64String:data.imageData.imageBase64String];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [self didFetchAvatar:image];
    } onError:^(NSError *error) {
        [self fetchAvatarFailedWithError:error];
    }];
}

- (void)fetchAvatarForImageId:(NSNumber *)imageId size:(KSAvatarSize)size style:(KSAvatarStyle)style {
    [self.keshManager fetchAvatarForImageId:imageId size:size style:style onSuccess:^(KSFetchAvatarResponseData *data) {
        NSData *imageData = [NSData dataWithBase64String:data.imageData.imageBase64String];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [self didFetchAvatar:image];
    } onError:^(NSError *error) {
        [self fetchAvatarFailedWithError:error];
    }];
}

- (void)saveAvatar:(KSImageData *)imageData {
    [self.keshManager saveAvatar:imageData onSuccess:^(KSSaveAvatarResponseData *data) {
        [self didSaveAvatar:data.imageId];
    } onError:^(NSError *error) {
        [self saveAvatarFailedWithError:error];
    }];
}

- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword {
    [self.keshManager changePassword:oldPassword newPassword:newPassword onSuccess:^{
        [self didChangePassword];
    } onError:^(NSError *error) {
        [self changePasswordFailedWithError:error];
    }];
}

- (void)confirmCentTransaction:(NSString *)activationCode {
    [self.keshManager confirmCentTransaction:activationCode onSuccess:^{
        [self didConfirmCentTransaction];
    } onError:^(NSError *error) {
        [self confirmCentTransactionFailedWithError:error];
    }];
}

- (void)fetchUserData {
    [self.keshManager fetchUserData:^(KSFetchUserDataResponseData *data) {
        [self didFetchUserData:data.userData.accountNumber];
    } onError:^(NSError *error) {
        [self fetchUserDataFailedWithError:error];
    }];
}

- (void)requestPayment:(KSAmount *)amount fromAccountNumber:(NSString *)accountNumber description:(NSString*)description {
    [self.keshManager requestPayment:amount fromAccountNumber:accountNumber description:description onSuccess:^(KSRequestPaymentResponseData *data) {
        [self didRequestPayment:data.transaction.internalTransactionId];
    } onError:^(NSError *error) {
        [self requestPaymentFailedWithError:error];
    }];
}

- (void)requestPayment:(KSAmount *)amount fromPhoneNumber:(NSString *)phoneNumber description:(NSString*)description {
    [self.keshManager requestPayment:amount fromPhoneNumber:phoneNumber description:description onSuccess:^(KSRequestPaymentResponseData *data) {
        [self didRequestPayment:data.transaction.internalTransactionId];
    } onError:^(NSError *error) {
        [self requestPaymentFailedWithError:error];
    }];
}

- (void)confirmPayment:(NSNumber *)internalTransactionId {
    [self.keshManager confirmPayment:internalTransactionId onSuccess:^{
        [self didConfirmPayment];
    } onError:^(NSError *error) {
        [self confirmPaymentFailedWithError:error];
    }];
}

- (void)declinePayment:(NSNumber *)internalTransactionId {
    [self.keshManager declinePayment:internalTransactionId onSuccess:^{
        [self didDeclinePayment];
    } onError:^(NSError *error) {
        [self declinePaymentFailedWithError:error];
    }];
}

- (void)listTransactionsSince:(NSDate *)date {
    [self.keshManager listTransactionsSince:date onSuccess:^(KSListTransactionsResponseData *data) {
        [self didListTransactions:data.transactions.count];
    } onError:^(NSError *error) {
        [self listTransactionsFailedWithError:error];
    }];
}

- (void)listTransactionsForPage:(NSNumber *)page {
    [self.keshManager listTransactionsForPage:page onSuccess:^(KSListTransactionsResponseData *data) {
        [self didListTransactions:data.transactions.count];
    } onError:^(NSError *error) {
        [self listTransactionsFailedWithError:error];
    }];
}

- (void)confirmPhoneNumber:(NSString *)phoneConfirmationCode {
    [self.keshManager confirmPhoneNumber:phoneConfirmationCode onSuccess:^{
        [self didConfirmPhoneNumber];
    } onError:^(NSError *error) {
        [self confirmPhoneNumberFailedWithError:error];
    }];
}

- (void)fetchMandate {
    [self.keshManager fetchMandate:^(KSFetchMandateResponseData *data) {
        [self didFetchMandate:data.userData.bankAccount.mandateReference];
    } onError:^(NSError *error) {
        [self fetchMandateFailedWithError:error];
    }];
}

- (void)fetchMandatePreview {
    [self.keshManager fetchMandatePreview:^(KSFetchMandatePreviewResponseData *data) {
        [self didFetchMandatePreview:data.creditor.creditorName];
    } onError:^(NSError *error) {
        [self fetchMandatePreviewFailedWithError:error];
    }];
}

- (void)createMandate {
    [self.keshManager createMandate:^(KSCreateMandateResponseData *data) {
        [self didCreateMandate:data.mandateReference];
    } onError:^(NSError *error) {
        [self createMandateFailedWithError:error];
    }];
}

- (NSString *)registrationUrl {
    // Add your "partner" parameter to URL for external partners, example: https://demo1.kesh.de:444/kesh_mobile_oke/registrierung?partner=biw
    return @"https://demo1.kesh.de:444/kesh_mobile_oke/registrierung";
}

- (NSString *)upgradeUrl {
    return [NSString stringWithFormat:@"%@?sessionId=%@&target=upgrade", [self registrationUrl], [self.keshManager authenticationToken]];
}


#pragma mark - Connection Feedback

- (void)connectionEstablished {
    self.isConnected = YES;
    [self.uiDelegate didConnect];
}

- (void)connectionLost:(NSError *)error {
    self.isConnected = NO;
    [self.uiDelegate connectionLost:error];
}

- (void)connectionClosed:(NSString *)message {
    self.isConnected = NO;
    [self.uiDelegate connectionClosed:message];
}


#pragma mark - Login and Logout Feedback

- (void)didLogin:(KSUserDefaults *)userDefaults {
    self.isLoggedIn = YES;
    [self addObserver];
    [self.uiDelegate didLogin:userDefaults];
}

- (void)loginFailedWithError:(NSError *)error {
    self.isLoggedIn = NO;
    [self.uiDelegate loginFailedWithError:error];
}

- (void)didLogout {
    self.isLoggedIn = NO;
    [self removeObserver];
    [self.uiDelegate didLogout];
}

- (void)logoutFailedWithError:(NSError *)error {
    [self.uiDelegate logoutFailedWithError:error];
}


#pragma mark - Session feedback

- (void)needsAuthentication {
    [self.uiDelegate needsAuthentication];
}


#pragma mark - SendMoney feedback

- (void)sendMoneySucceeded:(NSNumber *)internal_transaction_id {
    [self.uiDelegate didSendMoney:internal_transaction_id];
}

- (void)sendMoneyFailedWithError:(NSError *)error {
    [self.uiDelegate sendMoneyFailedWithError:error];
}


#pragma mark - ChargeAccount feedback

- (void)didChargeAccount:(KSAmount *)fee {
    [self.uiDelegate didChargeAccount:fee];
}

- (void)chargeAccountFailedWithError:(NSError *)error {
    [self.uiDelegate chargeAccountFailedWithError:error];
}


#pragma mark - DischargeAccount feedback

- (void)didDischargeAccount:(KSAmount *)fee {
    [self.uiDelegate didDischargeAccount:fee];
}

- (void)dischargeAccountFailedWithError:(NSError *)error {
    [self.uiDelegate dischargeAccountFailedWithError:error];
}


#pragma mark - FetchAccountBalance feedback

- (void)didFetchAccountBalance:(KSAmount *)balanceDechargable {
    [self.uiDelegate didFetchAccountBalance:balanceDechargable];
}

- (void)fetchAccountBalanceFailedWithError:(NSError *)error {
    [self.uiDelegate fetchAccountBalanceFailedWithError:error];
}


#pragma mark - FetchAvatar feedback

- (void)didFetchAvatar:(UIImage *)image {
    [self.uiDelegate didFetchAvatar:image];
}

- (void)fetchAvatarFailedWithError:(NSError *)error {
    [self.uiDelegate fetchAvatarFailedWithError:error];
}


#pragma mark - SaveAvatar feedback

- (void)didSaveAvatar:(NSNumber *)imageId {
    [self.uiDelegate didSaveAvatar:imageId];
}

- (void)saveAvatarFailedWithError:(NSError *)error {
    [self.uiDelegate saveAvatarFailedWithError:error];
}


#pragma mark - ChangePassword feedback

- (void)didChangePassword {
    [self.uiDelegate didChangePassword];
}

- (void)changePasswordFailedWithError:(NSError *)error {
    [self.uiDelegate changePasswordFailedWithError:error];
}


#pragma mark - ConfirmCentTransaction feedback

- (void)didConfirmCentTransaction {
    [self.uiDelegate didConfirmCentTransaction];
}

- (void)confirmCentTransactionFailedWithError:(NSError *)error {
    [self.uiDelegate confirmCentTransactionFailedWithError:error];
}


#pragma mark - UserData feedback

- (void)didFetchUserData:(NSString *)accountNumber {
    [self.uiDelegate didFetchUserData:accountNumber];
}

- (void)fetchUserDataFailedWithError:(NSError *)error {
    [self.uiDelegate fetchUserDataFailedWithError:error];
}


#pragma mark - RequestPayment feedback

- (void)didRequestPayment:(NSNumber *)transactionId {
    [self.uiDelegate didRequestPayment:transactionId];
}

- (void)requestPaymentFailedWithError:(NSError *)error {
    [self.uiDelegate requestPaymentFailedWithError:error];
}


#pragma mark - ConfirmPayment feedback

- (void)didConfirmPayment {
    [self.uiDelegate didConfirmPayment];
}

- (void)confirmPaymentFailedWithError:(NSError *)error {
    [self.uiDelegate confirmPaymentFailedWithError:error];
}


#pragma mark - DeclinePayment feedback

- (void)didDeclinePayment {
    [self.uiDelegate didDeclinePayment];
}

- (void)declinePaymentFailedWithError:(NSError *)error {
    [self.uiDelegate declinePaymentFailedWithError:error];
}


#pragma mark - ListTransactions feedback

- (void)didListTransactions:(NSUInteger)count {
    [self.uiDelegate didListTransactions:count];
}

- (void)listTransactionsFailedWithError:(NSError *)error {
    [self.uiDelegate listTransactionsFailedWithError:error];
}


#pragma mark - ConfirmPhoneNumber feedback

- (void)didConfirmPhoneNumber {
    [self.uiDelegate didConfirmPhoneNumber];
}

- (void)confirmPhoneNumberFailedWithError:(NSError *)error {
    [self.uiDelegate confirmPhoneNumberFailedWithError:error];
}


#pragma mark - MandateHandling feedback

- (void)didFetchMandate:(NSString *)mandateReference {
    [self.uiDelegate didFetchMandate:mandateReference];
}

- (void)fetchMandateFailedWithError:(NSError *)error {
    [self.uiDelegate fetchMandateFailedWithError:error];
}

- (void)didFetchMandatePreview:(NSString *)creditorName {
    [self.uiDelegate didFetchMandatePreview:creditorName];
}

- (void)fetchMandatePreviewFailedWithError:(NSError *)error {
    [self.uiDelegate fetchMandatePreviewFailedWithError:error];
}

- (void)didCreateMandate:(NSString *)mandateReference {
    [self.uiDelegate didCreateMandate:mandateReference];
}

- (void)createMandateFailedWithError:(NSError *)error {
    [self.uiDelegate createMandateFailedWithError:error];
}


#pragma mark - Notification handling

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountBalanceNotificationReceived:) name:KSAccountBalanceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentInfoNotificationReceived:) name:KSPaymentInfoNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KSAccountBalanceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KSPaymentInfoNotification object:nil];
}

- (void)accountBalanceNotificationReceived:(NSNotification *)notification {
    KSAccountBalanceNotificationData *balanceNotification = [notification.userInfo objectForKey:KSAccountBalanceNotificationDataKey];
    [self.uiDelegate accountBalanceNotificationReceived:balanceNotification.balanceDechargable];
}

- (void)paymentInfoNotificationReceived:(NSNotification *)notification {
    KSPaymentInfoNotificationData *paymentInfoNotification = [notification.userInfo objectForKey:KSPaymentInfoNotificationDataKey];
    [self.uiDelegate paymentInfoNotificationReceived:paymentInfoNotification];
}


@end
