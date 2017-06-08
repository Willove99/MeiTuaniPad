//
//  VVSearchResultController.m
//  MeiTunHD
//
//  Created by will on 2017/5/22.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVSearchResultController.h"
#import "VVCityModel.h"
#import "VVHomeViewController.h"

@interface VVSearchResultController ()<UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray <VVCityModel *>*searchResults;

@end

@implementation VVSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)fetchKeyword:(NSString *)keyword {
    
    //每次重新查询,需要清空结果集
    self.searchResults = nil;
    
    //转为小写
    keyword = [keyword lowercaseString];
    
    //获取cities.plist中的数据 从homeVC中取出内存缓存即可
    VVHomeViewController *homeVC = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0];
    
    //遍历每个城市的数据
    for (VVCityModel *city in homeVC.cities) {
        
        //匹配符合的城市名&城市名全拼&城市名拼音首字母
        if ([city.name containsString:keyword] || [city.pinYin containsString:keyword] || [city.pinYinHead containsString:keyword] ) {
            
            //将匹配的城市展示在视图上
            [self.searchResults addObject:city];
        }
        
    }
    
    //刷新数据
    [self.tableView reloadData];
    
}

#pragma  mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //发送切换城市的通知
    [VVNoteCenter postNotificationName:VVCityDidChangeNote object:nil userInfo:@{VVCityDidChangeNoteCityName: self.searchResults[indexPath.row].name}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置组头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [NSString stringWithFormat:@"共有%zd个结果", self.searchResults.count];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.searchResults[indexPath.row].name;
    
    return cell;
}

//懒加载
- (NSMutableArray<VVCityModel *> *)searchResults {
    
    
    if (_searchResults == nil) {
        
        _searchResults = [NSMutableArray new];

    }
    
    return  _searchResults;
}
@end
