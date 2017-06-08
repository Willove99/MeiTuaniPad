//
//  VVSortViewController.m
//  MeiTunHD
//
//  Created by will on 2017/5/24.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVSortViewController.h"
#import "VVSortModel.h"

@interface VVSortViewController ()

@property (nonatomic,strong) NSArray *sortArr;

@end

@implementation VVSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载plist文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil];
    
    NSArray *plist = [NSArray arrayWithContentsOfFile:path];
    
    self.sortArr = [NSArray yy_modelArrayWithClass:NSClassFromString(@"VVSortModel") json:plist];
    
    //创建按钮
    NSInteger count = self.sortArr.count;
    
    //frame
    CGFloat margin = 15;
    CGFloat width = 100;
    CGFloat height = 30;
    
    for (int i = 0; i < count; i++) {
        
        //初始化
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                            
        //取出sort模型数据
        VVSortModel *sortModel = self.sortArr[i];
        
        //设置标题
        [button setTitle:sortModel.label forState:UIControlStateNormal];
        
        //设置文字颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        //设置背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        
        //设置frame
        button.width = width;
        button.height = height;
        button.x = margin;
        button.y = margin + (button.height + margin) * i;
        // 绑定tag --> 区分点击了哪一个按钮
        button.tag = i;
        
        // 添加方法
        [button addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
    //设置 popover 大小
    CGFloat contentWidth = 2 * margin + width;
    CGFloat contentHeight = (margin + height) * count + margin;
    self.preferredContentSize = CGSizeMake(contentWidth, contentHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 按钮点击方法
- (void)sortButtonClick:(UIButton *)button
{
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:VVSortDidChangeNote object:nil userInfo:@{VVSortDidChangeNoteModelKey : self.sortArr[button.tag]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
