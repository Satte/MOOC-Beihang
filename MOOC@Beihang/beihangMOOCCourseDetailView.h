//
//  beihangMOOCCourseDetailView.h
//  MOOC@Beihang
//
//  Created by Satte on 14-8-7.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface beihangMOOCCourseDetailView : UIViewController
- (IBAction)chooseCourse:(id)sender;


@property (nonatomic, retain) NSString *courseID;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *stoptime;
@property (weak, nonatomic) IBOutlet UILabel *stoptime_label;
@property (weak, nonatomic) IBOutlet UIButton *choose;
@property (weak, nonatomic) IBOutlet UIWebView *courseintro;

@end
