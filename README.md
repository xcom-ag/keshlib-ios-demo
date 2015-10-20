# keshlib-ios-demo (kesh-Framework und Demo-Projekt)
In den folgenden Abschnitten wird erläutert, wie das Framework in Ihr Projekt einzubinden ist und wie die grundlegenden Funktionen der Library verwendet werden können.

## Zugangsdaten und weiterführende Dokumentationen
Sollten Sie einen Zugang zu unserem Demo-System und später für die Produktionsumgebung wünschen, [wenden Sie sich bitte an unseren Support.](http://kesh.de/details-partnerintegration)
Dort erhalten Sie die für den Zugang benötigten Zertifikate.

Die Schnittstellendokumentation finden Sie unter folgendem Link: [kesh - Schnittstellenbeschreibung für Fremd-Apps.pdf](https://github.com/xcom-ag/keshlib-ios-demo/blob/master/kesh%20-%20Schnittstellenbeschreibung%20für%20Fremd-Apps.pdf?raw=true)

Sollten Sie auch die Registrierung für kesh einbinden wollen, finden Sie eine Beschreibung hierzu in folgendem Dokument: [kesh - Einbindung der Registrierung Fremd-App.pdf](https://github.com/xcom-ag/keshlib-ios-demo/blob/master/kesh%20-%20Einbindung%20der%20Registrierung%20Fremd-App.pdf?raw=true)

## Installation
1. Name des Frameworks: KSKeshLibraryExt.framework (im Demo-Projekt enthalten)
2. Legen Sie das Framework per Drag & Drop in der "Frameworks"-Gruppe ihres Projektes in Xcode ab. Achten Sie beim Import darauf, dass der Haken unter "Copy items into destination group’s folder" gesetzt ist.
3. Fügen Sie der Build-Phase "Link Binary With Libraries folgende Frameworks hinzu:
  * SystemConfiguration.framework
  * UIKit.framework
  * CFNetwork.framework
  * Security.framework
  * Foundation.framework
  * libicucore.dylib
4. Fügen Sie "-ObjC" in den Build Settings unter "Other Linker Flags" ein.
5. Fügen Sie ihr Zertifikat (.p12-Datei) dem Projekt per Drag & Drop hinzu. Achten Sie auch darauf, dass die Target Membership korrekt gesetzt wurde.
6. Fügen Sie ebenso das Server-Zertifikat (.der-Datei) hinzu.
7. Um die Klassen des Frameworks nutzen zu können, können Sie
* Den Convenience-Header mittels #import `<KSKeshLibraryExt/KSKeshLibrary>` importieren.
* Den Header der jeweiligen Klasse einzeln importieren:
```objectivec
#import <KSKeshLibrary/KSAccountBalanceNotificationData.h>
#import <KSKeshLibrary/KSAccountBalanceResponseData.h>
#import <KSKeshLibrary/KSAddContactResponseData.h>
#import <KSKeshLibrary/KSAddress.h>
#import <KSKeshLibrary/KSAmount.h>
#import <KSKeshLibrary/KSAuthorizationRequiredNotificationData.h>
#import <KSKeshLibrary/KSBankAccount.h>
#import <KSKeshLibrary/KSChangeGroupResponseData.h>
#import <KSKeshLibrary/KSChargeAccountResponseData.h>
#import <KSKeshLibrary/KSCommunicatorDelegate.h>
#import <KSKeshLibrary/KSConfirmPaymentResponseData.h>
#import <KSKeshLibrary/KSContact.h>
#import <KSKeshLibrary/KSContactInfo.h>
#import <KSKeshLibrary/KSCreateMandateResponseData.h>
#import <KSKeshLibrary/KSCreditor.h>
#import <KSKeshLibrary/KSDataFormatter.h>
#import <KSKeshLibrary/KSDeviceIdentifier.h>
#import <KSKeshLibrary/KSDischargeAccountResponseData.h>
#import <KSKeshLibrary/KSFetchAvatarResponseData.h>
#import <KSKeshLibrary/KSFetchMandatePreviewResponseData.h>
#import <KSKeshLibrary/KSFetchMandateResponseData.h>
#import <KSKeshLibrary/KSFetchUserDataResponseData.h>
#import <KSKeshLibrary/KSGroup.h>
#import <KSKeshLibrary/KSGroupMember.h>
#import <KSKeshLibrary/KSHostConfiguration.h>
#import <KSKeshLibrary/KSImageData.h>
#import <KSKeshLibrary/KSInfoMessageNotificationData.h>
#import <KSKeshLibrary/KSInitiator.h>
#import <KSKeshLibrary/KSJobInfo.h>
#import <KSKeshLibrary/KSLimitUsage.h>
#import <KSKeshLibrary/KSListContactsResponseData.h>
#import <KSKeshLibrary/KSListGroupsResponseData.h>
#import <KSKeshLibrary/KSListTransactionsResponseData.h>
#import <KSKeshLibrary/KSLoginUserResponseData.h>
#import <KSKeshLibrary/KSManager.h>
#import <KSKeshLibrary/KSManagerDelegate.h>
#import <KSKeshLibrary/KSPaymentInfoNotificationData.h>
#import <KSKeshLibrary/KSPersonalData.h>
#import <KSKeshLibrary/KSPromoCodeResponseData.h>
#import <KSKeshLibrary/KSRequestPaymentResponseData.h>
#import <KSKeshLibrary/KSResponseData.h>
#import <KSKeshLibrary/KSRetryTimeKeeper.h>
#import <KSKeshLibrary/KSSaveAvatarResponseData.h>
#import <KSKeshLibrary/KSSaveGroupResponseData.h>
#import <KSKeshLibrary/KSSendMoneyResponseData.h>
#import <KSKeshLibrary/KSTransaction.h>
#import <KSKeshLibrary/KSUserData.h>
#import <KSKeshLibrary/KSUserDefaults.h>
#import <KSKeshLibrary/KSVisualization.h>
```

##  Verbindungsaufbau & Abschicken von Requests
Um die Funktionen der kesh-Schnittstelle nutzen und Anfragen erfolgreich an den Server schicken zu können, muss zunächst die Verbindung zum kesh-Server hergestellt werden.
Hierzu wird zunächst eine KSHostConfiguration für den entsprechenden Server (Produktion/Demo) erstellt. Beispiel:
```objectivec
SHostConfiguration *hostConfiguration = [KSHostConfiguration hostConfigurationWithAddress:hostAdress 
                                                                                     port:port 
                                                                           securedWithSSL:securedWithSSL 
                                                                           serverCertPath:serverCertPathDER
                                                                      clientCertChainPath:certChainPathP12 
                                                                          chainPassphrase:chainPassphrase];
```
Die Zertifikate werden über den NSBundle-Pfad des Zertifikats mitgegeben. Um im Beispiel-Projekt eine Verbindung aufbauen zu können, müssen daher zwingend die Zertifikats-Dateien dem Projekt hinzugefügt werden. Für die Zertifikatskette muss zudem das entsprechende Passwort übergeben werden.
Die Zertifikate und das zugehörige Passwort erhalten Sie [unter o. g. Ansprechstelle](#zugangsdaten-und-weiterführende-dokumentationen).

Diese Konfiguration wird im Anschluss für den Verbindungsaufbau genutzt:
```objectivec
KSManager *mgr = [KSManager managerWithAppType:@"KeshDemo" 
                                    appVersion:@"1.0.5" 
                                 autoReconnect:NO];
[mgr setDelegate:self];
[mgr connectWithHostConfiguration:hostConfiguration];
```

Über die Delegate-Methoden wird das Delegate über den erfolgreichen Verbindungsaufbau (`connectionEstablished`), aber auch über Verbindungsabbrüche (`connectionLost` bei unbeabsichtigtem Verbindungsverlsut, `connectionClosed` nach vorherigem Aufruf von `disconnect`) informiert.

Die Bibliothek besitzt einen konfigurierbaren Reconnect-Mechanismus. Sollte die Verbindung zum Server gestört oder unterbrochen werden, so wird im eingeschalteten Modus versucht, diese Verbindung wieder aufzubauen. 

Der nächste Schritt ist der Login des Nutzers. Durch den Login erhält die kesh-Bibliothek ein Session-Token, welches dann automatisch für die weiteren Requests genutzt wird (andernfalls wird das Delegate über die Methode `needsAuthentication` über den nötigen Login informiert):
```objectivec
[mgr loginUserWithPhoneNumber:phoneNumber 
                     password:password 
                    onSuccess:^(KSLoginUserResponseData *data) {
                        self didLogin:data.userDefaults];
                    } onError:^(NSError *error) {
                        [self loginFailedWithError:error];
                    }
];
```

Die Response-Daten der jeweiligen Requests können im obigen Dokument eingesehen werden. Bis auf die Methoden zum Aufbau und Beenden der Verbindung sind alle Methoden mit Success- und Error-Blöcken ausgestattet.
Eine Implementierung aller Requests ist in diesem Demo-Projekt ersichtlich.

##  Notifications empfangen
Notifications werden durch die Library empfangen, verarbeitet und über das NSNotificationsCenter verteilt. Die Anmeldung für den Empfang einer solchen Notification erfolgt über die addObserver-Methode, z. B.:
```objectivec
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(accountBalanceNotificationReceived:)
                                             name:KSAccountBalanceNotification 
                                           object:nil];
```

Die Abmeldung erfolgt dementsprechend über die removeObserver-Methode:
```objectivec
[[NSNotificationCenter defaultCenter] removeObserver:self  
                                                name:KSAccountBalanceNotification
                                              object:nil];
```

Die an die jeweiligen Selektoren übergebenen Parameter vom Typ "NSNotification" enthalten innerhalb des userInfo-Dictionarys das jeweilige Datenobjekt zur Notification. Dieses kann über den entsprechenden Key ausgelesen werden, z. B.:
```objectivec
- (void)accountBalanceNotificationReceived:(NSNotification *)notification {
    KSAccountBalanceNotificationData *balanceNotification = [notification.userInfo bjectForKey:KSAccountBalanceNotificationDataKey];
}
```

###  Aktuell verfügbare Notification-Namen & -Keys
| Notification | name | object key |
| --- | --- | --- |
| Kontostand | KSAccountBalanceNotification | KSAccountBalanceNotificationDataKey |
| Zahlungsinformation | KSPaymentInfoNotification | KSPaymentInfoNotificationDataKey |
| Autorisierung angefordert (Zahlung/Adressdaten) | KSAuthorizationRequiredNotification | KSAuthorizationRequiredNotificationDataKey |
| Allgemeine Information | KSInfoMessageNotification | KSInfoMessageNotificationDataKey |
| Nutzer Upgrade | KSUserUpgradedNotificationDataKey | KSUserUpgradedNotificationDataKey |


