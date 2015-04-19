//
//  PingTuViewController.m
//  CustomPickerAndFitler
//
//  Created by soson on 14-6-9.
//  Copyright (c) 2014年 Wu.weibin. All rights reserved.
//

#import "PingTuViewController.h"

@interface PingTuViewController ()

@end

@implementation PingTuViewController

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
    
    
    
    UIImage *image=[self addImage:[UIImage imageNamed:@"aa"] toImage:[UIImage imageNamed:@"aa"]];
    
    NSLog(@"    image.size.height=%f",    image.size.height);
    
    UIScrollView *sv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,image.size.height)];
    imageView.image=image;
    [sv addSubview:imageView];
    
    sv.contentSize=CGSizeMake(320, image.size.height);
    [self.view addSubview:sv];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2
{
    
    CGSize size=CGSizeMake(320, 900);
    UIGraphicsBeginImageContext(size);
    
    //Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    //Draw image1
    [image1 drawInRect:CGRectMake(0, image2.size.height, image1.size.width, image1.size.height)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
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

@end
