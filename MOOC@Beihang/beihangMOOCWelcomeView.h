//
//  beihangMOOCWelcomeView.h
//  MOOC@Beihang
//
//  Created by Satte on 14-8-2.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface beihangMOOCWelcomeView : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *prog;

- (IBAction)aboutUs:(id)sender;
- (void)toLoginView;
@end
