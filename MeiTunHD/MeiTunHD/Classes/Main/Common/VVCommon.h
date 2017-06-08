//
//  VVCommon.h
//  MeiTunHD
//
//  Created by will on 2017/5/22.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <Foundation/Foundation.h>

//引用全局常量(定义全局常量的文件,需要在其.h中再引用该全局常量)
//UIKIT_EXTERN 相当于extern 但是可以区分c/oc/c++中不同的写法

//团购cell的宽度
UIKIT_EXTERN CGFloat const VVDealCellWidth;


//城市切换通知
UIKIT_EXTERN NSString *const VVCityDidChangeNote;

//城市切换通知key: 城市名
UIKIT_EXTERN NSString * const VVCityDidChangeNoteCityName;

// 切换分类通知
UIKIT_EXTERN NSString *const VVCategoryDidChangeNote;
// 切换分类通知参数: 分类模型
UIKIT_EXTERN NSString *const VVCategoryDidChangeNoteModelKey;
// 切换分类通知参数: 子分类名称
UIKIT_EXTERN NSString *const VVCategoryDidChangeNoteSubtitleKey;

// 切换区域通知
UIKIT_EXTERN NSString *const VVDistrictDidChangeNote;
// 切换区域通知参数: 区域模型
UIKIT_EXTERN NSString *const VVDistrictDidChangeNoteModelKey;
// 切换区域通知参数: 子区域名称
UIKIT_EXTERN NSString *const VVDistrictDidChangeNoteSubtitleKey;

// 切换排序通知
UIKIT_EXTERN NSString *const VVSortDidChangeNote;
// 切换排序通知参数: 排序模型
UIKIT_EXTERN NSString *const VVSortDidChangeNoteModelKey;

//首页Path菜单边距
UIKIT_EXTERN CGFloat const VVAwesomeMenuMargin;


