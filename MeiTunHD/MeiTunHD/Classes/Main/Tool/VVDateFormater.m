//
//  VVDateFormater.m
//  MeiTunHD
//
//  Created by will on 2017/5/25.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVDateFormater.h"

static VVDateFormater *_instance;

@implementation VVDateFormater


+ (instancetype)sharedIntance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [VVDateFormater new];
        
        [_instance setupDateFromatFromString:@"yyyy-MM-dd"];
        
    });
    
    return _instance;
}

//设置格式
- (void)setupDateFromatFromString:(NSString *)dateString {
    
    _instance.dateFormat = dateString;
    
}


@end
