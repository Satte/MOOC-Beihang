//
//  MOOCMyCourseList.m
//  MOOC@Beihang
//
//  Created by Satte on 14-8-13.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "MOOCMyCourseList.h"
#import "MOOCMyCourseShow.h"
#import "MOOCChapterList.h"
#import "MOOCConnection.h"

@interface MOOCMyCourseList ()
{
    MOOCActivityIndicator *prog;
    BOOL isAlertViewExist;
}

- (void)receiveNotificationFromCourseEnrollment:(NSNotification *)noti;
- (void)receiveNotificationFromCourseWare:(NSNotification *)noti;
@end

@implementation MOOCMyCourseList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isAlertViewExist = NO;
    _course = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"课程列表";
    prog = [[MOOCActivityIndicator alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationFromCourseEnrollment:) name:sMOOCGetCourseEnrollmentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationFromCourseWare:) name:sMOOCCourseWareNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    //NSLog(@"View Will Appear");
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"View Appeared");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Requesting count = %lu",(unsigned long)[_course count]);
    return [_course count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cellID%d",indexPath.row]];
    NSDictionary *dict = _course[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"display_name"];
    //NSLog(@"%@",cell.textLabel.text);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [_course objectAtIndex:indexPath.row];
    NSArray *arr = [dict objectForKey:@"sections"];
    if ([arr count])
    {
        [self performSegueWithIdentifier:@"coursetoChapter" sender:dict];
    }
    else
    {
        //NSLog(@"Disabled");
        [[[UIAlertView alloc] initWithTitle:@"此列表下无视频" message:@"请稍后重试或查看其他课程" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil] show];
    }
}

- (void)receiveNotificationFromCourseEnrollment:(NSNotification *)noti
{
    NSDate *date = [NSDate date];
    [_course removeAllObjects];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [prog stop];
    });
    if ([[noti.userInfo objectForKey:@"status"] boolValue])
    {
        NSArray *arr = [noti.userInfo objectForKey:@"courseArray"];
        for (NSString *cid in arr)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[MOOCConnection sharedInstance] MOOCCourseware:cid];
            });
            NSMutableDictionary *target = [NSMutableDictionary dictionaryWithDictionary:[[MOOCCourseData sharedInstance] getCourseData:cid withSections:NO]];
            [_course addObject:target];
        }
    }
    else
    {
        NSDictionary *recv = noti.userInfo;
        NSLog(@"ErrorCode:%@ Error:%@",[recv objectForKey:@"statusCode"],[recv objectForKey:@"error"]);
        int code = [[recv objectForKey:@"statusCode"] intValue];
        if (code!=200)
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!isAlertViewExist)
                {
                    [[[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络后尝试刷新本页面。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil] show];
                    isAlertViewExist = YES;
                }
            });
    }
    dispatch_async(dispatch_get_main_queue(), ^{[self.tableView reloadData];});
    NSLog(@"Enrollment Notification @MOOCMyCourseList complete, Elapsed Time: %f",[[NSDate date] timeIntervalSinceDate:date]);
}

- (void)receiveNotificationFromCourseWare:(NSNotification *)noti
{
    NSDate *date = [NSDate date];
    if ([[noti.userInfo objectForKey:@"status"] boolValue])
    {
        NSDictionary *ndict = noti.userInfo;
        NSString *cid = [ndict objectForKey:sMOOCCourseID];
        int index = -1;
        for (NSDictionary *dict in _course)
        {
            if ([[dict objectForKey:sMOOCCourseID] isEqualToString:cid])
            {
                index = [_course indexOfObject:dict];
            }
        }
        NSMutableDictionary *target = [NSMutableDictionary dictionaryWithDictionary:[[MOOCCourseData sharedInstance] getCourseData:cid withSections:YES]];
        [target setObject:[ndict objectForKey:@"sections"] forKey:@"sections"];
        [_course replaceObjectAtIndex:index withObject:target];
    }
    else
    {
        NSDictionary *recv = noti.userInfo;
        NSLog(@"ErrorCode:%@ Error:%@",[recv objectForKey:@"statusCode"],[recv objectForKey:@"error"]);
        int code = [[recv objectForKey:@"statusCode"] intValue];
        if (code!=200)
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!isAlertViewExist)
                {
                    [[[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络后尝试刷新本页面。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil] show];
                    isAlertViewExist = YES;
                }
            });
    }
    NSLog(@"Courseware Notification @MOOCMyCourseList complete, Elapsed Time: %f",[[NSDate date] timeIntervalSinceDate:date]);
}

- (void)refreshCourse
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MOOCConnection sharedInstance] MOOCGetCourseEnrollment];
    });
    [prog start];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MOOCChapterList *view = [segue destinationViewController];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)sender];
    view.chapterList = [dict objectForKey:@"sections"];
    [dict removeObjectForKey:@"sections"];
    view.courseInfo = dict;
}

@end
