//
//  VVDealModel.m
//  MeiTuanHD
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 will. All rights reserved.
//

#import "VVDealModel.h"

@implementation VVDealModel

/**
 自定义模型的属性的匹配Key
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc"  : @"description"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self yy_modelEncodeWithCoder:aCoder];

}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    return [self yy_modelInitWithCoder:aDecoder];

}


@end
