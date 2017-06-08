//
//  VVCommon.m
//  MeiTunHD
//
//  Created by will on 2017/5/22.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVCommon.h"

//定义全局常量字符串  static 描述静态全局变量/常量,只能在当前文件中使用; 如果需要常量/变量被其他文件引用,则需要去掉static,定义为全局常量/变量,别的文件需要引用该全局常量,则需要添加extern
//谁定义全局常量/变量,就应该由谁告知其他开发者常量的存在(需要将常量公开)
//项目中的全局常量不能够同名


//城市切换通知
NSString *const VVCityDidChangeNote = @"VVCityDidChangeNote";

//城市切换通知key: 城市名
NSString * const VVCityDidChangeNoteCityName = @"VVCityDidChangeNoteCityName";

// 切换分类通知
NSString *const VVCategoryDidChangeNote = @"VVCategoryDidChangeNote";
// 切换分类通知参数: 分类模型
NSString *const VVCategoryDidChangeNoteModelKey = @"VVCategoryDidChangeNoteModelKey";
// 切换分类通知参数: 子分类名称
NSString *const VVCategoryDidChangeNoteSubtitleKey = @"VVCategoryDidChangeNoteSubtitleKey";

// 切换区域通知
NSString *const VVDistrictDidChangeNote = @"VVDistrictDidChangeNote";
// 切换区域通知参数: 区域模型
NSString *const VVDistrictDidChangeNoteModelKey = @"VVDistrictDidChangeNoteModelKey";
// 切换区域通知参数: 子区域名称
NSString *const VVDistrictDidChangeNoteSubtitleKey = @"VVDistrictDidChangeNoteSubtitleKey";

// 切换排序通知
NSString *const VVSortDidChangeNote = @"VVSortDidChangeNote";
// 切换排序通知参数: 排序模型
NSString *const VVSortDidChangeNoteModelKey = @"VVSortDidChangeNoteModelKey";

//团购cell的宽度
CGFloat const VVDealCellWidth = 305;

//首页Path菜单边距
CGFloat const VVAwesomeMenuMargin = 80;


