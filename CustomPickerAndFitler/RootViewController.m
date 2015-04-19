//
//  RootViewController.m
//  CustomPickerAndFitler
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "RootViewController.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "Singleton.h"
#import "PingTuViewController.h"
#import "MyAnimationUtil.h"

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
    
    //开始加载的图片
    iView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 200, 200, 200)];
  [self.view addSubview:iView];
    iView.image=[UIImage imageNamed:@"836_97982.jpg"];
    
//    //下载图片
//    NSString *urlstr = @"http://imga13.wbiao.cn/201312/04/3188_9B_73753.jpg";
//    
//    NSURL* url = [NSURL URLWithString:urlstr];
//    
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:url];
//    
//    
//    [request setCompletionBlock:^{
//        
//        NSError *error;
//        NSDictionary *jsDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
//        
//        [iView setImageWithURL:urlstr placeholderImage:[UIImage imageNamed:@"placeholder.png"]  options:SDWebImageProgressiveDownload andResize:CGSizeMake(195, 195)];
//        
//    }];
//    
//    [request setFailedBlock:^{
//        NSLog(@"出错了");
//        
//    }];
//    [request startAsynchronous];
    

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
    
//    //UIView开始动画，第一个参数是动画的标识，第二个参数附加的应用程序信息用来传递给动画代理消息
//    [UIView beginAnimations:@"View Flip" context:nil];
//    //动画持续时间
//    [UIView setAnimationDuration:1.25];
//    //设置动画的回调函数，设置后可以使用回调方法
//    [UIView setAnimationDelegate:self];
//    //设置动画曲线，控制动画速度，UIViewAnimationCurveEaseInOut，UIViewAnimationCurveEaseIn，UIViewAnimationCurveEaseOut，UIViewAnimationCurveLinear
//    [UIView  setAnimationCurve: UIViewAnimationCurveLinear];
//    
//    //  UIViewAnimationTransitionNone,UIViewAnimationTransitionFlipFromLeft, UIViewAnimationTransitionFlipFromRight,    UIViewAnimationTransitionCurlUp,    UIViewAnimationTransitionCurlDown
//    //设置动画方式，并指出动画发生的位置
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view  cache:YES];
//
// 
//    [self presentViewController:fitler animated:NO completion:nil];
//
//
//    //提交UIView动画
//    [UIView commitAnimations];
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
