//
//  TestViewController.m
//  CustomPickerAndFitler
//
//  Created by soson on 14-6-3.
//  Copyright (c) 2014年 Wu.weibin. All rights reserved.
//

#import "TestViewController.h"
#import "IphoneScreen.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"

@interface TestViewController ()
{
UIScrollView *scrollerView;
}
@end

@implementation TestViewController

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
    
    self.hechengImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 300, 400)];
    self.hechengImage.image=self.testImage;
    [self.view addSubview:self.hechengImage];
    
    //UIImageWriteToSavedPhotosAlbum(self.testImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    
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
        UIImage *bgImage = [self doneChangeImage:i imageView:nil];
        bgImageView.image = bgImage;
        [scrollerView addSubview:bgImageView];
        [bgImageView release];
        
        [recognizer release];
        
    }
    scrollerView.contentSize = CGSizeMake(x + 55, 80);
    [self.view addSubview:scrollerView];
}



- (IBAction)setImageStyle:(UITapGestureRecognizer *)sender
{
    
    UIImage *image =   [self doneChangeImage:sender.view.tag imageView:nil];
    [self.hechengImage setImage:image];
    
}



-(UIImage *)doneChangeImage:(int)index imageView:(UIImageView *)imageView
{
    UIImage *image;
    
    
    switch (index) {
        case 0:
        {
            return self.testImage;
        }
            break;
        case 1:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_guangyun];
        }
            break;
        case 11:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_landiao];
            
        }
            break;
        case 12:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_menghuan];
            
        }
            break;
        case 13:
        {
            image = [ImageUtil imageWithImage:self.testImage withColorMatrix:colormatrix_yese];
            
        }
    }
    return image;
}



-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        //UIImageWriteToSavedPhotosAlbum()保存照片到系统相册出现 －3310 不能保存成功的问题
        //Error Domain=ALAssetsLibraryErrorDomain Code=-3310 "数据不可用" UserInfo=0xc971ed0 {NSLocalizedRecoverySuggestion=启动“照片”应用程序, NSUnderlyingError=0xc974e50 "数据不可用", NSLocalizedDescription=数据不可用}
        
        //请在 设置-隐私-照片 中打开应用程序访问权限。
        msg = @"保存图片失败，请检查" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
