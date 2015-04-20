//
//  ImageFilterProcessViewController.h
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class imageFilter;
@class Draw;

@protocol ImageFitlerProcessDelegate;
@interface ImageFilterProcessViewController : UIViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView *rootImageView;
    UIScrollView *scrollerView;
    UIImage *currentImage;
    id <ImageFitlerProcessDelegate> delegate;
}
@property(nonatomic,assign) id<ImageFitlerProcessDelegate> delegate;
@property(nonatomic,retain)UIImage *currentImage;
@property (nonatomic, retain) imageFilter *filter;
@end

@protocol ImageFitlerProcessDelegate <NSObject>

- (void)imageFitlerProcessDone:(UIImage *)image;
@end
