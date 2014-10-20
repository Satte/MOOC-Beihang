//
//  MOOCMyCourseShow.m
//  MOOC@Beihang
//
//  Created by Satte on 14-8-13.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "MOOCMyCourseShow.h"


@interface MOOCMyCourseShow ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation MOOCMyCourseShow

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_recvStr)
    {
        NSLog(@"%@",_recvStr);
 
        NSURL *url = [NSURL URLWithString:_recvStr];
        _recvStr = nil;
        [self playMovieWithURL:url];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_player && !_player.fullscreen)
    {
        [_player stop];
        [_player.view removeFromSuperview];
        _player = nil;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem)
    {
        //self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mpWidth = [UIScreen mainScreen].bounds.size.width*5.0/6.0;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    //nslog(@"%@",barButtonItem);
    barButtonItem.title = @"课程列表";
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    self.masterPopoverController = popoverController;
    //_popover = nil;
    _btn = barButtonItem;
    //NSLog(@"%@",viewController);
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
    //NSLog(@"%@",viewController);
}

- (void)playMovieWithURL:(NSURL *)url
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpStopPlay:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:nil object:nil];
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] init];
    mp.movieSourceType = MPMovieSourceTypeStreaming;
    [mp setContentURL:url];
    CGSize c = self.view.frame.size;
    mp.controlStyle = MPMovieControlStyleDefault;
    mp.scalingMode = MPMovieScalingModeAspectFit;
    [mp prepareToPlay];
    [mp.view setFrame:CGRectMake((c.width-mpWidth)/2.0, (c.height-mpWidth*9/16.0)/2.0, mpWidth, mpWidth*9/16.0)];
    if (_player)
    {
        [_player stop];
        [_player.view removeFromSuperview];
        _player = nil;
    }
    _player = mp;
    [self.view addSubview:_player.view];
    
    @try
    {
        [_player play];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5);
        dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!_player.readyForDisplay)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_player)
                    {
                        [_player stop];
                        [_player.view removeFromSuperview];
                        _player = nil;
                        //uialertview
                    }
                });
            }
        });
        
        
        
    }
    @catch (NSException *e)
    {
        NSLog(@"Error When Loading MP: %@",e.description);
        if (_player)
        {
            [_player stop];
            [_player.view removeFromSuperview];
            _player = nil;
        }
        //uialertview
    }
}

- (void)mpEnterFullscreen:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_player)
        {
            CGSize c = self.view.frame.size;
            [_player.view setFrame:CGRectMake(0, 0, c.width, c.height)];
            _player.controlStyle = MPMovieControlStyleFullscreen;
        }
    });
}

- (void)mpExitFullscreen:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_player)
        {
            CGSize c = self.view.frame.size;
            [_player.view setFrame:CGRectMake((c.width-mpWidth)/2.0, (c.height-mpWidth*9/16.0)/2.0, mpWidth, mpWidth*9/16.0)];
            _player.controlStyle = MPMovieControlStyleDefault;
            [_player play];
        }
    });
}
/*
- (void)mpStopPlay:(NSNotification *)noti
{
    NSLog(@"%@",noti.userInfo);
    if (_player)
    {
        [_player.view removeFromSuperview];
        _player = nil;
    }
}
*/
- (void)receiveNotification:(NSNotification *)noti
{
    //NSLog(@"%@",noti.name);
}

- (void)viewDidLayoutSubviews
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
    {
        [_lbl setFrame:CGRectMake(147, 325, 408, 54)];
    }
    if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        [_lbl setFrame:CGRectMake(180, 453, 408, 54)];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        [_lbl setFrame:CGRectMake(147, 325, 408, 54)];
    }
    if ((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        [_lbl setFrame:CGRectMake(180, 453, 408, 54)];
    }
    if (_player)
    {
        if (_player.fullscreen)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerWillEnterFullscreenNotification object:_player];
            _player.controlStyle = MPMovieControlStyleFullscreen;
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerWillExitFullscreenNotification object:_player];
            _player.controlStyle = MPMovieControlStyleEmbedded;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id dest = segue.destinationViewController;
    if ([dest isKindOfClass:[MOOCQRCodeView class]])
    {
        MOOCQRCodeView *view = (MOOCQRCodeView *)dest;
        view.sourceView = self;
        //_popoverView = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}


@end
