//
//  VVCollectViewController.m
//  MeiTunHD
//
//  Created by 王惠平 on 2017/6/2.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVCollectViewController.h"

@interface VVCollectViewController ()

//完成回调
@property (nonatomic, copy) void(^completedBlock)();

//全选
@property (nonatomic, strong) UIBarButtonItem *allSelectItem;
//全不选
@property (nonatomic, strong) UIBarButtonItem *allNotSelectItem;
//删除
@property (nonatomic, strong) UIBarButtonItem *deleteItem;

//返回
@property (nonatomic, strong) UIBarButtonItem *backItem;

//打钩数
@property (nonatomic, assign) NSInteger chooseCount;

@end

@implementation VVCollectViewController

- (instancetype)initWithCompletedBlock:(void (^)())block
{
    self = [super init];
    if (self) {
        //记录block
        self.completedBlock = block;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
}

//执行刷新
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //执行默认的刷新
    [self.collectionView.mj_header beginRefreshing];

}
- (void)setupNav {
    
    self.title = @"收藏";
    
    //返回Item
    self.backItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(clickBackItem) icon:@"icon_back" highlighticon:@"icon_back_highlighted"];
    
    //编辑
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickEditItem:)];
    
    //全选&全不选&删除
    self.allSelectItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(clickAllSelectItem)];
    
    self.allNotSelectItem = [[UIBarButtonItem alloc] initWithTitle:@"全不选" style:UIBarButtonItemStylePlain target:self action:@selector(clickAllNotSelectItem)];
    
    self.deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(clickDeleteItem)];
    
    //默认禁用删除
    self.deleteItem.enabled = NO;
    
    //默认返回按钮
    self.navigationItem.leftBarButtonItem = self.backItem;
    
}

//点击全选
- (void)clickAllSelectItem{
    
    //遍历模型属性
    for (VVDealModel *dealModel in self.deals) {
        
        //将模型中没有打钩的属性全部取反
        if (dealModel.showChooseView == NO) {
            
            dealModel.showChooseView = YES;
        }
    }
    //刷新数据
    [self.collectionView reloadData];
}

//点击全不选
- (void)clickAllNotSelectItem{
    
    //遍历模型
    for (VVDealModel *dealModel in self.deals) {
        
        //将模型中打钩的模型属性设置为NO
        if (dealModel.showChooseView) {
            
            dealModel.showChooseView = NO;
        }
    }
    //刷新数据
    [self.collectionView reloadData];

}

//点击删除
- (void)clickDeleteItem{
    
    //从内存中删除模型
    NSMutableArray *temp = [NSMutableArray array];
    for (VVDealModel *dealModel in self.deals) { //使用for..in时不能够增/删/改其中的元素
        
        if (dealModel.showChooseView) { //需要删除的模型
            
            [temp addObject:dealModel];
           
            //将模型属性设置为NO
            dealModel.showChooseView = NO;
            
            //移除观察者
            [dealModel removeObserver:self forKeyPath:@"showChooseView"];
            
            //从数据库中删除模型
            [VVDataBase deleteDealWithDealModel:dealModel];
        }
    }
    
    //通过谓词获取要删除的数据
    //    NSArray *temp = [self.deals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"showChooseView = YES"]];
    
    [self.deals removeObjectsInArray:temp];
    
    [self.collectionView reloadData];

    
}

//点击编辑
- (void)clickEditItem:(UIBarButtonItem*)item {
    
    //区分状态
    if ([item.title isEqualToString:@"编辑"]) {//进入编辑状态
        
        self.navigationItem.leftBarButtonItems = @[self.backItem,self.allSelectItem,self.allNotSelectItem,self.deleteItem];
        
        //设置标题
        item.title = @"完成";
        
        //设置所有模型中showMaskView属性都为yes
//        [self.deals setValue:@YES forKey:@"showMaskView"];
        
        //监听模型的数据
        for (VVDealModel *dealModel in self.deals) {
            
            dealModel.showMaskView = YES;
            
            [dealModel addObserver:self forKeyPath:@"showChooseView" options:NSKeyValueObservingOptionNew context:NULL];
        }
        
        //禁用刷新控件
        self.collectionView.mj_header.hidden = YES;
        self.collectionView.mj_footer.hidden = YES;
        
    } else {//退出编辑状态
        
        self.navigationItem.leftBarButtonItems = @[self.backItem];
     
        //设置标题
        item.title = @"编辑";
        
        //设置所有模型中showMaskView属性都为NO
//        [self.deals setValue:@NO forKey:@"showMaskView"];
        
        //将所有打钩的模型属性取反
        for (VVDealModel *dealModel in self.deals) {
            
            if (dealModel.showChooseView) {
                
                dealModel.showChooseView = NO;
            }
            //将模型属性设置为NO
            dealModel.showMaskView = NO;
            
            //移除kvo
            [dealModel removeObserver:self forKeyPath:@"showChooseView"];
        
        }

        //禁用刷新控件
        self.collectionView.mj_header.hidden = NO;
        self.collectionView.mj_footer.hidden = NO;

    }
    
    //刷新界面
    [self.collectionView reloadData];
}

- (void)clickBackItem {
    
    //调用block,传递时间给homeVC
    if (self.completedBlock) {
        
        self.completedBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 当监听的属性发生变化后调用
 
 @param keyPath 监听的属性
 @param object 监听的对象
 @param change 发生的变化
 @param context 传递的参数
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    BOOL showChooseView = [change[NSKeyValueChangeNewKey] boolValue];
    
    VVLog(@"%d", showChooseView);
    
    //根据打钩情况,记录打钩数
    if (showChooseView == YES) {
        
        self.chooseCount++;
        
        //只要有一个打钩,则可用
        self.deleteItem.enabled = YES;
        
    }else {
        
        self.chooseCount--;
        
        //所有的模型都不打钩,则禁用
        if (self.chooseCount == 0) {
            
            self.deleteItem.enabled = NO;
        }
    }

}

- (void)requestDataFromDPAPI {
    
    NSError *error;
    
    NSArray *newDeals = [VVDataBase queryCollectsWith:self.currentPage error:&error];
    
    if (error == nil) {//本地数据查询
        
        //判断上拉加载更多/下拉刷新 根据页码区分
        if (self.currentPage == 1) { //下拉刷新
            
            //清空数据源数组
            self.deals = nil;
        }
        
        //上拉加载更多 要求累加数据  使用可变数组来进行操作
        [self.deals addObjectsFromArray:newDeals];
        
        //刷新界面
        [self.collectionView reloadData];
        
    
    } else {//数据查询失败
        
        //上拉加载数据失败 让当前页码回滚
        self.currentPage--;

    }
    
    //停止刷新控件
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
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
