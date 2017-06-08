//
//  VVBusinessModel.m
//  MeiTunHD
//
//  Created by 王惠平 on 2017/6/5.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVBusinessModel.h"

@implementation VVBusinessModel

- (CLLocationCoordinate2D)coordinate {
    
    return CLLocationCoordinate2DMake(_latitude, _longitude);
}

- (NSString *)title {
    
    return _name;
}

- (NSString *)subtitle {
    
    return _address;
}

@end
