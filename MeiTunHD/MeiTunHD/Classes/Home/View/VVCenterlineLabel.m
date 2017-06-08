//
//  VVCenterlineLabel.m
//  MeiTunHD
//
//  Created by will on 2017/5/25.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVCenterlineLabel.h"

@implementation VVCenterlineLabel

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    //添加中线
    
    //在尺寸内填充颜色
    UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));
    
}


@end
