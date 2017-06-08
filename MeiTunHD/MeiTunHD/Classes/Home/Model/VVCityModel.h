//
//  VVCityModel.h
//  MeiTuanHD
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVCityModel : NSObject

/** 名字*/
@property (nonatomic, copy) NSString *name;

/** 拼音全称*/
@property (nonatomic, copy) NSString *pinYin;

/** 拼音缩写*/
@property (nonatomic, copy) NSString *pinYinHead;

/** 子数据(区县街道)--> districts 对应的也是数据模型*/
@property (nonatomic, strong) NSArray *districts;

@end
