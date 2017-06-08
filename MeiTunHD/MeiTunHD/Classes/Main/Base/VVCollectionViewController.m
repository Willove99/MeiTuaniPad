//
//  VVCollectionViewController.m
//  MeiTunHD
//
//  Created by will on 2017/5/31.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVCollectionViewController.h"
#import "VVDealModel.h"
#import "VVDetailViewController.h"
#import "VVDealCell.h"
#import "VVDealModel.h"

@interface VVCollectionViewController ()<DPRequestDelegate,UICollectionViewDelegate>

//无数据时 背景图片
@property (nonatomic, strong) UIImageView *nodealImage;
@end

@implementation VVCollectionViewController


static NSString * const reuseIdentifier = @"dealCell";


- (instancetype)init {
    
    //设置布局
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    //设置cell尺寸
    layout.itemSize = CGSizeMake(VVDealCellWidth, VVDealCellWidth);
    
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        
        //设置背景色
        self.collectionView.backgroundColor = VVColor(288, 288, 288);
        
        
        //注册Cell 取出从xib中描述的cell
        [self.collectionView registerNib:[UINib nibWithNibName:@"VVDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //监听朝向的变化
    [VVNoteCenter addObserver:self selector:@selector(baseOrientationDidChangeNote) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //初始化刷新控件
    [self setupRefresh];
    
    //主动调用朝向发生变化
    [self baseOrientationDidChangeNote];

}



#pragma  mark - 刷新操作
- (void)setupRefresh {
    
    //一旦执行一个刷新操作,就应该禁用另一个刷新操作,直到正在执行的刷新操作返回结果
    
    //设置下拉刷新控件
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //下拉刷新
        [self loadNewData];
        
        //禁用上拉加载
        self.collectionView.mj_footer.hidden = YES;
    }];
    
    //设置上拉加载更多
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        //上拉加载
        [self loadMoreData];
        
        //隐藏下拉刷新
        self.collectionView.mj_header.hidden = YES;
    }];
    
    //默认隐藏上拉加载
    self.collectionView.mj_footer.hidden = YES;
    
    //解除循环引用
    __weak typeof(self) weakSelf = self;
    
    //设置下拉刷新完成处理
    [self.collectionView.mj_header setEndRefreshingCompletionBlock:^(){
        
        //下拉刷新完成,再显示上拉加载 根据是否有数据显示
        weakSelf.collectionView.mj_footer.hidden = (weakSelf.deals.count) ? NO : YES;
    }];
    
    //设置的上拉加载完成后显示下拉刷新
    [self.collectionView.mj_footer setEndRefreshingCompletionBlock:^() {
        
        //显示下拉加载
        weakSelf.collectionView.mj_header.hidden = NO;
    }];
    
}

//下拉刷新
- (void)loadNewData {
    
    self.currentPage = 1;
    
    //请求数据
    [self requestDataFromDPAPI];
}

//上拉加载更新
- (void)loadMoreData{
    
    self.currentPage++;
    //请求数据
    [self requestDataFromDPAPI];
}

//网络请求
- (void)requestDataFromDPAPI {
    
    //设置参数
    NSMutableDictionary *param  = [[NSMutableDictionary alloc]init];
    
    //设置城市 必须设置
    [param setValue:self.currentCityName forKey:@"city"];
    
    //设置页码
    [param setValue:@(self.currentPage) forKey:@"page"];
    
    //设置限定
    [param setValue:@7 forKey:@"limit"];
    
    if ([self respondsToSelector:@selector(addSetupCustemParam:)]) {
        
        //设置自定义参数
       VVRequestType requestType = [(id<VVRequestParam>)self addSetupCustemParam:param];
    
        switch (requestType) {
                
            case VVRequestTypeNetwork: {
                
                //请求团购数据
                [[DPAPI new] requestWithURL:@"v1/deal/find_deals" params:param delegate:self];
            }
                break;
               
            case VVRequestTypeClearUI: {
                
                //清空数据源
                self.deals = nil;
                
                //刷新界面
                [self.collectionView reloadData];
                
                //停止刷新
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                
            }
            default:
                break;
        }
    
    } else {
        
        //请求团购数据
        [[DPAPI new] requestWithURL:@"v1/deal/find_deals" params:param delegate:self];
    }
    
    

}

//获取数据成功
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    //判断上拉加载更多/下拉刷新 根据页码区分
    if (self.currentPage == 1) { //下拉刷新
        
        //清空数据源数组
        self.deals = nil;
    }
    
    NSArray *dicArr = result[@"deals"];
    
    //字典转模型
    //上拉加载更多 要求累加数据  使用可变数组来进行操作
    [self.deals addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VVDealModel class] json:dicArr]];
    
    //刷新界面
    [self.collectionView reloadData];
    
    //停止刷新
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    //根据是否有数据,显隐无数据图片  需要根据总数据进行判断,不要使用当前请求获取的数量
    self.nodealImage.hidden = (self.deals.count) ? YES : NO;
}


//获取数据失败
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    VVLog(@"获取数据失败%@", error);
    
    //上拉加载数据失败 让当前页码回滚
    self.currentPage--;
    
    //停止刷新控件
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

//朝向变化调用
- (void)baseOrientationDidChangeNote {
    
    //列数
    //iOS系统在横竖屏切换后,不会立即更新视图(window/view/screen)宽高属性
    //获取屏幕真实宽度的办法: 判断横竖屏,横屏取宽高较大值,竖屏宽高较小值
    NSInteger col = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? 2 : 3;
    //计算间距
    CGFloat margin = (VVRealScreenWidth - VVDealCellWidth * col) / (col + 1);
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    
    //设置组边距
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    //设置行间距
    layout.minimumLineSpacing = margin;
    
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VVDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.dealModel = self.deals[indexPath.row];
    
    return cell;
}

//代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VVDetailViewController * detailVC = [[VVDetailViewController alloc]init];
    
    //传递模型数据
    detailVC.dealModel = self.deals[indexPath.row];
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

#pragma  mark - 懒加载
- (NSMutableArray<VVDealModel *> *)deals{
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}

- (UIImageView *)nodealImage {
    
    if (_nodealImage == nil) {
        
        _nodealImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        
        [self.view addSubview:_nodealImage];
        
        //设置位置
        [_nodealImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.collectionView);
        }];
        
        //设置填充模式
        _nodealImage.contentMode = UIViewContentModeCenter;
    }
    
    return _nodealImage;
}

- (NSString *)currentCityName {
    
    if (_currentCityName == nil) {
        
        _currentCityName = @"北京";
        
    }
    
    return _currentCityName;
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
