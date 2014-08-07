//
//  beihangMOOCCourseDetailView.m
//  MOOC@Beihang
//
//  Created by Satte on 14-8-7.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "beihangMOOCCourseDetailView.h"

@interface beihangMOOCCourseDetailView ()

@end

@implementation beihangMOOCCourseDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _name.text = @"全力打造具有中部地区特征的江西共青团工作新格局并团结带领团员青年在鄱阳湖生态经济区建设中发挥生力军作用";
    _img.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"0" ofType:@"JPG"]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseCourse:(id)sender {
}
@end
