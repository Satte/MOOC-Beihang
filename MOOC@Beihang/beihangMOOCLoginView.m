//
//  beihangMOOCLoginView.m
//  MOOC@Beihang
//
//  Created by Satte on 14-8-2.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "beihangMOOCLoginView.h"

@interface beihangMOOCLoginView ()

@end

@implementation beihangMOOCLoginView

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

- (IBAction)anonyLogin:(id)sender
{
    [self loginwithAnonymous:YES];
}

- (IBAction)regAccount:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mooc.buaa.edu.cn/register"]];
}


- (IBAction)returnPass:(id)sender
{
    [self resignFirstResponder];
    [self loginwithAnonymous:NO];
    _login.hidden = YES;
}

- (IBAction)startPass:(id)sender
{
    [self startEditing];
    _txtPass.text = @"";
}

- (IBAction)returnUser:(id)sender
{
    [_txtPass becomeFirstResponder];
}

- (IBAction)exitPass:(id)sender
{
    [self endEditing];
    _login.hidden = NO;
}

- (IBAction)startUser:(id)sender
{
    [self startEditing];
}

- (IBAction)exitUser:(id)sender
{
    [self endEditing];
}

- (IBAction)backTap:(id)sender
{
    [_txtUser resignFirstResponder];
    [_txtPass resignFirstResponder];
    [self endEditing];
}

- (IBAction)login:(id)sender
{
    [self loginwithAnonymous:NO];
}

//下面两个应用至iPhone时需要更改

- (void)startEditing
{
    if (self.view.frame.origin.y == 0)
    {
        CGRect frm = self.view.frame;
        frm.origin.y -= 264;
        frm.size.height += 264;
        self.view.frame = frm;
    }
}

- (void)endEditing
{
    if (self.view.frame.origin.y != 0)
    {
        CGRect frm = self.view.frame;
        frm.origin.y += 264;
        frm.size.height -= 264;
        self.view.frame = frm;
    }
}

- (void)loginwithAnonymous:(BOOL)anonymity
{
    if (anonymity == NO)
    {
        NSLog(@"%@,%@",_txtUser.text,_txtPass.text);
    }
    [self performSegueWithIdentifier:@"logintoMain" sender:self];
}
@end
