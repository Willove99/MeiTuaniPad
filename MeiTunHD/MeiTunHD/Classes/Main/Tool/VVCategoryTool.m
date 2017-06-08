//
//  VVCategoryTool.m
//  MeiTunHD
//
//  Created by 王惠平 on 2017/6/6.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVCategoryTool.h"
#import "VVCategoryModel.h"

static NSArray *_categories;

@implementation VVCategoryTool

+ (NSArray *)getCategories {
    
    if (_categories == nil) {
        
        //从plist中获取的数据
        NSString *path = [[NSBundle mainBundle] pathForResource:@"categories.plist" ofType:nil];
        
        NSArray *dicArr = [NSArray arrayWithContentsOfFile:path];
        
        //使用YYModel进行字典转模型
        _categories = [NSArray yy_modelArrayWithClass:[VVCategoryModel class] json:dicArr];
    }
    
    return _categories;
}

+ (NSString *)categoryImgNameWithCategoryName:(NSString *)categoryName {
    
    //遍历分类数据,查看对应的图片
    for (VVCategoryModel *category in [self getCategories]) {
        
        if ([category.name isEqualToString:categoryName]) {
            
            return category.map_icon;
        }
        
        //遍历子类数据
        for (NSString *subCategory in category.subcategories) {
            
            if ([subCategory isEqualToString:categoryName]) {
                
                return category.map_icon;
            }
        }
    }
    
    return @"ic_category_default";
}

@end
