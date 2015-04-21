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
#import "opencv2/highgui/ios.h"
#import "opencv2/core/core.hpp"
#import "opencv2/imgproc/imgproc.hpp"
#import "opencv2/highgui/highgui.hpp"
#include "ImageFilter.h"

@interface ImageFilterProcessViewController ()
{
    UIImageView *watchView;
    UIImage *hello;
    
    //处理后的图片
    UIImage *processImage;
    
    int watchX;
    int watchY;
    
    ZDStickerView *userResizableView1;
    
    //判断是否隐藏了控件
    BOOL isHidden;
    
    MVArrowOverlayView *tappableView;
        MVArrowOverlayView *tappableView2;
    UIView *bg;
    

    UIImage *filterImage;
    
}
@end

@implementation ImageFilterProcessViewController
@synthesize currentImage = currentImage, delegate = delegate;
@synthesize filter;

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


-(UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg topleft:(CGPoint)tlPos
{
    
    UIGraphicsBeginImageContext(oneImg.size);
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(tlPos.x, tlPos.y, twoImg.size.width, twoImg.size.height)];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
    
}



- (IBAction)fitlerDone:(id)sender
{
        userResizableView1.borderView.hidden=YES;
        userResizableView1.resizingControl.hidden=YES;
    
        UIGraphicsBeginImageContextWithOptions(rootImageView.frame.size,NO,0.0);
        [rootImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    
        TestViewController *test=[[TestViewController alloc]init];
        test.testImage=newImage;
        [self presentViewController:test animated:YES completion:nil];
        userResizableView1.resizingControl.hidden=NO;
    
}



#pragma MARK 图片放大缩小
-(void)scaGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
       UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

#pragma MARK 旋转
// 旋转
-(void)rotate:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
       UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }

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




#pragma MARK 自动生成图片
-(UIImage *)autoGrene:(UIImageView *)watchImageView{
    
    //底部图片
    UIImageView *bottom = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 200, 200)];
    bottom.backgroundColor=[UIColor blackColor];
    bottom.alpha=0.1;
    
    [bottom addSubview:watchImageView];
    
    UIImageView *top = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 200, 200)];
    top.backgroundColor=[UIColor blackColor];
    top.alpha=0.1;
    [watchImageView addSubview:top];
    
    
    UIGraphicsBeginImageContext( bottom.frame.size);
    [bottom.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *onlyOne = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  onlyOne;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaLast|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
//                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGImageAlphaPremultipliedLast|
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}


-(void)autoGenImage:(int)shod andBrightneess:(int)bright{
    UIImage* image = watchView.image;
    cv::Mat faceImage;
    faceImage = [self cvMatFromUIImage:image];
    cv::Mat shadow = addShadow(faceImage, shod);
    cv::Mat final = adjustBrightneess(faceImage, shadow, bright);
    watchView.image = [self UIImageFromCVMat:final];
    userResizableView1.contentView = watchView;
    [userResizableView1 setContentView:watchView];
    [userResizableView1 setNeedsLayout];
    
//    [rootImageView addSubview:userResizableView1];
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
   
    
    //底部大图
    rootImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(10, 50, 300, 400)];
    rootImageView.image = currentImage;
    rootImageView.userInteractionEnabled=YES;
    [self.view addSubview:rootImageView];
    
    hello=[Singleton getData].watchImage;
    
   
    //手表的图片
    watchView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 200, 200)];
    watchView.userInteractionEnabled=YES;
    watchView.image = hello;
    
    
    //Load image with face
    UIImage* image = watchView.image;
    cv::Mat faceImage;
    faceImage = [self cvMatFromUIImage:image];
    cv::Mat shadow = addShadow(faceImage, 10);
    cv::Mat final = adjustBrightneess(faceImage, shadow, 0.2);
    watchView.image = [self UIImageFromCVMat:final];
    
    
    CGRect gripFrame1 = CGRectMake(50, 50, 200, 200);
    userResizableView1 = [[ZDStickerView alloc] initWithFrame:gripFrame1];
    userResizableView1.contentView = watchView;
    userResizableView1.preventsPositionOutsideSuperview = NO;
    [userResizableView1 showEditingHandles];
    [rootImageView addSubview:userResizableView1];

    
    
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
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50,500,200,20)];
    //slider.center = CGPointMake(160.0f, 140.0f);
    //设置值
    //设置最小值
    slider.minimumValue=0;
    //设置最大值
    slider.maximumValue=1;
    // 回调与事件
    [slider addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(updateThumb:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    // 添加
    
    [self.view addSubview:slider];
}


-(void)viewDidLayoutSubviews{
   NSLog(@"viewDidLayoutSubviews");
}

-(void)startDrag:(UISlider *)slider{
    NSLog(@"start ---%f",slider.value);
    [self autoGenImage:slider.value andBrightneess:slider.value];
}

-(void)updateThumb:(UISlider *)slider{
    NSLog(@"ing----%f",slider.value);
}

-(void)endDrag:(UISlider *)slider{
    NSLog(@"end----%f",slider.value);
}

-(void)bgTapSmall:(UITapGestureRecognizer *)sender
{
    bg.hidden=YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
            NSLog(@"processImage %@",processImage);
            return processImage;
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

cv::Mat addShadow(cv::Mat&origin, int offset) {
    cv::Mat tmp = cv::Mat::ones(origin.rows, origin.cols, CV_8UC1);
    cv::Mat blurred = cv::Mat::zeros(origin.rows, origin.cols, CV_8UC4);
    tmp = tmp*255;
    
    for(int row=0; row<origin.rows; row++){
        for(int col=0; col<origin.cols; col++){
            cv::Vec4b vec = origin.at<cv::Vec4b>(row,col);
            if(vec[3]==0){
                continue;
            }
            if((col+offset)>=origin.cols || (col+offset)<=0){
                continue;
            }
            else{
                tmp.at<uint8_t>(row, col+offset) = 0;
            }
            blurred.at<cv::Vec4b>(row,col) = cv::Vec4b(255,255,255,0);
        }
        
    }
    
    cv::Mat mask = cv::Mat::zeros(origin.rows, origin.cols, CV_8UC1);
    
    cv::GaussianBlur(tmp, mask, cv::Size(131,131), 20.0);
    
    for(int row=0; row<origin.rows; row++){
        for(int col=0; col<origin.cols; col++){
            int diff = mask.at<uint8_t>(row,col) - tmp.at<uint8_t>(row,col);
            if(mask.at<uint8_t>(row,col)>0){
                uint8_t d=250-mask.at<uint8_t>(row,col);
                blurred.at<cv::Vec4b>(row,col) = cv::Vec4b(0,0,0, d);
            }
        }
    }
    
    for(int row=0; row<origin.rows; row++){
        for(int col=0; col<origin.cols; col++){
            cv::Vec4b vec = origin.at<cv::Vec4b>(row,col);
            if(vec[3]>0)
            {
                cv::Vec4b& v2 = origin.at<cv::Vec4b>(row, col);
                blurred.at<cv::Vec4b>(row,col) = vec;
            }
            else{
//                printf("aaa\n");
            }
        }
    }
    
    return blurred;

}

cv::Mat adjustBrightneess(cv::Mat& origin, cv::Mat& shadowed, double alpha){
    cv::Mat tmp = cv::Mat::zeros(origin.rows, origin.cols, CV_8UC4);
    
    for(int row=0; row<origin.rows; row++){
        for(int col=0; col<origin.cols; col++){
            cv::Vec4b vec = origin.at<cv::Vec4b>(row,col);
            if(vec[3]>0){
                tmp.at<cv::Vec4b>(row,col) = cv::Vec4b(0,0,0,255);
            }
        }
    }
    
    cv::Mat t = cv::Mat::zeros(origin.rows, origin.cols, CV_8UC4);
    
    cv::addWeighted(shadowed, 1.0-alpha, tmp, alpha, 0.0, t);
    return t;
}


// cv::Mat origin
// cv::Mat shadowd = addShadow(origin, offfset)
// cv::final = adjustBrightness(origin, shadowed, 0.2)
//
- (void)dealloc
{
    [super dealloc];
    scrollerView = nil;
    rootImageView = nil;
    [currentImage release],currentImage  =nil;
    
}
@end
