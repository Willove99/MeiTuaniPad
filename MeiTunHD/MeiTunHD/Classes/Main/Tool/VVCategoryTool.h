//
//  VVCategoryTool.h
//  MeiTunHD
//
//  Created by 王惠平 on 2017/6/6.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVCategoryTool : NSObject

//获取分类数据
+ (NSArray *)getCategories;


/**
 根据分类数据查询对应的地图分类图片

 @param categoryName 分类名称
 @return 地图分类图片
 */
+ (NSString *)categoryImgNameWithCategoryName:(NSString *)categoryName;

@end
