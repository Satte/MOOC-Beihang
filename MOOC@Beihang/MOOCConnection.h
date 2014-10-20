//
//  MOOCConnection.h
//  commTesting
//
//  Created by Satte on 14-8-19.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOOCCourseData.h"

enum {
    MOOCCourseEnroll = 1000,
    MOOCCourseUnEnroll
};



@interface MOOCConnection : NSObject
{
    NSURLSessionConfiguration *conf;
    NSURLSession *session;
    NSNotificationCenter *noti;
    MOOCCourseData *courseData;
}

- (void)MOOCInit;
- (void)MOOCLogin:(NSString *)user Pass:(NSString *)pass;
- (void)MOOCCourses;
- (void)MOOCGetCourseEnrollment;
- (void)MOOCCourseAbout:(NSString *)cid;
- (void)MOOCCourseware:(NSString *)cid;
- (void)MOOCCourseEnroll:(NSString *)cid action:(int)enroll;
- (void)MOOCGetImage:(NSString *)cid imagePath:(NSString *)path;
+ (id)sharedInstance;

@end
