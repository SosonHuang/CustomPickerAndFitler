//
//  Singleton.m
//  CustomPickerAndFitler
//
//  Created by soson on 14-5-30.
//  Copyright (c) 2014年 Wu.weibin. All rights reserved.
//

#import "Singleton.h"

static Singleton *_sharedInformation = nil; //第一步：静态实例，并初始化
@implementation Singleton
//单列模式
#pragma mark 单列初始化
+(Singleton *)getData
{
	if (!_sharedInformation) {
		_sharedInformation = [[self alloc] init];
	}
	
	return _sharedInformation;
}
@end