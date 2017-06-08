//
//  VVDistrictViewController.m
//  MeiTunHD
//
//  Created by will on 2017/5/19.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVDistrictViewController.h"
#import "VVChangeCityViewController.h"
#import "VVNavigationController.h"

static NSString *leftCell = @"leftCell";
static NSString *rightCell = @"rightCell";

@interface VVDistrictViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView;

//选中的一级菜单
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation VVDistrictViewController

//点击切换城市
- (IBAction)clickChangeCityBtn:(id)sender {
    
    //移除区域控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //创建控制器
    VVChangeCityViewController *changeCityVC = [[VVChangeCityViewController alloc]init];
    
    VVNavigationController *NAV = [[VVNavigationController alloc]initWithRootViewController:changeCityVC];
    
    //设置modal展示样式
    NAV.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //设置modal的转场样式 水平翻转
    NAV.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    //进行modal展示 只要在同一个响应者链条上都可以执行modal操作
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:NAV animated:YES completion:nil];
}


@synthesize popoverView = _popoverView;

//懒加载
- (VVPopoverView *)popoverView {
    
    if(_popoverView == nil) {
        
        //添加二级联动视图
        _popoverView = [VVPopoverView popoverView];
        
        //添加视图
        [self.view addSubview:_popoverView];
        
        //数据源方法
        _popoverView.leftTableView.delegate = self;
        _popoverView.leftTableView.dataSource = self;
        _popoverView.rightTableView.delegate = self;
        _popoverView.rightTableView.dataSource = self;
        
        //设置位置
        _popoverView.y = self.topView.height;
        
        
    }
    
    return _popoverView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _popoverView.leftTableView) {
        
        return self.distrcits.count;
        
    } else {
        
        return self.distrcits[self.selectedIndex].subdistricts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == _popoverView.leftTableView) {//一级视图
        
        cell = [tableView dequeueReusableCellWithIdentifier:leftCell];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCell];
            
            //设置背景图片
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
        }
        
        cell.textLabel.text = self.distrcits[indexPath.row].name;
        
        //设置详情箭头
        if (self.distrcits[indexPath.row].subdistricts.count) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;;
       
        } else {//避免重用,箭头错误设置
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:rightCell];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCell];
            
            //设置背景图片
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
        }
        
        cell.textLabel.text = self.distrcits[self.selectedIndex].subdistricts[indexPath.row];
    }
    
    return  cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _popoverView.leftTableView) { //一级菜单
        
        if (self.distrcits[indexPath.row].subdistricts) {
        
            
            //记录索引
            self.selectedIndex = indexPath.row;
            
            //刷新二级菜单
            [_popoverView.rightTableView reloadData];
            
        } else {
            
            //没有二级 直接发送通知
            [VVNoteCenter postNotificationName:VVDistrictDidChangeNote object:nil userInfo:@{VVDistrictDidChangeNoteModelKey: self.distrcits[indexPath.row]}];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    
    }else { //二级菜单
        
        //打印
//        VVLog(@"%@", self.distrcits[self.selectedIndex].subdistricts[indexPath.row]);
        
        [VVNoteCenter postNotificationName:VVDistrictDidChangeNote object:nil userInfo:@{VVDistrictDidChangeNoteModelKey: self.distrcits[self.selectedIndex],VVDistrictDidChangeNoteSubtitleKey: self.distrcits[self.selectedIndex].subdistricts[indexPath.row]}];
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

@end
