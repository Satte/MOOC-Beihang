//
//  MOOCPositionList.m
//  MOOC@Beihang
//
//  Created by Satte on 14-8-25.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "MOOCPositionList.h"
#import "MOOCMyCourseShow.h"

@interface MOOCPositionList ()

@end

@implementation MOOCPositionList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = [NSString stringWithFormat:@"视频列表 - %@",[_courseInfo objectForKey:@"display_name"]];
    
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_videoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_videoList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[dict objectForKey:@"address"]];
    NSString *title = [[NSString alloc] initWithString:[dict objectForKey:@"name"]];
    cell.textLabel.text = title;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [_videoList objectAtIndex:indexPath.row];
    //NSLog(@"%@",dict);
    MOOCMyCourseShow *target = nil;
    NSArray *arr = self.splitViewController.childViewControllers;
    for (UINavigationController *nav in arr)
    {
        for (id v in nav.childViewControllers)
        {
            if ([v isKindOfClass:[MOOCMyCourseShow class]])
            {
                target = v;
            }
        }
    }
    NSLog(@"%@",dict);
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"address"]];
    if (target)
    {
        [target playMovieWithURL:url];
    }
    //if (target) [target playMovieWithURL:[NSURL URLWithString:@"https://mediasvc66xrj754h8127.blob.core.windows.net/asset-88628820-d3e8-4e46-8cc7-acc89df72e21/1.1%20introduction%20of%20the%20course%20and%20the%20teacher(01).mp4?sv=2012-02-12&st=2014-03-17T15%3A15%3A57Z&se=2016-03-16T15%3A15%3A57Z&sr=c&si=c3183e09-d095-47b2-8eea-3fd7cd44a209&sig=dzVF2EkAPV4OnmCHtXVzKo%2B%2F%2Fom4cRIR9jLo65c104Q%3D"]];
}




@end
