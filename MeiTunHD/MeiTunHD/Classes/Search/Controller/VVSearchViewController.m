//
//  VVSearchViewController.m
//  MeiTunHD
//
//  Created by will on 2017/5/29.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVSearchViewController.h"

@interface VVSearchViewController ()<UISearchBarDelegate,VVRequestParam>

@property(nonatomic,strong)UISearchBar *searchBar;
@end

@implementation VVSearchViewController

//static NSString * const reuseIdentifier = @"Cell";

//- (instancetype)init {
//    
//    self = [super initWithCollectionViewLayout:[UICollectionViewLayout new]];
//    
//    if (self) {
//        
//        self.collectionView.backgroundColor = [UIColor cyanColor];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    //设置导航栏
    [self setupNav];
    
    
}

//设置导航栏
- (void)setupNav {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(clickBackItem) icon:@"icon_back" highlighticon:@"icon_back_highlighted"];
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    
    //设置代理监听搜索框的变化
    searchBar.delegate = self;
    
    //设置占位内容
    searchBar.placeholder = @"请输入搜索的内容";
    self.navigationItem.titleView = searchBar;
    
    self.searchBar = searchBar;
    
}

- (void)clickBackItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - UISearchBarDelegate
//当搜索框内容发生变化后调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //判断搜索框是否有内容
    if (searchBar.text.length) {
        
        //执行下拉刷新,请求数据
        [self.collectionView.mj_header beginRefreshing];
    }
    
}

- (VVRequestType)addSetupCustemParam:(NSMutableDictionary *)baseParam {
    
    if (self.searchBar.text.length) {
        
        //设置自定义参数
        [baseParam setValue:self.searchBar.text forKey:@"keyword"];
        
        return VVRequestTypeNetwork;
        
    } else {
        
        return VVRequestTypeClearUI;
    }

}

#pragma mark <UICollectionViewDataSource>

//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
//    return 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell
//    
//    return cell;
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
