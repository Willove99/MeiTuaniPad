//
//  VVNavigationController.m
//  MeiTunHD
//
//  Created by will on 2017/5/17.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVNavigationController.h"

@interface VVNavigationController ()

@end

@implementation VVNavigationController

+ (void)initialize {
    
    //设置nav主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    //设置背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    //设置barbuttonItem的主题颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:VVColor(87, 186, 175) }forState:UIControlStateNormal];
    
    //设置禁用文字颜色
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
