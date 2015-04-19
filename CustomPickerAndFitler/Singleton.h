//
//  Singleton.h
//  CustomPickerAndFitler
//
//  Created by soson on 14-5-30.
//  Copyright (c) 2014年 Wu.weibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

@property (nonatomic, strong) UIImage *watchImage;
//获取数据
+(Singleton *)getData;
@end
