//
//  beihangMOOCCourseView.m
//  MOOC@Beihang
//
//  Created by Satte on 14-8-6.
//  Copyright (c) 2014年 admire. All rights reserved.
//

#import "beihangMOOCCourseView.h"
#import "beihangMOOCCourseViewCell.h"



@interface beihangMOOCCourseView ()

@end

@implementation beihangMOOCCourseView

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
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    beihangMOOCCourseViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"coursecell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"<Course Name>"];
    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
    cell.image.image = [UIImage imageNamed:imageToLoad];
    return cell;
}


/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"coursetoDetail"])
    {
        //传输相应的课程号并读取
    }
}
*/

@end
