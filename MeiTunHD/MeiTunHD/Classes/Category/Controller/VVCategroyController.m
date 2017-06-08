//
//  VVCategroyController.m
//  MeiTunHD
//
//  Created by will on 2017/5/18.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVCategroyController.h"
#import "VVPopoverView.h"
#import "VVCategoryModel.h"
#import "VVCategoryTool.h"

static NSString *leftcell = @"leftcell";
static NSString *rightCell = @"rightCell";


@interface VVCategroyController () <UITableViewDelegate,UITableViewDataSource>

//分类数据
@property(nonatomic,strong)NSArray <VVCategoryModel *> *categories;

//选中的一级菜单索引
@property(nonatomic,assign)NSInteger selecetedIndex;

@end

@implementation VVCategroyController

@synthesize popoverView = _popoverView;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    

}


- (VVPopoverView *)popoverView {
    
    if (_popoverView == nil) {
        
        _popoverView = [VVPopoverView popoverView];
        
        [self.view addSubview:_popoverView];
        
        _popoverView.leftTableView.delegate = self;
        _popoverView.leftTableView.dataSource = self;
        _popoverView.rightTableView.delegate = self;
        _popoverView.rightTableView.dataSource = self;
        
        //从工具类中获取数据
        self.categories = [VVCategoryTool getCategories];
        
    }
    
    return _popoverView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //区分一级/二级菜单
    if (tableView == _popoverView.leftTableView) {
        
        return self.categories.count;
        
    } else { //二级菜单
        
        return self.categories[self.selecetedIndex].subcategories.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == _popoverView.leftTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:leftcell];
    
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftcell];
            
            //设置cell的背景图片
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];

        }
        
        //设置数据
        cell.textLabel.text = self.categories[indexPath.row].name;
    
        //设置一级菜单图标
        cell.imageView.image = [UIImage imageNamed:self.categories[indexPath.row].small_icon];
        cell.imageView.highlightedImage = [UIImage imageNamed:self.categories[indexPath.row].small_highlighted_icon];

        //设置箭头  如果有二级菜单在设置
        if (self.categories[indexPath.row].subcategories.count) {
            
            //设置箭头
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else { //避免重用,箭头错误设置
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
    } else { //二级菜单
        
        cell = [tableView dequeueReusableCellWithIdentifier:rightCell];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCell];
            
            //设置cell的背景图片
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];

        }
        
        //设置数据
        cell.textLabel.text = self.categories[self.selecetedIndex].subcategories[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _popoverView.leftTableView) {
        
        if (self.categories[indexPath.row].subcategories) {
            
            
            //记录一级菜单索引,用于设置二级数据源
            self.selecetedIndex = indexPath.row;
            
            //刷新二级数据
            [_popoverView.rightTableView reloadData];
            
        } else {
            
            [VVNoteCenter postNotificationName:VVCategoryDidChangeNote object:nil userInfo:@{VVCategoryDidChangeNoteModelKey: self.categories[indexPath.row]}];

            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    
    } else { //选择二级菜单
        
        //打印
//        VVLog(@"%@",self.categories[self.selecetedIndex].subcategories[indexPath.row]);
        [VVNoteCenter postNotificationName:VVCategoryDidChangeNote object:nil userInfo:@{VVCategoryDidChangeNoteModelKey: self.categories[self.selecetedIndex],VVCategoryDidChangeNoteSubtitleKey: self.categories[self.selecetedIndex].subcategories[indexPath.row]}];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
@end
