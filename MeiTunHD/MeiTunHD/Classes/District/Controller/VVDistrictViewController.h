//
//  VVDistrictViewController.h
//  MeiTunHD
//
//  Created by will on 2017/5/19.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVPopoverView.h"
#import "VVDistrictModel.h"

@interface VVDistrictViewController : UIViewController

//一级区域数据
@property (nonatomic, strong) NSArray <VVDistrictModel *> *distrcits;


//内部的二级联动视图
@property (nonatomic,strong,readonly)VVPopoverView *popoverView;

@end
