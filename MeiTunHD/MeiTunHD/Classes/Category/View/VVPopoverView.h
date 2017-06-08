//
//  VVPopoverView.h
//  MeiTunHD
//
//  Created by will on 2017/5/18.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVPopoverView : UIView

//一级菜单
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
//二级菜单
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

+ (instancetype)popoverView;

@end
