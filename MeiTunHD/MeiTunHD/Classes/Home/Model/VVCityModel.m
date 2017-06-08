//
//  VVCityModel.m
//  MeiTuanHD
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 will. All rights reserved.
//

#import "VVCityModel.h"
#import "VVDistrictModel.h"

@implementation VVCityModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"districts" : [VVDistrictModel class]};
}

@end
