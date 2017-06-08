//
//  VVChangeCityViewController.m
//  MeiTunHD
//
//  Created by will on 2017/5/20.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVChangeCityViewController.h"
#import "VVCityGroupModel.h"
#import "VVSearchResultController.h"


@interface VVChangeCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

//分组城市数据
@property (nonatomic, strong)NSArray <VVCityGroupModel *>*cityGroups;

//列表视图
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//遮罩视图
@property (weak, nonatomic) IBOutlet UIButton *maskButton;
//搜索框
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//查询结果控制器  不需要频繁创建/销毁 内存缓存
@property (nonatomic, strong) VVSearchResultController *searchResultVC;

@end

@implementation VVChangeCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //searchBar的代理方法  或是 xib直接设置
//    self.searchBar.delegate = self;
    
    [self setupNav];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
    
    NSArray *dicArr = [NSArray arrayWithContentsOfFile:path];
    
    self.cityGroups = [NSArray yy_modelArrayWithClass:[VVCityGroupModel class] json:dicArr];
    
    [self setupUI];
}

- (void)setupUI {

    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //设置tableView的快速索引颜色
    self.tableView.sectionIndexColor = VVColor(87, 186, 175);
    
    //设置搜索栏颜色
    self.searchBar.tintColor = VVColor(87, 186, 175);
    
    //设置系统控件的文字语言需要通过修改info.plist中的开发区域

}

- (void)setupNav {
    
    //设置标题
    self.title = @"切换城市";
    
    //返回item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(clickCloseItem) icon:@"btn_navigation_close" highlighticon:@"btn_navigation_close_hl"];
}

- (void)clickCloseItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//点击遮罩按钮调用
- (IBAction)clickMaskButton:(id)sender {
    
    [self cancelEditing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //发送通知
    [VVNoteCenter postNotificationName:VVCityDidChangeNote object:nil userInfo:@{VVCityDidChangeNoteCityName: self.cityGroups[indexPath.section].cities[indexPath.row]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - UISearchBarDelegate

//开始编辑后调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //显示取消按钮
    searchBar.showsCancelButton = YES;
    
    //修改搜索栏背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    
    //显示遮罩
    self.maskButton.hidden = NO;
 
}

//搜索栏中的内容发生变化后调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //判断搜索栏中是否有内容,控制器搜索结果视图的显隐
    if (searchBar.text.length) {
        
        self.searchResultVC.view.hidden = NO;
        
        //执行查询
        [self.searchResultVC fetchKeyword:searchBar.text];

        
    } else {
        
        self.searchResultVC.view.hidden = YES;
    }
}

//点击取消按钮后调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self cancelEditing];
    
    //清空搜索栏内容
    searchBar.text = nil;
    
    //隐藏搜索结果视图
    self.searchResultVC.view.hidden = YES;
}


//取消编辑调用
- (void)cancelEditing{
    
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //隐藏取消按钮
    self.searchBar.showsCancelButton = NO;
    
    //修改搜索栏背景图片
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    //隐藏遮罩
    self.maskButton.hidden = YES;
    
    //取消编辑
    [self.searchBar endEditing:YES];
}


//代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    

    return self.cityGroups.count;
}

//设置组头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.cityGroups[section].title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cityGroups[section].cities.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //设置数据
    cell.textLabel.text = self.cityGroups[indexPath.section].cities[indexPath.row];
    
    return cell;
    
}

//设置快速索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    //获取数组中每个元素的某个成员变量组成的数组
    return  [self.cityGroups valueForKey:@"title"];
}

//懒加载
- (VVSearchResultController *)searchResultVC {
    
    if (_searchResultVC == nil) {
        
        _searchResultVC = [VVSearchResultController new];
        
        //设置父子控制器  添加子控制器
        [self addChildViewController:_searchResultVC];
        
        //显示内容
        [self.view addSubview:_searchResultVC.view];
    
        //添加子视图 一定要设置尺寸约束
        [_searchResultVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.tableView);
        }];
        
        //设置默认隐藏搜索结果视图
        _searchResultVC.view.hidden = YES;
    
    }
    
    return _searchResultVC;
    
}
@end
