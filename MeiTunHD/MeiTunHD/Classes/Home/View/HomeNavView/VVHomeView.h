//
//  VVHomeView.h
//  MeiTunHD
//
//  Created by will on 2017/5/18.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVHomeView : UIControl


/**
 标题
 */
@property (nonatomic,copy) NSString *title;


/**
 子标题
 */
@property (nonatomic,copy) NSString *subtitle;


/**
 图片
 */
@property (nonatomic,copy) NSString *iconImgName;


/**
 高亮图片
 */
@property (nonatomic,copy) NSString *iconHighligtedImgName;

+ (instancetype) homeNavView;

@end
