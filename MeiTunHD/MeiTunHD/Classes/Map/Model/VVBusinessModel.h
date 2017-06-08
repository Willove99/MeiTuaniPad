//
//  VVBusinessModel.h
//  MeiTunHD
//
//  Created by 王惠平 on 2017/6/5.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VVBusinessModel : NSObject <MKAnnotation>

/** 商户名*/
@property (nonatomic, copy) NSString *name;

/** 地址*/
@property (nonatomic, copy) NSString *address;

/** 纬度坐标*/
@property (nonatomic, assign) CGFloat latitude;

/** 经度坐标*/
@property (nonatomic, assign) CGFloat longitude;

/** 分类*/
@property (nonatomic, strong) NSArray *categories;




@end
