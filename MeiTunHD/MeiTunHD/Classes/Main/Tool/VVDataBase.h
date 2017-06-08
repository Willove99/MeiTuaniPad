//
//  VVDataBase.h
//  MeiTunHD
//
//  Created by will on 2017/6/1.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVDealModel.h"

@interface VVDataBase : NSObject

//保存收藏
+ (void)insertDealWithDealModel:(VVDealModel*)dealModel;
//删除收藏
+ (void)deleteDealWithDealModel:(VVDealModel*)dealModel;
//判断是否收藏改团购(查询数据库中是否保存改记录)
+ (BOOL)hasDeal:(VVDealModel*)dealModel;
//根据页码获取收藏的团购信息
+ (NSArray <VVDealModel*>*)queryCollectsWith:(NSInteger)page error:(NSError**)error;

@end
