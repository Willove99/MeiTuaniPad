//
//  UIBarButtonItem+VVCategory.h
//  
//
//  Created by will on 16/3/3.
//  Copyright © 2016年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (VVCategory)

/** 提供类方法, 返回带有高亮图像的 BarButtonItem*/
+ (instancetype)barBuutonItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon highlighticon:(NSString *)highlighticon;
@end
