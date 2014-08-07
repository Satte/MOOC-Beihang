//
//  beihangMOOCWelcomeView.m
//  MOOC@Beihang
//
//  Created by Satte on 14-8-2.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "beihangMOOCWelcomeView.h"

@interface beihangMOOCWelcomeView ()

@end

@implementation beihangMOOCWelcomeView

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
    [_prog startAnimating];
    [self performSelector:@selector(toLoginView) withObject:nil afterDelay:0.5];
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

- (IBAction)aboutUs:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mooc.buaa.edu.cn/about"]];
}

- (void)toLoginView
{
    [_prog stopAnimating];
    [self performSegueWithIdentifier:@"welcometoLogin" sender:nil];
}

@end
