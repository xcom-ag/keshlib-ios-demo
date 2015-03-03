//
//  KeshManager.h
//  kesh-ios-library
//
//  Created by Terry Dye on 18.02.13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCommunicatorDelegate.h"
#import "KSManagerDelegate.h"

@class KSCommunicator;
@class KSHostConfiguration;
@class KSUserData;
@class KSAmount;
@class KSAvatar;
@class KSImageData;
@class KSSendMoneyResponseData;
@class KSLoginUserResponseData;
@class KSAccountBalanceResponseData;
@class KSChargeAccountResponseData;
@class KSDischargeAccountResponseData;
@class KSFetchAvatarResponseData;
@class KSSaveAvatarResponseData;
@class KSFetchUserDataResponseData;
@class KSRequestPaymentResponseData;
@class KSListTransactionsResponseData;
@class KSFetchMandateResponseData;
@class KSFetchMandatePreviewResponseData;
@class KSCreateMandateResponseData;

typedef void (^LoginUserSuccessBlock) (KSLoginUserResponseData *data);
typedef void (^LogoutUserSuccessBlock) ();
typedef void (^SendMoneySuccessBlock) (KSSendMoneyResponseData *data);
typedef void (^AccountBalanceSuccessBlock) (KSAccountBalanceResponseData *data);
typedef void (^ChargeAccountSuccessBlock) (KSChargeAccountResponseData *data);
typedef void (^DischargeAccountSuccessBlock) (KSDischargeAccountResponseData *data);
typedef void (^FetchAvatarSuccessBlock) (KSFetchAvatarResponseData *data);
typedef void (^SaveAvatarSuccessBlock) (KSSaveAvatarResponseData *data);
typedef void (^ChangePasswordSuccessBlock) ();
typedef void (^ConfirmCentTransactionSuccessBlock) ();
typedef void (^FetchUserDataSuccessBlock) (KSFetchUserDataResponseData *data);
typedef void (^RequestPaymentSuccessBlock) (KSRequestPaymentResponseData *data);
typedef void (^ConfirmPaymentSuccessBlock) ();
typedef void (^ListTransactionsSuccessBlock) (KSListTransactionsResponseData *data);
typedef void (^ConfirmPhoneNumberSuccessBlock) ();
typedef void (^FetchMandateSuccessBlock) (KSFetchMandateResponseData *data);
typedef void (^FetchMandatePreviewSuccessBlock) (KSFetchMandatePreviewResponseData *data);
typedef void (^CreateMandateSuccessBlock) (KSCreateMandateResponseData *data);

typedef void (^ErrorBlock) (NSError *error);

typedef enum {
    KSAvatarSizeSmall = 0,
    KSAvatarSizeMedium = 1,
    KSAvatarSizeLarge = 2
} KSAvatarSize;

typedef enum {
    KSAvatarStyleSquare = 0,
    KSAvatarStyleRounded = 1
} KSAvatarStyle;

typedef enum {
    KSSendMoneyErrorCode = 1,
    KSSendMoneyNotLoggedInCode = 2,
    KSSendMoneyNotEnoughMoneyCode = 4,
    KSSendMoneyReceiverUnknownCode = 8
} KSSendMoneyResponseHandlerErrorCode;

typedef enum {
    KSLoginError = 1,
    KSLoginDeserializationFailed = 2,
    KSLoginRequestFailed = 4,
    KSLoginBadPassword = 8,
    KSLoginUserUnknown = 16,
    KSLoginAccountNotActivated = 32,
    KSLoginNotLoggedIn = 64,
    KSLoginNeedsVersionUpdate = 99,
    KSLoginStatusUnknown = 128
} KSLoginResponseHandlerErrorCodes;

typedef enum {
    KSKeshTypePremium = 0,
    KSKeshTypeBasic = 1,
    KSKeshTypeStarter = 2,
    KSKeshTypeAfrica = 3
} KSKeshType;

#define kKeshTypeArray @"P", @"K", @"S", @"N", nil

extern NSString *const KSLoginResponseHandlerDomain;

@interface KSManager : NSObject <KSCommunicatorDelegate>

@property (weak, nonatomic) id<KSManagerDelegate> delegate;
@property (strong) KSCommunicator *communicator;
@property (strong) KSHostConfiguration *hostConfiguration;
@property (nonatomic) BOOL autoReconnect;

+ (id)managerWithAppType:(NSString*)appType appVersion:(NSString*)appVersion autoReconnect:(BOOL)autoReconnect;

#pragma mark - KSManager API Calls
- (void)connectWithHostConfiguration:(KSHostConfiguration*)hostConfig;
- (void)disconnect;
- (void)reconnect;
- (void)relogin;

#pragma mark - Server 2.0

- (void)loginUserWithPhoneNumber:(NSString*)phoneNumber password:(NSString*)password onSuccess:(LoginUserSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)logoutUser:(LogoutUserSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)sendMoney:(KSAmount *)amount toAccountNumber:(NSString *)accountNumber description:(NSString*)description externalTransactionId:(NSString *)externalTransactionId externalPictureUrl:(NSString *)externalPictureUrl onSuccess:(SendMoneySuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)sendMoney:(KSAmount *)amount toPhoneNumber:(NSString *)phoneNumber description:(NSString*)description externalTransactionId:(NSString *)externalTransactionId externalPictureUrl:(NSString *)externalPictureUrl onSuccess:(SendMoneySuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)chargeAccountWithAmount:(KSAmount *)amount onSuccess:(ChargeAccountSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)dischargeAccountWithAmount:(KSAmount *)amount onSuccess:(DischargeAccountSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchAccountBalance:(AccountBalanceSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchOwnAvatarWithSize:(KSAvatarSize)size style:(KSAvatarStyle)style onSuccess:(FetchAvatarSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchAvatarForImageId:(NSNumber *)imageId size:(KSAvatarSize)size style:(KSAvatarStyle)style onSuccess:(FetchAvatarSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)saveAvatar:(KSImageData *)imageData onSuccess:(SaveAvatarSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword onSuccess:(ChangePasswordSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)confirmCentTransaction:(NSString *)activationCode onSuccess:(ConfirmCentTransactionSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchUserData:(FetchUserDataSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)requestPayment:(KSAmount *)amount fromAccountNumber:(NSString *)accountNumber description:(NSString*)description onSuccess:(RequestPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)requestPayment:(KSAmount *)amount fromPhoneNumber:(NSString *)phoneNumber description:(NSString*)description onSuccess:(RequestPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)confirmPayment:(NSNumber *)internalTransactionId onSuccess:(ConfirmPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)declinePayment:(NSNumber *)internalTransactionId onSuccess:(ConfirmPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)listTransactionsSince:(NSDate *)date onSuccess:(ListTransactionsSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)listTransactionsForPage:(NSNumber *)page onSuccess:(ListTransactionsSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)confirmPhoneNumber:(NSString *)phoneConfirmationCode onSuccess:(ConfirmPhoneNumberSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchMandate:(FetchMandateSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchMandatePreview:(FetchMandatePreviewSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)createMandate:(CreateMandateSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

#pragma mark - Session Accessors

- (NSString*)authenticationToken;
- (NSString*)phoneNumber;
- (NSString*)accountNumber;

@end

extern NSString *const KSManagerError;

typedef enum {
    KSErrorLoginFailed,
    KSMerchantRequiredCode,
    KSRequestTimedOutErrorCode = 2715
} KSManagerErrorCodes;

extern NSString *const KSAvatarSizeThumbnailValue;
extern NSString *const KSAvatarSizeMediumValue;
extern NSString *const KSAvatarSizeLargeValue;
extern NSString *const KSAvatarStyleRoundedValue;
extern NSString *const KSAvatarStyleSquareValue;

extern NSString *const KSPaymentInfoNotification;
extern NSString *const KSAccountBalanceNotification;

extern NSString *const KSPaymentInfoNotificationDataKey;
extern NSString *const KSAccountBalanceNotificationDataKey;
