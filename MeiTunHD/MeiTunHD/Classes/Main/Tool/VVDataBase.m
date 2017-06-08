//
//  VVDataBase.m
//  MeiTunHD
//
//  Created by will on 2017/6/1.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVDataBase.h"

static FMDatabase *_db;

@implementation VVDataBase

+ (void)initialize {
    
    //设置数据库文件路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"collect.sqlite"];
    
    //创建数据库对象
    _db = [FMDatabase databaseWithPath:path];
    
    //打开数据库进行连接
    if (![_db open]) {
        
        VVLog(@"数据库打开失败: %@", _db.lastError);
        
        return;
    }
    
    //创建表(不存在) 一定添加 IF NOT EXISTS
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect (id integer NOT NULL,deal_model blob,deal_id text,PRIMARY KEY(id));"];
    
}

//判断是否收藏该团购(查询数据库中是否保存改记录)
+ (BOOL)hasDeal:(VVDealModel*)dealModel {
    
    //获取满足条件的结果的数量: COUNT(*)
    //起别名:  AS 别名
    //执行查询
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT COUNT(*) AS collect_count FROM t_collect WHERE deal_id = %@",dealModel.deal_id];
    
    //执行查询
    if ([set next]) {
    
        int count = [set intForColumn:@"collect_count"];
        
        return count ? YES : NO;
    }
    return NO;
}

//保存收藏到本地的数据库
+ (void)insertDealWithDealModel:(VVDealModel*)dealModel {
    
    //将模型保存为二进制数据,并且保留对象关系 使用归档 实现NSCoding协议(可以使用yymodal简化处理)
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dealModel];
    
    //插入数据
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect (deal_model,deal_id) VALUES(%@,%@)",data,dealModel.deal_id];
    
}

+ (void)deleteDealWithDealModel:(VVDealModel*)dealModel {
    
    //删除数据
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect WHERE deal_id = %@", dealModel.deal_id];

}

//根据页码获取收藏的团购信息
+ (NSArray <VVDealModel*>*)queryCollectsWith:(NSInteger)page error:(NSError**)error{
    
    //数据分页 LIMIT  location  length
    /**
     * location  length  page
         0         20     1
         20        20     2
         40        20     3
     
     location = (page - 1) * length
     */
    NSInteger length = 3;
    
    NSInteger location = (page - 1) * length;
    
    //可以根据主键进行倒序排列
    //执行查询
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect ORDER BY id  LIMIT %ld,%ld",location,length];
    
    NSMutableArray *temp = [NSMutableArray array];
    
    while ([set next]) {
        
        NSData * data = [set dataForColumn:@"deal_model"];
        
        //二进制数据转为模型
        VVDealModel *dealModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
   
        //添加到数组中
        [temp addObject:dealModel];
    }
    
    if ([_db hadError]) {
        
        VVLog(@"查询失败:%@",_db.lastError);
        //使用指针运算符操作地址中的内容
        *error = _db.lastError;
    }
    return temp.copy;
    
}
@end
