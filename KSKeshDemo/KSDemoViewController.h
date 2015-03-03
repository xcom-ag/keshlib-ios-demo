//
//  KSDemoViewController.h
//  KSKeshDemo
//
//  Created by Alexander Nöske on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSRegistrationDelegate.h"

@class KSUserDefaults;
@class KSAmount;
@class KSPaymentInfoNotificationData;
@class KSKeshClientManager;

@interface KSDemoViewController : UIViewController <KSRegistrationDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

- (instancetype)initWithManager:(KSKeshClientManager *)keshClientManager;

- (void)appendText:(NSString *)text;

- (void)didConnect;
- (void)connectionLost:(NSError *)error;
- (void)connectionClosed:(NSString *)message;

- (void)needsAuthentication;

- (void)didLogin:(KSUserDefaults *)userDefaults;
- (void)loginFailedWithError:(NSError *)error;

- (void)didLogout;
- (void)logoutFailedWithError:(NSError *)error;

- (void)didSendMoney:(NSNumber *)internal_transaction_id;
- (void)sendMoneyFailedWithError:(NSError *)error;

- (void)didChargeAccount:(KSAmount *)fee;
- (void)chargeAccountFailedWithError:(NSError *)error;

- (void)didDischargeAccount:(KSAmount *)fee;
- (void)dischargeAccountFailedWithError:(NSError *)error;

- (void)didFetchAccountBalance:(KSAmount *)balanceDechargable;
- (void)fetchAccountBalanceFailedWithError:(NSError *)error;

- (void)didFetchAvatar:(UIImage *)image;
- (void)fetchAvatarFailedWithError:(NSError *)error;

- (void)didSaveAvatar:(NSNumber *)imageId;
- (void)saveAvatarFailedWithError:(NSError *)error;

- (void)didChangePassword;
- (void)changePasswordFailedWithError:(NSError *)error;

- (void)didConfirmCentTransaction;
- (void)confirmCentTransactionFailedWithError:(NSError *)error;

- (void)didFetchUserData:(NSString *)accountNumber;
- (void)fetchUserDataFailedWithError:(NSError *)error;

- (void)didRequestPayment:(NSNumber *)transactionId;
- (void)requestPaymentFailedWithError:(NSError *)error;

- (void)didConfirmPayment;
- (void)confirmPaymentFailedWithError:(NSError *)error;

- (void)didDeclinePayment;
- (void)declinePaymentFailedWithError:(NSError *)error;

- (void)didListTransactions:(NSUInteger)count;
- (void)listTransactionsFailedWithError:(NSError *)error;

- (void)didConfirmPhoneNumber;
- (void)confirmPhoneNumberFailedWithError:(NSError *)error;

- (void)didFetchMandate:(NSString *)mandateReference;
- (void)fetchMandateFailedWithError:(NSError *)error;
- (void)didFetchMandatePreview:(NSString *)creditorName;
- (void)fetchMandatePreviewFailedWithError:(NSError *)error;
- (void)didCreateMandate:(NSString *)mandateReference;
- (void)createMandateFailedWithError:(NSError *)error;

- (void)accountBalanceNotificationReceived:(KSAmount *)balanceDechargable;
- (void)paymentInfoNotificationReceived:(KSPaymentInfoNotificationData *)paymentInfoNotification;

@end
