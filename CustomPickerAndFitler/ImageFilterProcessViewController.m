//
//  ImageFilterProcessViewController.m
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "ImageFilterProcessViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "IphoneScreen.h"
#import "Singleton.h"
#import "TestViewController.h"
#import "ZDStickerView.h"
#import "MVArrowOverlayView.h"


@interface ImageFilterProcessViewController ()
{
    UIImageView *watchView;
    UIImage *hello;
    
    int watchX;
    int watchY;
    
    ZDStickerView *userResizableView1;
    
    //判断是否隐藏了控件
    BOOL isHidden;
    
    MVArrowOverlayView *tappableView;
        MVArrowOverlayView *tappableView2;
    UIView *bg;
}
@end

@implementation ImageFilterProcessViewController
@synthesize currentImage = currentImage, delegate = delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)backView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)fitlerDone:(id)sender
{
    //[self dismissViewControllerAnimated:NO completion:^{
     userResizableView1.borderView.hidden=YES;
        userResizableView1.resizingControl.hidden=YES;
        UIGraphicsBeginImageContext( rootImageView.frame.size);
        [rootImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        TestViewController *test=[[TestViewController alloc]init];
        test.testImage=newImage;
        [self presentViewController:test animated:YES completion:nil];
     userResizableView1.resizingControl.hidden=NO;
        
            //[delegate imageFitlerProcessDone:newImage];
    //}];
}



//-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
//{
//    long double rotate = 0.0;
//    CGRect rect;
//    float translateX = 0;
//    float translateY = 0;
//    float scaleX = 1.0;
//    float scaleY = 1.0;
//    
//    switch (orientation) {
//        case UIImageOrientationLeft:
//            rotate = M_PI_2;
//            rect = CGRectMake(0, 0, image.size.height, image.size.width);
//            translateX = 0;
//            translateY = -rect.size.width;
//            scaleY = rect.size.width/rect.size.height;
//            scaleX = rect.size.height/rect.size.width;
//            break;
//        case UIImageOrientationRight:
//            rotate = 3 * M_PI_2;
//            rect = CGRectMake(0, 0, image.size.height, image.size.width);
//            translateX = -rect.size.height;
//            translateY = 0;
//            scaleY = rect.size.width/rect.size.height;
//            scaleX = rect.size.height/rect.size.width;
//            break;
//        case UIImageOrientationDown:
//            rotate = M_PI;
//            rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            translateX = -rect.size.width;
//            translateY = -rect.size.height;
//            break;
//        default:
//            rotate = 0.0;
//            rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            translateX = 0;
//            translateY = 0;
//            break;
//    }
//    
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //做CTM变换
//    CGContextTranslateCTM(context, 0.0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextRotateCTM(context, rotate);
//    CGContextTranslateCTM(context, translateX, translateY);
//    
//    CGContextScaleCTM(context, scaleX, scaleY);
//    //绘制图片
//    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
//    
//    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
//    
//    return newPic;
//}

// 指定回调方法
//
//-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//{
//    NSString *msg = nil ;
//    if(error != NULL){
//        
//        msg = @"保存图片失败" ;
//    }else{
//        msg = @"保存图片成功" ;
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
//                                    message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//}




#pragma MARK 图片移动
-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    //获取图片的大小
    CGFloat smallwidth=rootImageView.frame.size.width;
    CGFloat smallheight=rootImageView.frame.size.height;
    NSLog(@"%f",rootImageView.frame.origin.x);
    NSLog(@"%f", rootImageView.frame.origin.y);
    
    
    //获取底部图片的大小
    CGFloat imageWatchwidth=userResizableView1.frame.size.width;
    CGFloat imageWatchheight=userResizableView1.frame.size.height;
    NSLog(@"%f",userResizableView1.frame.origin.x);
    NSLog(@"%f", userResizableView1.frame.origin.y);
    
    
    CGPoint translation = [recognizer translationInView:rootImageView];
    
    NSLog(@"%f", recognizer.view.center.x);
    NSLog(@"%f", recognizer.view.center.y);
    NSLog(@"origin %f", recognizer.view.frame.origin.y);
    
    //移动到右边超出范围，即到达右边不能超出
    if(recognizer.view.frame.origin.x>(300-imageWatchwidth)){
        [recognizer.view setCenter:CGPointMake(300-imageWatchwidth/2,recognizer.view.center.y)];
    }
    
    //移动到左边超出范围
    if(recognizer.view.frame.origin.x<10){
        [recognizer.view setCenter:CGPointMake(imageWatchwidth/2, recognizer.view.center.y)];
    }
    
    //移动到上边超出范围
    if(recognizer.view.frame.origin.y<=0){
        [recognizer.view setCenter:CGPointMake(recognizer.view.center.x,imageWatchheight/2)];
    }
    
    //移动到下边超出范围
    if(recognizer.view.frame.origin.y>rootImageView.frame.size.height-imageWatchheight){
        [recognizer.view setCenter:CGPointMake(recognizer.view.center.x,rootImageView.frame.size.height-imageWatchheight/2)];
    }
    //
    //    if(recognizer.view.frame.origin.y<40||recognizer.view.frame.origin.y>440){
    //        [recognizer.view setCenter:CGPointMake(recognizer.view.center.x, 440)];
    //    }
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    
    
    [recognizer setTranslation:CGPointZero inView:rootImageView];
    
//    watchX=userResizableView1.frame.origin.x;
//    watchY=userResizableView1.frame.origin.y;
//    NSLog(@"%f",  recognizer.view.frame.origin.x);
//    NSLog(@"%f",  recognizer.view.frame.origin.y);
    
    
    
    
    
}

#pragma MARK 图片放大缩小
-(void)scaGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    //方法一：
    //    [self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    //    //当手指离开屏幕时,将lastscale设置为1.0
    //    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
    //        lastScale = 1.0;
    //        return;
    //    }
    //
    //    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    //    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    //    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    //    [[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
    //    lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
    
    //方法二：
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        
        pinchGestureRecognizer.scale = 1;
    }
}

#pragma MARK 旋转
// 旋转
-(void)rotate:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    //方法一：
    //    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
    //
    //        _lastRotation = 0.0;
    //        return;
    //    }
    //
    //    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    //
    //    CGAffineTransform currentTransform = imageWatch.transform;
    //    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    //
    //    [imageWatch setTransform:newTransform];
    //
    //    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    //    [self showOverlayWithFrame:imageWatch.frame];
    
    
    //方法二：
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
    
    
    
//    [aPath addLineToPoint:CGPointMake(200.0, 40.0)];
//    
//    [aPath addLineToPoint:CGPointMake(160, 140)];
//    
//    [aPath addLineToPoint:CGPointMake(40.0, 140)];
//    
//    [aPath addLineToPoint:CGPointMake(0.0, 40.0)];
    
    

}


-(void)SingleTapSmall:(id)sender
{
    userResizableView1.borderView.hidden=NO;
    userResizableView1.resizingControl.hidden=NO;

}



-(void)SingleTapBig:(id)sender
{
    userResizableView1.borderView.hidden=YES;
    userResizableView1.resizingControl.hidden=YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
   
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(10, 20, 34, 34)];
    [leftBtn addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"camera_btn_ok.png"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(270, 20, 34, 34)];
    [rightBtn addTarget:self action:@selector(fitlerDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.388 alpha:1.000]];
    rootImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(10, 50, 300, 400)];
    rootImageView.image = currentImage;
    rootImageView.userInteractionEnabled=YES;
    [self.view addSubview:rootImageView];
    
    hello=[Singleton getData].watchImage;
    
    watchView = [[UIImageView alloc ] initWithFrame:CGRectMake(50, 50, 200, 200)];
    watchView.userInteractionEnabled=YES;
    watchView.image = hello;
//    [rootImageView addSubview:watchView];
    
    CGRect gripFrame1 = CGRectMake(50, 50, 200, 200);
    userResizableView1 = [[ZDStickerView alloc] initWithFrame:gripFrame1];
    userResizableView1.contentView = watchView;
    userResizableView1.preventsPositionOutsideSuperview = NO;
    [userResizableView1 showEditingHandles];
    [rootImageView addSubview:userResizableView1];
    
    
    
//    tappableView.activeClearColor = [UIColor whiteColor];
//    tappableView.arrowStrokeColor = [UIColor blackColor];
//    tappableView=[[MVArrowOverlayView alloc]initWithFrame:CGRectMake(10, 20, 250, 350)];
//    tappableView.backgroundColor=[UIColor redColor];
//    [rootImageView addSubview:tappableView];
//    [tappableView drawFromPoint:CGPointMake(4, 40) toPoint:CGPointMake(18, 130) radius:80 clockwise:YES];
    
    
    
    
//    //定义手势，让图片可以拖动
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    panGestureRecognizer.delegate=self;
    [userResizableView1 addGestureRecognizer:panGestureRecognizer];
    
    //定义手势放大缩小
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
    [pinchRecognizer setDelegate:self];
    [userResizableView1 addGestureRecognizer:pinchRecognizer];
    
    
    
    //定义手势旋转
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [rotationRecognizer setDelegate:self];
    [userResizableView1 addGestureRecognizer:rotationRecognizer];
    
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTapSmall:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    [userResizableView1 addGestureRecognizer:singleRecognizer];
    
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer2;
    singleRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTapBig:)];
    //点击的次数
    singleRecognizer2.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    [rootImageView addGestureRecognizer:singleRecognizer2];
    
    

    
    
    
    NSArray *arr = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 80, 320, 80)];
    scrollerView.backgroundColor = [UIColor clearColor];
    scrollerView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;//关闭纵向滚动条
    scrollerView.bounces = NO;
  
    float x ;
    for(int i=0;i<14;i++)
    {
        x = 10 + 51*i;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageStyle:)];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.numberOfTapsRequired = 1;
        recognizer.delegate = self;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 53, 40, 23)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[arr objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setTextColor:[UIColor whiteColor]];
        [label setUserInteractionEnabled:YES];
        [label setTag:i];
        [label addGestureRecognizer:recognizer];
        
        [scrollerView addSubview:label];
        [label release];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, 40, 43)];
        [bgImageView setTag:i];
        [bgImageView addGestureRecognizer:recognizer];
        [bgImageView setUserInteractionEnabled:YES];
        UIImage *bgImage = [self changeImage:i imageView:nil];
        bgImageView.image = bgImage;
        [scrollerView addSubview:bgImageView];
        [bgImageView release];
        
        [recognizer release];

    }
    scrollerView.contentSize = CGSizeMake(x + 55, 80);
    [self.view addSubview:scrollerView];
    
	// Do any additional setup after loading the view.
    
    
    bg = [[UIView alloc] initWithFrame:CGRectMake(15,50,300,400)];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha=0.5;
    [self.view addSubview:bg];
    
    
    tappableView=[[MVArrowOverlayView alloc]initWithFrame:CGRectMake(10, 20, 250, 350)];
    tappableView.arrowStrokeColor = [UIColor redColor];
    [bg addSubview:tappableView];
    [tappableView drawFromPoint:CGPointMake(50, 40) toPoint:CGPointMake(50, 200) radius:260 clockwise:NO];
    
    tappableView2=[[MVArrowOverlayView alloc]initWithFrame:CGRectMake(10, 20, 250, 350)];
    tappableView2.arrowStrokeColor = [UIColor redColor];
    [bg addSubview:tappableView2];
    [tappableView2 drawFromPoint:CGPointMake(200, 200) toPoint:CGPointMake(200, 40) radius:260 clockwise:NO];
    

    
    // 单击的 Recognizer
    UITapGestureRecognizer* bgRecognizer;
    bgRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapSmall:)];
    //点击的次数
    bgRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    [bg addGestureRecognizer:bgRecognizer];
    

}

-(void)bgTapSmall:(UITapGestureRecognizer *)sender
{
    bg.hidden=YES;
}

- (IBAction)setImageStyle:(UITapGestureRecognizer *)sender
{
    UIImage *image =   [self changeImage:sender.view.tag imageView:nil];
    [rootImageView setImage:image];
    
    UIImage *waimage =   [self changeWatchImage:sender.view.tag imageView:nil];
    [watchView setImage:waimage];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIImage *)changeImage:(int)index imageView:(UIImageView *)imageView
{
    UIImage *image;
    switch (index) {
        case 0:
        {
            return currentImage;
        }
            break;
        case 1:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
           image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_guangyun];
        }
            break;
        case 11:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_landiao];
            
        }
            break;
        case 12:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_menghuan];
        
        }
            break;
        case 13:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_yese];
            
        }
    }
    return image;
}

-(UIImage *)changeWatchImage:(int)index imageView:(UIImageView *)imageView
{
    UIImage *image;
    switch (index) {
        case 0:
        {
            return hello;
        }
            break;
        case 1:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_guangyun];
        }
            break;
        case 11:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_landiao];
            
        }
            break;
        case 12:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_menghuan];
            
        }
            break;
        case 13:
        {
            image = [ImageUtil imageWithImage:hello withColorMatrix:colormatrix_yese];
            
        }
    }
    return image;
}


- (void)dealloc
{
    [super dealloc];
    scrollerView = nil;
    rootImageView = nil;
    [currentImage release],currentImage  =nil;
    
}
@end
