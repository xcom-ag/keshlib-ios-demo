//
//  PersonalData.h
//  kesh
//
//  Created by Alexander Nöske on 19.02.13.
//  Copyright (c) 2013 XCOM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KSAvatar;

typedef enum {
    GENDER_MALE = 1,
    GENDER_FEMALE = 2,
    GENDER_UNKNOWN = -1
} KSGender;

@interface KSPersonalData : NSObject

@property(copy,readonly)NSString *academicTitle;
@property(readonly)int gender;
@property(copy,readonly)NSString *firstName;
@property(copy,readonly)NSString *firstNames;
@property(copy,readonly)NSString *lastName;
@property(strong,readonly)NSDate *birthDate;
@property(copy,readonly)NSString *birthPlace;
@property(copy,readonly)NSString *birthName;
@property(copy,readonly)NSString *maritalStatus;
@property(copy,readonly)NSString *nationality;
@property(strong,readonly)NSNumber *imageId;

-(id)initWithAcademicTitle:(NSString*)title
                    gender:(KSGender)gender
                 firstName:(NSString*)firstName
                firstNames:(NSString*)firstNames
                  lastName:(NSString*)lastName
                 birthDate:(NSDate*)birthDate
                birthPlace:(NSString*)birthPlace
               nationality:(NSString*)nationality
                   imageId:(NSNumber*)imageId;

-(id)initWithAcademicTitle:(NSString*)title
                    gender:(KSGender)gender
                 firstName:(NSString*)firstName
                firstNames:(NSString*)firstNames
                  lastName:(NSString*)lastName
                 birthDate:(NSDate*)birthDate
                birthPlace:(NSString*)birthPlace
                 birthName:(NSString*)birthName
             maritalStatus:(NSString*)maritalStatus
               nationality:(NSString*)nationality;

- (NSString *)fullName;

@end
