//
//  beihangMOOCLoginView.h
//  MOOC@Beihang
//
//  Created by Satte on 14-8-2.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface beihangMOOCLoginView : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *prog;

- (IBAction)anonyLogin:(id)sender;
- (IBAction)regAccount:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;

- (IBAction)startPass:(id)sender;
- (IBAction)returnPass:(id)sender;
- (IBAction)exitPass:(id)sender;

- (IBAction)startUser:(id)sender;
- (IBAction)returnUser:(id)sender;
- (IBAction)exitUser:(id)sender;

- (IBAction)backTap:(id)sender;

- (void)loginwithAnonymous:(BOOL)anonymity;
- (void)startEditing;
- (void)endEditing;
@end
