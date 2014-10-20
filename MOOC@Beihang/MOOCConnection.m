//
//  MOOCConnection.m
//  commTesting
//
//  Created by Satte on 14-8-19.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "MOOCConnection.h"

__strong static MOOCConnection *sharedInstance = nil;

/*
@interface MOOCConnection ()
- (BOOL)refreshCookie:(NSURLResponse *)res From:(NSURL *)url;
- (void)getFile:(NSString *)url parameter:(NSString *)param sender:(NSString *)sid;
- (void)sendHTTPGetRequest:(NSURL *)url parameter:(NSString *)param sender:(NSString *)sid;
- (void)sendHTTPPostRequest:(NSURL *)url parameter:(NSString *)param sender:(NSString *)sid;
@end
*/
/*
 notiDict Format:
 status: BOOL
 statusCode: int
 Error: errString
 courseid: NSString
 */
@implementation MOOCConnection

- (id)init
{
    self = [super init];
    if (self)
    {
        conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        conf.timeoutIntervalForRequest = iMOOCRequestTimeOut;
        conf.timeoutIntervalForResource = iMOOCRequestTimeOutDownload;
        session = [NSURLSession sessionWithConfiguration:conf];
        noti = [NSNotificationCenter defaultCenter];
        courseData = [MOOCCourseData sharedInstance];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:nil] init];
    });
    return sharedInstance;
}

- (void)MOOCInit
{
    NSURL *addr = [NSURL URLWithString:[NSString stringWithFormat:@"%s%sinit",Target_URL,Target_Path]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:addr completionHandler:^(NSData *data, NSURLResponse *res, NSError *err)
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
        int code = [httpres statusCode];
        if(code>=400 || err)
        {
            //NSDictionary *sendDict = @{@"statusCode":[NSString stringWithFormat:@"%d",code],@"error":err};
            [notiDict setObject:@"0" forKey:@"status"];
        }
        else
        {
            NSArray *arr = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpres allHeaderFields] forURL:addr];
            NSString *token = nil;
            for (NSHTTPCookie *cookie in arr)
            {
                BOOL isToken = [[[cookie name] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"csrftoken"];
                NSString *value = [[cookie value] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (isToken && value && ![value isEqualToString:@""]) token = value;
            }
            if (token)
            {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"X-CSRFToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [notiDict setObject:@"1" forKey:@"status"];
            }
            else
            {
                [notiDict setObject:@"0" forKey:@"status"];
            }
        }
        [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
        [notiDict setObject:(err?[err localizedDescription]:@"") forKey:@"error"];
        [noti postNotificationName:sMOOCInitNotification object:self userInfo:notiDict];
    }];
    [task resume];
}

- (void)MOOCLogin:(NSString *)user Pass:(NSString *)pass
{
    NSURL *addr = [NSURL URLWithString:[NSString stringWithFormat:@"%s%slogin",Target_URL,Target_Path]];
    NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"X-CSRFToken"] stringByReplacingOccurrencesOfString:@" " withString:@""];
#warning 写死
    //NSString *args = [NSString stringWithFormat:@"email=%@&password=%@",user,pass];
    NSString *args = [NSString stringWithFormat:@"email=staff@mooc.buaa.edu.cn&password=BSy8oLrn"];
    user = @"staff@mooc.buaa.edu.cn";
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:addr];
    [urlReq setHTTPMethod:@"POST"];
    [urlReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    [urlReq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [urlReq addValue:token forHTTPHeaderField:@"X-CSRFToken"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq completionHandler:^(NSData *data, NSURLResponse *res, NSError *err)
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
        int code = [httpres statusCode];
        if(code>=400)
        {
            [notiDict setObject:@"0" forKey:@"status"];
        }
        else
        {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [dict setObject:user forKey:@"mail_address"];
            BOOL success = [[dict objectForKey:@"success"] boolValue];
            if (success)
            {
                [courseData insertUserInfoWithData:dict];
                [notiDict setObject:@"1" forKey:@"status"];
            }
            else
            {
                [notiDict setObject:@"0" forKey:@"status"];
            }
        }
        [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
        [notiDict setObject:(err?[err localizedDescription]:@"") forKey:@"error"];
        [noti postNotificationName:sMOOCLoginNotification object:self userInfo:notiDict];
    }];
    [task resume];
}

- (void)MOOCCourses
{
    //if ([[MOOCCourseData sharedInstance] checkValid])
    if (false)
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        NSArray *arr = [[MOOCCourseData sharedInstance] getCourseData];
        [notiDict setObject:arr forKey:@"courseArray"];
        [notiDict setObject:@"1" forKey:@"status"];
        [notiDict setObject:@"200" forKey:@"statusCode"];
        [notiDict setObject:@"" forKey:@"error"];
        [noti postNotificationName:sMOOCCourseNotification object:self userInfo:notiDict];
    }
    else
    {
        NSURL *addr = [NSURL URLWithString:[NSString stringWithFormat:@"%s%scourses",Target_URL,Target_Path]];
        NSURLSessionDataTask *task = [session dataTaskWithURL:addr completionHandler:^(NSData *data, NSURLResponse *res, NSError *err)
        {
            NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
            NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
            int code = [httpres statusCode];
            if(code>=400)
            {
                [notiDict setObject:@"0" forKey:@"status"];
            }
            else
            {
                [courseData deleteCourse:nil];
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [notiDict setObject:arr forKey:@"courseArray"];
                for (NSDictionary *dict in arr)
                    [courseData insertCourseWithData:dict];
                [notiDict setObject:@"1" forKey:@"status"];
            }
            [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
            [notiDict setObject:(err?[err localizedDescription]:@"") forKey:@"error"];
            [noti postNotificationName:sMOOCCourseNotification object:self userInfo:notiDict];
            //NSLog(@"Finished");
        }];
        [task resume];
    }
}


- (void)MOOCCourseAbout:(NSString *)cid
{
    if ([[MOOCCourseData sharedInstance] checkValid:cid]&&[[[[MOOCCourseData sharedInstance] getCourseData:cid withSections:NO] objectForKey:@"about"] length]>10)
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        [notiDict setObject:@"1" forKey:@"status"];
        [notiDict setObject:cid forKey:sMOOCCourseID];
        [notiDict setObject:@"200" forKey:@"statusCode"];
        [notiDict setObject:@"" forKey:@"error"];
        [noti postNotificationName:sMOOCCourseAboutNotification object:self userInfo:notiDict];
    }
    else
    {
        NSURL *addr = [NSURL URLWithString:[NSString stringWithFormat:@"%s%scourse_about",Target_URL,Target_Path]];
        NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"X-CSRFToken"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *args = [NSString stringWithFormat:@"course_id=%@",cid];
        
        NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:addr];
        [urlReq setHTTPMethod:@"POST"];
        [urlReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
        [urlReq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [urlReq addValue:token forHTTPHeaderField:@"X-CSRFToken"];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq completionHandler:^(NSData *data, NSURLResponse *res, NSError *err)
        {
            NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
            NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
            int code = [httpres statusCode];
            if(code>=400)
            {
                [notiDict setObject:@"0" forKey:@"status"];
            }
            else
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [courseData updateCourse:cid withData:dict];
                [notiDict setObject:@"1" forKey:@"status"];
            }
            [notiDict setObject:cid forKey:sMOOCCourseID];
            [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
            [notiDict setObject:(err?[err localizedDescription]:@"") forKey:@"error"];
            [noti postNotificationName:sMOOCCourseAboutNotification object:self userInfo:notiDict];
        }];
        [task resume];
    }
}

- (void)MOOCCourseware:(NSString *)cid
{
    NSURL *addr = [NSURL URLWithString:[NSString stringWithFormat:@"%s%scourse_courseware",Target_URL,Target_Path]];
    NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"X-CSRFToken"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *args = [NSString stringWithFormat:@"course_id=%@",cid];
    
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:addr];
    [urlReq setHTTPMethod:@"POST"];
    [urlReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    [urlReq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [urlReq addValue:token forHTTPHeaderField:@"X-CSRFToken"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq completionHandler:^(NSData *data, NSURLResponse *res, NSError *err)
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
        NSString *reason = nil;
        int code = [httpres statusCode];
        if(code>=400)
        {
            [notiDict setObject:@"0" forKey:@"status"];
        }
        else
        {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            if ([[dict objectForKey:@"status"] boolValue])
            {
#warning 临时方法
                [notiDict setObject:[dict objectForKey:@"sections"] forKey:@"sections"];
                [dict removeObjectForKey:@"sections"];
                [courseData updateCourse:cid withData:dict];
                [notiDict setObject:@"1" forKey:@"status"];
            }
            else
            {
                [notiDict setObject:@"0" forKey:@"status"];
            }
            
        }
        [notiDict setObject:cid forKey:sMOOCCourseID];
        [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
        [notiDict setObject:(err?[err localizedDescription]:(reason?reason:@"")) forKey:@"error"];
        [noti postNotificationName:sMOOCCourseWareNotification object:self userInfo:notiDict];
    }];
    [task resume];
}

- (void)MOOCCourseEnroll:(NSString *)cid action:(int)enroll
{
    NSURL *addr = [NSURL URLWithString:[NSString stringWithFormat:@"%s%scourse_enroll",Target_URL,Target_Path]];
    NSString *enrollStr;
    if (enroll == MOOCCourseEnroll) enrollStr = @"enroll";
    else if (enroll == MOOCCourseUnEnroll) enrollStr = @"unenroll";
    else
        return;
    NSString *token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"X-CSRFToken"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *args = [NSString stringWithFormat:@"course_id=%@&enrollment_action=%@",cid,enrollStr];
    
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:addr];
    [urlReq setHTTPMethod:@"POST"];
    [urlReq setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    [urlReq setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [urlReq addValue:token forHTTPHeaderField:@"X-CSRFToken"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq completionHandler:^(NSData *data, NSURLResponse *res, NSError *err)
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
        NSString *reason = nil;
        int code = [httpres statusCode];
        if(code>=400)
        {
            [notiDict setObject:@"0" forKey:@"status"];
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            BOOL status = [[dict objectForKey:@"status"] boolValue];
            if (status)
            {
                [notiDict setObject:@"1" forKey:@"status"];
                if (enroll == MOOCCourseEnroll)
                {
                    [courseData updateCourse:cid withData:@{@"registered":@"1"}];
                    [notiDict setObject:@"1" forKey:@"registered"];
                }
                else
                {
                    [courseData updateCourse:cid withData:@{@"registered":@"0"}];
                    [notiDict setObject:@"0" forKey:@"registered"];
                }

            }
            else
            {
                [notiDict setObject:@"0" forKey:@"status"];
                reason = [dict objectForKey:@"reason"];
            }
        }
        [notiDict setObject:cid forKey:sMOOCCourseID];
        [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
        [notiDict setObject:(err?[err localizedDescription]:(reason?reason:@"")) forKey:@"error"];
        [noti postNotificationName:sMOOCCourseEnrollNotification object:self userInfo:notiDict];
    }];
    [task resume];
}

//单独课程列表不设有效期，实时更新
- (void)MOOCGetCourseEnrollment
{
    NSURL *addr = [NSURL URLWithString:[NSString stringWithFormat:@"%s%sget_course_enrollment",Target_URL,Target_Path]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:addr completionHandler:^(NSData *data, NSURLResponse *res, NSError *err)
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
        int code = [httpres statusCode];
        if(code>=400)
        {
            [notiDict setObject:@"0" forKey:@"status"];
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            BOOL status = [[dict objectForKey:@"status"] boolValue];
            if (status)
            {
                NSArray *courses = [dict objectForKey:@"enrollment"];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in courses)
                {
                    NSString *courseid = [dict objectForKey:sMOOCCourseID];
                    [courseData updateCourse:courseid withData:dict];
                    [arr addObject:courseid];
                }
                [notiDict setObject:arr forKey:@"courseArray"];
                [notiDict setObject:@"1" forKey:@"status"];
            }
            else
            {
                [notiDict setObject:@"0" forKey:@"status"];
            }
        }
        [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
        [notiDict setObject:(err?[err localizedDescription]:@"") forKey:@"error"];
        [noti postNotificationName:sMOOCGetCourseEnrollmentNotification object:self userInfo:notiDict];
    }];
    [task resume];
}


//有效期
- (void)MOOCGetImage:(NSString *)cid imagePath:(NSString *)path
{
#warning 临时永久只取一次图片以体现好效果
    NSDictionary *dict = [[MOOCCourseData sharedInstance] getCourseData:cid withSections:NO];
    //if (false)
    if ([[dict objectForKey:@"course_image"] isAbsolutePath]&&[[MOOCCourseData sharedInstance] checkValid:cid])
    {
        NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
        [notiDict setObject:@"1" forKey:@"status"];
        [notiDict setObject:cid forKey:sMOOCCourseID];
        [notiDict setObject:@"200" forKey:@"statusCode"];
        [notiDict setObject:@"" forKey:@"error"];
        [noti postNotificationName:sMOOCCourseAboutNotification object:self userInfo:notiDict];
    }
    else
    {
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s%@",Target_URL,Target_Img_Path?Target_Img_Path:nil,path]];
        NSString* urlstr = [NSString stringWithFormat:@"%s%@", Target_URL, path];
        NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //NSLog(@"%@,%@",url,cid);
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *loc, NSURLResponse *res, NSError *err)
        {
            NSMutableDictionary *notiDict = [[NSMutableDictionary alloc] init];
            NSHTTPURLResponse *httpres = (NSHTTPURLResponse *)res;
            int code = [httpres statusCode];
            if (err || code>=400 )
            {
                [notiDict setObject:@"0" forKey:@"status"];
            }
            else
            {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSURL *path = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
                NSData *data = [NSData dataWithContentsOfURL:loc];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyyMMddHHmmss-SSS"];
                int lengthOfString = 4;
                char string[lengthOfString];
                for (int x=0; x<lengthOfString; string[x++] = (char)('a'+(arc4random_uniform(26))));
                NSString *randname = [[NSString alloc] initWithBytes:string length:lengthOfString encoding:NSUTF8StringEncoding];
                NSString *datename = [dateFormatter stringFromDate:[NSDate date]];
                NSString *filename = [NSString stringWithFormat:@"%@-%@",datename,randname];
                NSString *fullpath = [NSString stringWithFormat:@"%@%@.jpg",[path path],filename];
                BOOL success = [fileManager createFileAtPath:fullpath contents:data attributes:nil];
                if (success)
                {
                    //NSLog(@"File Saved To Path: %@",fullpath);
                    NSDictionary *sendDict = @{@"course_image":fullpath};
                    [courseData updateCourse:cid withData:sendDict];
                    [notiDict setObject:@"1" forKey:@"status"];
                }
                else
                {
                    [notiDict setObject:@"0" forKey:@"status"];
                }
            }
            [notiDict setObject:cid forKey:sMOOCCourseID];
            [notiDict setObject:[NSString stringWithFormat:@"%d",code] forKey:@"statusCode"];
            [notiDict setObject:(err?[err localizedDescription]:@"") forKey:@"error"];
            [noti postNotificationName:sMOOCGetImageNotification object:self userInfo:notiDict];
        }];
        [task resume];
    }
}


@end
