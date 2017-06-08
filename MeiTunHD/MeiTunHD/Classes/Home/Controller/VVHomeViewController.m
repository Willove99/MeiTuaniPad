//
//  VVHomeViewController.m
//  MeiTunHD
//
//  Created by will on 2017/5/16.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVHomeViewController.h"
#import "VVHomeView.h"
#import "VVCategroyController.h"
#import "VVDistrictViewController.h"
#import "VVCategoryModel.h"
#import "VVSortViewController.h"
#import "VVSortModel.h"

#import "AwesomeMenu.h"

#import "VVSearchViewController.h"
#import "VVNavigationController.h"

#import "VVCollectViewController.h"
#import "VVMapViewController.h"


@interface VVHomeViewController ()<AwesomeMenuDelegate,VVRequestParam>

//当前分类
@property (nonatomic, copy) NSString *currentCategory;
//当前区域
@property (nonatomic, copy) NSString *currentDistrict;
//当前排序
@property (nonatomic, strong) NSNumber *currentSort;

//Path菜单
@property (nonatomic, strong) AwesomeMenu *pathMenu;

@end

@implementation VVHomeViewController

@synthesize cities = _cities;

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏
    [self setupNav];
    
    //监听通知
    [VVNoteCenter addObserver:self selector:@selector(cityDidChangeNote:) name:VVCityDidChangeNote object:nil];
    
    [VVNoteCenter addObserver:self selector:@selector(districtsDidChangeNote:) name:VVDistrictDidChangeNote object:nil];
    
    [VVNoteCenter addObserver:self selector:@selector(categoryDidChangeNote:) name:VVCategoryDidChangeNote object:nil];
    
    [VVNoteCenter addObserver:self selector:@selector(sortDidChangeNote:) name:VVSortDidChangeNote object:nil];
    
    
    //监听朝向的变化
    [VVNoteCenter addObserver:self selector:@selector(orientationDidChangeNote) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //设置path菜单
    [self setupAwesomeMenu];
    
    //设置默认刷新
    [self.collectionView.mj_header beginRefreshing];
    
    [VVDataBase new];
}

- (VVRequestType)addSetupCustemParam:(NSMutableDictionary *)baseParam {
    
    
    //设置分类
    if (self.currentCategory != nil) { //设置了分类
        
        [baseParam setValue:self.currentCategory forKey:@"category"];
    }
    
    //设置区域
    if (self.currentDistrict != nil) {
        
        [baseParam setValue:self.currentDistrict forKey:@"region"];
    }

    //设置排序
    [baseParam setValue:self.currentSort forKey:@"sort"];
    
    return VVRequestTypeNetwork;
}

#pragma mark - AwesomeMenu

//设置path菜单
- (void)setupAwesomeMenu{
    
    //创建开始Item
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    //2. 添加其他几个按钮
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];

    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    NSArray *items = @[item0, item1, item2, item3];
    
    //创建菜单
    self.pathMenu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    
    //设置菜单按钮展示范围
    self.pathMenu.menuWholeAngle = M_PI_2;
    //设置代理 监听事件
    self.pathMenu.delegate = self;
    //设置透明度
    self.pathMenu.alpha = 0.5;

    //取消开始Item的旋转
    self.pathMenu.rotateAddButton = NO;
    
    [self.view addSubview:self.pathMenu];
}

//点击菜单Item后调用
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    
    switch (idx) {
        case 0:
            VVLog(@"个人信息");
            break;
        case 1:
        {
            VVCollectViewController *collectVC = [[VVCollectViewController alloc]initWithCompletedBlock:^{
                
                menu.startButton.contentImageView.image = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
                menu.startButton.contentImageView.highlightedImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
                
                //动画改变透明度
                menu.alpha = 0.5f;
            }];
            
            [self presentViewController:[[VVNavigationController alloc]initWithRootViewController:collectVC] animated:YES completion:nil];
            
        }
            break;
        case 2:
            VVLog(@"历史记录");
            break;
        case 3:
            VVLog(@"设置");
            break;
            
        default:
            break;
    }
}

//将要动画打开菜单时调用
- (void)awesomeMenuwillAnimateOpen:(AwesomeMenu *)menu{
    
    menu.startButton.contentImageView.image = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.startButton.contentImageView.highlightedImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    
    //动画改变透明度
    [UIView animateWithDuration:0.25 animations:^{
        menu.alpha = 1.f;
    }];
}

//将要动画关闭菜单时调用
- (void)awesomeMenuwillAnimateClose:(AwesomeMenu *)menu{
    
    menu.startButton.contentImageView.image = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.startButton.contentImageView.highlightedImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    
    //动画改变透明度
    [UIView animateWithDuration:0.25 animations:^{
        menu.alpha = 0.5f;
    }];
}

//朝向变化调用
- (void)orientationDidChangeNote {
    
    //设置开始Item的位置  menu参考视图的高度不是屏幕的高度,内部实现减去了64点(状态栏+导航栏高度)
    CGFloat menuViewHeight = VVRealScreenHeight - 64;
    
    self.pathMenu.startPoint = CGPointMake(VVAwesomeMenuMargin, menuViewHeight - VVAwesomeMenuMargin);

}

//排序通知
- (void)sortDidChangeNote:(NSNotification *)note {
    
    //获取参数
    VVSortModel *sort = note.userInfo[VVSortDidChangeNoteModelKey];
    
    //设置导航栏item
    UIBarButtonItem *item = self.navigationItem.leftBarButtonItems[3]
    ;
    
    VVHomeView *sortView = item.customView;
    
    sortView.subtitle = sort.label;
    
    //记录当前的排序
    self.currentSort = sort.value;
    
    //发送请求
//    [self requestDataFromDPAPI];
    
    //执行下拉刷新,请求数据
    [self.collectionView.mj_header beginRefreshing];

    
}

//分类改变通知
- (void)categoryDidChangeNote:(NSNotification *)note {
    
    //获取参数
    NSString *subCategory = note.userInfo[VVCategoryDidChangeNoteSubtitleKey];
    VVCategoryModel *category = note.userInfo[VVCategoryDidChangeNoteModelKey];
    
    //设置导航栏Item
    UIBarButtonItem *item = self.navigationItem.leftBarButtonItems[1];
    
    VVHomeView *categoryView = item.customView;
    
    categoryView.title = category.name;
    
    categoryView.subtitle = [subCategory isEqualToString:@"全部" ] ? nil : subCategory;
    
    /**
     *  category参数设置规则: 如果有二级分类,则设置为二级分类;如果没有二级分类,则设置一级分类;没有没有一级分类,则不需要设置分类参数
     
     1> 点击"全部分类:   不传参数 category = nil
     2> 点击一级菜单通知:  传递一级名称
     3> 点击二级-"全部"通知: 传递一级名称
     4> 点击二级菜单通知:  传递二级名称
     
     */
    
    //记录当前的分类
    if ([category.name isEqualToString:@"全部分类"]) { //情况1
        
        self.currentCategory = nil;
        
    } else if ((subCategory == nil) || ([subCategory isEqualToString:@"全部"])) { //情况2 & 情况3
        
        self.currentCategory = category.name;
        
    }else {
        
        self.currentCategory = subCategory;
    }
    
    //进行请求
//    [self requestDataFromDPAPI];
    
    //执行下拉刷新,请求数据
    [self.collectionView.mj_header beginRefreshing];


}

//区域改变后调用
- (void)districtsDidChangeNote:(NSNotification *)note {
    
    //获取参数
    NSString *districName = note.userInfo[VVDistrictDidChangeNoteSubtitleKey];
    VVDistrictModel *distric = note.userInfo[VVDistrictDidChangeNoteModelKey];
    
    //设置导航栏Item
    UIBarButtonItem *item = self.navigationItem.leftBarButtonItems[2];
    
    VVHomeView *districView = item.customView;
    
    districView.title = [NSString stringWithFormat:@"%@-%@",self.currentCityName,distric.name];
    
    districView.subtitle = [districName isEqualToString:@"全部"] ? nil : districName;

    /**
     *  category参数设置规则: 如果有二级分类,则设置为二级分类;如果没有二级分类,则设置一级分类;没有没有一级分类,则不需要设置分类参数
     
     1> 点击"全部分类:   不传参数 category = nil
     2> 点击一级菜单通知:  传递一级名称
     3> 点击二级-"全部"通知: 传递一级名称
     4> 点击二级菜单通知:  传递二级名称
     
     */
    
    //记录当前的分类
    if ([distric.name isEqualToString:@"全部"]) { //情况1
        
        self.currentDistrict = nil;
        
    } else if ((districName == nil) || ([districName isEqualToString:@"全部"])) { //情况2 & 情况3
        
        self.currentDistrict = distric.name;
        
    }else {
        
        self.currentDistrict = districName;
    }
    
    //进行请求
//    [self requestDataFromDPAPI];
    
    //执行下拉刷新,请求数据
    [self.collectionView.mj_header beginRefreshing];

}

//城市改变后调用
- (void)cityDidChangeNote:(NSNotification *)note {
    
    //获取参数
    NSString *cityName = note.userInfo[VVCityDidChangeNoteCityName];
    
    //设置导航栏item
    UIBarButtonItem *item = self.navigationItem.leftBarButtonItems[2]
    ;
    
    VVHomeView *districtView = item.customView;
    
    districtView.title = [NSString stringWithFormat:@"%@-全部",cityName];
    
    //记录当前城市
    self.currentCityName = cityName;
    
    //清空子标题
    districtView.subtitle = nil;
    
    //清空之前记录的区域
    self.currentDistrict = nil;
    
    //进行请求
//    [self requestDataFromDPAPI];
    
    //执行下拉刷新,请求数据
    [self.collectionView.mj_header beginRefreshing];

}

- (void)setupNav {
    
    //设置右侧Item item本身不能设置高亮图片,需要包装btn
    UIBarButtonItem *mapItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(clickMapItem) icon:@"icon_map" highlighticon:@"icon_map_highlighted"];
    
    UIBarButtonItem *searchItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(clickSearchItem) icon:@"icon_search" highlighticon:@"icon_search_highlighted"];
    
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
    
    //设置右侧item
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    //禁用item
    logoItem.enabled = NO;
    
    VVHomeView *categoryView = [VVHomeView homeNavView];
    
    //设置数据 利用拉伸优先级设置子标题为空时 让标题占满视图高度
    categoryView.title = @"全部分类";
    categoryView.subtitle = nil;
    categoryView.iconImgName = @"icon_category_-1";
    categoryView.iconHighligtedImgName = @"icon_category_highlighted_-1";
    
    //点击事件
    [categoryView addTarget:self action:@selector(clickCategoryItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:categoryView];
    
    VVHomeView *districView = [VVHomeView homeNavView];
    
    districView.title = @"北京 - 全部";
    districView.subtitle = nil;
    districView.iconImgName = @"icon_district";
    districView.iconHighligtedImgName = @"icon_district_highlighted";
    
    //点击事件
    [districView addTarget:self action:@selector(clickDistricItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *districItem = [[UIBarButtonItem alloc]initWithCustomView:districView];
    
    VVHomeView *sortView = [VVHomeView homeNavView];
    
    sortView.title = @"排序";
    sortView.subtitle = @"默认排序";
    sortView.iconImgName = @"icon_sort";
    sortView.iconHighligtedImgName = @"icon_sort_highlighted";
    
    //点击事件
    [sortView addTarget:self action:@selector(clickSortItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc]initWithCustomView:sortView];
    
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,districItem,sortItem];
}

- (void)clickMapItem{
    
    VVMapViewController *mapVC = [[VVMapViewController alloc]init];
    
    [self presentViewController:[[VVNavigationController alloc]initWithRootViewController:mapVC] animated:YES completion:nil];
    
}

- (void)clickSearchItem{
    
    VVSearchViewController *searchVC = [[VVSearchViewController alloc]init];
    
    [self presentViewController:[[VVNavigationController alloc]initWithRootViewController:searchVC] animated:YES completion:nil];
    
}

- (void)clickCategoryItem {
    
    //创建控制器
    VVCategroyController *categroyVC = [VVCategroyController new];
    
    //设置modal样式
    categroyVC.modalPresentationStyle = UIModalPresentationPopover;
    
    //设置来源视图/barButtonItem
    categroyVC.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItems[1];
    
    //设置popover的尺寸
    categroyVC.preferredContentSize = CGSizeMake(categroyVC.popoverView.width, categroyVC.popoverView.height);
    
    //进行modal展示
    [self presentViewController:categroyVC animated:YES completion:nil];
    
}

- (void)clickDistricItem {
    
    //创建控制器
    VVDistrictViewController *districtVC = [VVDistrictViewController new];
    
    //设置modal样式
    districtVC.modalPresentationStyle = UIModalPresentationPopover;
    
    //设置来源视图
    districtVC.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItems[2];
    
    //设置popover的尺寸
    districtVC.preferredContentSize = CGSizeMake(districtVC.popoverView.width, CGRectGetMaxY(districtVC.popoverView.frame));
    
    //遍历获取城市
    for (VVCityModel *city in self.cities) {
        
        if ([city.name isEqualToString:self.currentCityName]) {
            
            //传递当前城市的一级区域数据
            districtVC.distrcits = city.districts;
        }
    }
    
    //进行modal展示
    [self presentViewController:districtVC animated:YES completion:nil];

}

- (void)clickSortItem {
    
    VVSortViewController *sortVC = [[VVSortViewController alloc]init];
    
    //设置modal展示演示
    sortVC.modalPresentationStyle = UIModalPresentationPopover;
    
    //设置来源视图
    sortVC.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItems[3];
    
    //进行modal展示
    [self presentViewController:sortVC animated:YES completion:nil];
    
}

- (NSNumber *)currentSort {
    
    if (_currentSort == nil) {
        
        _currentSort = @1;
    }
    
    return _currentSort;
}

- (NSArray<VVCityModel *> *)cities {
    
    if (_cities == nil) {
        
        //获取城市列表
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
        
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        
        //z字典转模型
        _cities = [NSArray yy_modelArrayWithClass:[VVCityModel class] json:dicArray];
        
    }
    
    return  _cities;
}

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
