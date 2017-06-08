//
//  VVDateFormater.h
//  MeiTunHD
//
//  Created by will on 2017/5/25.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVDateFormater : NSDateFormatter


+ (instancetype)sharedIntance;

//设置格式
- (void)setupDateFromatFromString:(NSString *)dateString;

@end
