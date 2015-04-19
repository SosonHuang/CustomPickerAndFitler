//
//  TestViewController.m
//  CustomPickerAndFitler
//
//  Created by soson on 14-6-3.
//  Copyright (c) 2014年 Wu.weibin. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

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
    
    UIImageWriteToSavedPhotosAlbum(self.hechengImage.image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
