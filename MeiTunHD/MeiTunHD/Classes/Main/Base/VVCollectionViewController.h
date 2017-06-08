//
//  VVCollectionViewController.h
//  MeiTunHD
//
//  Created by will on 2017/5/31.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VVRequestTypeNetwork,
    VVRequestTypeClearUI,

} VVRequestType;

@protocol VVRequestParam <NSObject>

@optional

/**
 添加自定义团购请求参数

 @param baseParam 基础请求参数
 */
- (VVRequestType)addSetupCustemParam:(NSMutableDictionary *)baseParam;

@end

@interface VVCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray <VVDealModel *>*deals;
//当前页码
@property (nonatomic, assign) NSInteger currentPage;
//记录当前城市的名称
@property(nonatomic,copy) NSString *currentCityName;

@end
