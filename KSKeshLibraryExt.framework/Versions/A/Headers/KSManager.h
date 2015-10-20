/*
//  KeshManager.h
//  kesh-ios-library
//
//  Created by Terry Dye on 18.02.13.
//  Copyright (c) 2013 XCOM AG. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KSCommunicatorDelegate.h"
#import "KSManagerDelegate.h"

@class KSCommunicator;
@class KSHostConfiguration;
@class KSUserData;
@class KSAmount;
@class KSAvatar;
@class KSImageData;
@class KSGroup;
@class KSPromoCodeResponseData;
@class KSListContactsResponseData;
@class KSSendMoneyResponseData;
@class KSLoginUserResponseData;
@class KSAccountBalanceResponseData;
@class KSChargeAccountResponseData;
@class KSDischargeAccountResponseData;
@class KSFetchAvatarResponseData;
@class KSSaveAvatarResponseData;
@class KSAddContactResponseData;
@class KSFetchUserDataResponseData;
@class KSRequestPaymentResponseData;
@class KSListTransactionsResponseData;
@class KSFetchMandateResponseData;
@class KSFetchMandatePreviewResponseData;
@class KSCreateMandateResponseData;
@class KSAddFavoriteResponseData;
@class KSConfirmPaymentResponseData;
@class KSListGroupsResponseData;
@class KSSaveGroupResponseData;
@class KSChangeGroupResponseData;

typedef void (^PromoCodeRequestSuccessBlock) (KSPromoCodeResponseData *data);
typedef void (^SendTokenSuccessBlock) ();
typedef void (^AuthorizationAnswerSuccessBlock) ();
typedef void (^ListContactsSuccessBlock) (KSListContactsResponseData *data);
typedef void (^AddContactSuccessBlock) (KSAddContactResponseData *data);
typedef void (^RemoveContactSuccessBlock) ();
typedef void (^SendMoneySuccessBlock) (KSSendMoneyResponseData *data);
typedef void (^LogoutUserSuccessBlock) ();
typedef void (^LoginUserSuccessBlock) (KSLoginUserResponseData *data);
typedef void (^AccountBalanceSuccessBlock) (KSAccountBalanceResponseData *data);
typedef void (^ChargeAccountSuccessBlock) (KSChargeAccountResponseData *data);
typedef void (^DischargeAccountSuccessBlock) (KSDischargeAccountResponseData *data);
typedef void (^FetchAvatarSuccessBlock) (KSFetchAvatarResponseData *data);
typedef void (^SaveAvatarSuccessBlock) (KSSaveAvatarResponseData *data);
typedef void (^ChangePasswordSuccessBlock) ();
typedef void (^ConfirmCentTransactionSuccessBlock) ();
typedef void (^FetchUserDataSuccessBlock) (KSFetchUserDataResponseData *data);
typedef void (^RequestPaymentSuccessBlock) (KSRequestPaymentResponseData *data);
typedef void (^ConfirmPaymentSuccessBlock) (KSConfirmPaymentResponseData *data);
typedef void (^ListTransactionsSuccessBlock) (KSListTransactionsResponseData *data);
typedef void (^ConfirmPhoneNumberSuccessBlock) ();
typedef void (^FetchMandateSuccessBlock) (KSFetchMandateResponseData *data);
typedef void (^FetchMandatePreviewSuccessBlock) (KSFetchMandatePreviewResponseData *data);
typedef void (^CreateMandateSuccessBlock) (KSCreateMandateResponseData *data);
typedef void (^ChangePhoneNumberSuccessBlock) ();
typedef void (^SaveGroupSuccessBlock) (KSSaveGroupResponseData *data);
typedef void (^ChangeGroupSuccessBlock) (KSChangeGroupResponseData *data);
typedef void (^RemoveGroupSuccessBlock) ();
typedef void (^ListGroupsSuccessBlock) (KSListGroupsResponseData *data);

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
- (void)sendKeepAlive;


#pragma mark - Server 2.0

/**
 *  Send a login request
 *
 *  @param phoneNumber  The user's phone number
 *  @param password     The user's password
 *  @param successBlock Block that is called when the login request was successful. All necessary info is returned in the KSLoginUserResponseData object.
 *  @param errorBlock   Block that is called when something went wrong during the login. The detailed information about the error can be optained via the NSError object.
 */
- (void)loginUserWithPhoneNumber:(NSString*)phoneNumber password:(NSString*)password onSuccess:(LoginUserSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

/**
 *  Send a logout request for the current user.
 *
 *  @param successBlock Block that is called when the login request was successful.
 *  @param errorBlock   Block that is called when something went wrong during the logout. The detailed information about the error can be optained via the NSError object.
 */
- (void)logoutUser:(LogoutUserSuccessBlock)successBlock onError:(ErrorBlock)error;

- (void)sendToken:(NSString*)token onSuccess:(SendTokenSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)authorizeRequest:(NSString *)token type:(NSString *)type onSuccess:(AuthorizationAnswerSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)declineRequest:(NSString *)token type:(NSString *)type onSuccess:(AuthorizationAnswerSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)sendPromoCode:(NSString *)promoCode onSuccess:(PromoCodeRequestSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)listContacts:(ListContactsSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)addContact:(NSString *)accountNumber onSuccess:(AddContactSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)removeContact:(NSString *)accountNumber onSuccess:(RemoveContactSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)sendMoney:(KSAmount *)amount toPhoneNumber:(NSString *)phoneNumber memo:(NSString*)memo externalTransactionId:(NSString *)externalTransactionId externalPictureUrl:(NSString *)externalPictureUrl onSuccess:(SendMoneySuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)sendMoney:(KSAmount *)amount toAccountNumber:(NSString *)accountNumber memo:(NSString*)memo externalTransactionId:(NSString *)externalTransactionId externalPictureUrl:(NSString *)externalPictureUrl onSuccess:(SendMoneySuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)sendMoney:(KSAmount *)amount toAccountNumber:(NSString *)accountNumber payPointId:(NSNumber*)payPointId memo:(NSString*)memo externalTransactionId:(NSString *)externalTransactionId externalPictureUrl:(NSString *)externalPictureUrl onSuccess:(SendMoneySuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)sendMoney:(KSAmount *)amount toUnknownPhoneNumber:(NSString *)phoneNumber memo:(NSString*)memo externalTransactionId:(NSString *)externalTransactionId externalPictureUrl:(NSString *)externalPictureUrl onSuccess:(SendMoneySuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)chargeAccountWithAmount:(KSAmount *)amount onSuccess:(ChargeAccountSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)dischargeAccountWithAmount:(KSAmount *)amount onSuccess:(DischargeAccountSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchAccountBalance:(AccountBalanceSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchOwnAvatarWithSize:(KSAvatarSize)size style:(KSAvatarStyle)style onSuccess:(FetchAvatarSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchAvatarForImageId:(NSNumber *)imageId size:(KSAvatarSize)size style:(KSAvatarStyle)style onSuccess:(FetchAvatarSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)saveAvatar:(KSImageData *)imageData onSuccess:(SaveAvatarSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword onSuccess:(ChangePasswordSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)confirmCentTransaction:(NSString *)activationCode onSuccess:(ConfirmCentTransactionSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchUserData:(FetchUserDataSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)requestPayment:(KSAmount *)amount fromPhoneNumber:(NSString *)phoneNumber memo:(NSString*)memo onSuccess:(RequestPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)requestPayment:(KSAmount *)amount fromAccountNumber:(NSString *)accountNumber memo:(NSString*)memo onSuccess:(RequestPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)confirmPayment:(NSNumber *)internalTransactionId onSuccess:(ConfirmPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)declinePayment:(NSNumber *)internalTransactionId onSuccess:(ConfirmPaymentSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)listTransactionsSince:(NSDate *)date onSuccess:(ListTransactionsSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)listTransactionsForPage:(NSNumber *)page onSuccess:(ListTransactionsSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)confirmPhoneNumber:(NSString *)phoneConfirmationCode onSuccess:(ConfirmPhoneNumberSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchMandate:(FetchMandateSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)fetchMandatePreview:(FetchMandatePreviewSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)createMandate:(CreateMandateSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)changePhoneNumber:(NSString *)phoneNumber onSuccess:(ChangePhoneNumberSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)saveGroup:(NSString *)groupName imageData:(KSImageData *)imageData groupMembers:(NSArray *)groupMembers onSuccess:(SaveGroupSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)changeGroup:(NSNumber *)groupId name:(NSString *)groupName imageData:(KSImageData *)imageData groupMembers:(NSArray *)groupMembers onSuccess:(ChangeGroupSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)removeGroup:(NSNumber *)groupId onSuccess:(RemoveGroupSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
- (void)listGroups:(ListGroupsSuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

#pragma mark - Session Accessors

- (NSString*)authenticationToken;
- (NSString*)phoneNumber;
- (NSString*)accountNumber;

@end

extern NSString *const KSManagerError;

typedef enum {
    KSMerchantRequiredCode,
    KSRequestTimedOutErrorCode = 2715
} KSManagerErrorCodes;

extern NSString *const KSAuthorizationRequiredNotification;
extern NSString *const KSPaymentInfoNotification;
extern NSString *const KSAccountBalanceNotification;
extern NSString *const KSInfoMessageNotification;
extern NSString *const KSUserUpgradedNotificationDataKey;

extern NSString *const KSAuthorizationRequiredNotificationDataKey;
extern NSString *const KSPaymentInfoNotificationDataKey;
extern NSString *const KSAccountBalanceNotificationDataKey;
extern NSString *const KSInfoMessageNotificationDataKey;
extern NSString *const KSUserUpgradedNotificationDataKey;