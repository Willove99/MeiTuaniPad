//
//  VVPopoverView.m
//  MeiTunHD
//
//  Created by will on 2017/5/18.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVPopoverView.h"

@implementation VVPopoverView

+ (instancetype)popoverView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"VVPopoverView" owner:nil options:nil].lastObject;
}

@end
