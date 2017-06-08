//
//  VVSortModel.h
//  MeiTunHD
//
//  Created by will on 2017/5/24.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVSortModel : NSObject

/** 名字 */
@property (nonatomic, copy) NSString *label;

/** 值--> 给服务器发送的 */
@property (nonatomic, strong) NSNumber *value;


@end
