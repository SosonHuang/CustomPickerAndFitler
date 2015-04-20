//
//  RootViewController.m
//  CustomPickerAndFitler
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "RootViewController.h"
#import "UIImageView+WebCache.h"
#import "Singleton.h"
#import "PingTuViewController.h"

@interface RootViewController ()
{
  UIImageView *iView;
    Singleton *sing;
}
@end

@implementation RootViewController

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
    // Do any additional setup after loading the view from its nib.
    sing=[Singleton getData];
    self.view.backgroundColor = [UIColor redColor];
    
    //开始加载的图片
    iView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 200, 200, 200)];
  [self.view addSubview:iView];
    iView.image=[UIImage imageNamed:@"11"];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender  
{
    //把手表放入单列
    sing.watchImage=iView.image;
    
    CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
   
    [picker setCustomDelegate:self];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}
- (void)cameraPhoto:(UIImage *)image  //选择完图片
{
    
    
    ImageFilterProcessViewController *fitler = [[ImageFilterProcessViewController alloc] init];
    [fitler setDelegate:self];
    fitler.currentImage = image;
    
//
     self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

     [self presentViewController:fitler animated:YES completion:nil];
    
       [fitler release];
}
- (void)imageFitlerProcessDone:(UIImage *)image //图片处理完
{
    [imageView setImage:image];
}


- (IBAction)test:(id)sender {
    PingTuViewController *pingtu=[[PingTuViewController alloc]init];
    [self presentViewController:pingtu animated:YES completion:nil];
    
}


@end
