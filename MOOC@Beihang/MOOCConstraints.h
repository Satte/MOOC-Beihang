//
//  NSObject_MOOCConstraints_h.h
//  MOOC@Beihang
//
//  Created by Satte on 14-9-9.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Target_URL "http://mooc.buaa.edu.cn"
//#define Target_URL "http://192.168.11.95:8000"
//#define Target_URL "http://124.207.188.102:8000"
#define Target_Path "/mobile_api/"
//#define Target_Img_Path "/"


static NSString *const sMOOCInitNotification = @"init";
static NSString *const sMOOCLoginNotification = @"login";
static NSString *const sMOOCCourseNotification = @"course";
static NSString *const sMOOCCourseAboutNotification = @"about";
static NSString *const sMOOCCourseWareNotification = @"ware";
static NSString *const sMOOCCourseEnrollNotification = @"enroll";
static NSString *const sMOOCGetCourseEnrollmentNotification = @"enrollment";
static NSString *const sMOOCGetImageNotification = @"image";
static NSString *const sMOOCCourseID = @"course_id";
static NSString *const sMOOCIsValid = @"isValid";
static NSString *const sMOOCIsValidDate = @"isValidDate";
static NSString *const sMOOCDatebaseIsValid = @"is_valid";

static int const iMOOCValidTime = 300;
static int const iMOOCRequestTimeOut = 1000;
static int const iMOOCRequestTimeOutDownload = 1500;

