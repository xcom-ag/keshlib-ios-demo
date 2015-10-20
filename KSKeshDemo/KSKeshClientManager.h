//
//  KSKeshClientManager.h
//  KSKeshDemo
//
//  Created by Alexander Nöske on 15.10.14.
//  Copyright (c) 2014 XCOM AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KSKeshLibraryExt/KSManager.h>

@class KSAmount;
@class KSDemoViewController;

@interface KSKeshClientManager : NSObject

@property (nonatomic,strong) KSDemoViewController *uiDelegate;
@property (nonatomic,assign) BOOL isConnected;
@property (nonatomic,assign) BOOL isLoggedIn;

- (void)connect;
- (void)disconnect;
- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password;
- (void)logout;
- (void)   sendAmount:(KSAmount*)amount
        toPhoneNumber:(NSString *)phoneNumber
                 memo:(NSString*)memo
externalTransactionId:(NSString*)externalTransactionId
           pictureUrl:(NSString*)externalPictureUrl;
- (void)   sendAmount:(KSAmount*)amount
      toAccountNumber:(NSString *)accountNumber
                 memo:(NSString*)memo
externalTransactionId:(NSString*)externalTransactionId
           pictureUrl:(NSString*)externalPictureUrl;
- (void)chargeAccountWithAmount:(KSAmount *)amount;
- (void)dischargeAccountWithAmount:(KSAmount *)amount;
- (void)fetchAccountBalance;
- (void)fetchOwnAvatarWithSize:(KSAvatarSize)size style:(KSAvatarStyle)style;
- (void)fetchAvatarForImageId:(NSNumber *)imageId size:(KSAvatarSize)size style:(KSAvatarStyle)style;
- (void)saveAvatar:(KSImageData *)imageData;
- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;
- (void)confirmCentTransaction:(NSString *)activationCode;
- (void)sendToken:(NSString*)token;
- (void)authorizeRequest:(NSString *)token type:(NSString *)type;
- (void)declineRequest:(NSString *)token type:(NSString *)type;
- (void)sendPromoCode:(NSString *)promoCode;
- (void)listContacts;
- (void)addContact:(NSString *)egdt_nr;
- (void)removeContact:(NSString *)egdt_nr;
- (void)fetchUserData;
- (void)requestPayment:(KSAmount *)amount fromAccountNumber:(NSString *)accountNumber memo:(NSString*)memo;
- (void)requestPayment:(KSAmount *)amount fromPhoneNumber:(NSString *)phoneNumber memo:(NSString*)memo;
- (void)confirmPayment:(NSNumber *)internalTransactionId;
- (void)declinePayment:(NSNumber *)internalTransactionId;
- (void)listTransactionsSince:(NSDate *)date;
- (void)listTransactionsForPage:(NSNumber *)page;
- (void)confirmPhoneNumber:(NSString *)phoneConfirmationCode;
- (void)fetchMandate;
- (void)fetchMandatePreview;
- (void)createMandate;

- (NSString *)registrationUrl;
- (NSString *)upgradeUrl;

@end
