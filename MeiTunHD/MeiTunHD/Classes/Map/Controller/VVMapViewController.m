//
//  VVMapViewController.m
//  MeiTunHD
//
//  Created by 王惠平 on 2017/6/3.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVMapViewController.h"
#import <MapKit/MapKit.h>
#import "VVBusinessModel.h"
#import "VVCategoryTool.h"
#import "VVHomeView.h"
#import "VVCategoryModel.h"
#import "VVCategroyController.h"

static NSString *identifier = @"anno";

@interface VVMapViewController ()<DPRequestDelegate,MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *mgr;

//纬度
@property (nonatomic, assign) CGFloat latitude;
//经度
@property (nonatomic, assign) CGFloat longitude;

@property(nonatomic,strong)MKMapView *mapView;

//当前分类
@property(nonatomic,copy)NSString *currentCategory;
@end

@implementation VVMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置地图显示
    [self setupMapView];
    
    //设置Nav
    [self setupNav];
    
    //监听分类变化通知
    [VVNoteCenter addObserver:self selector:@selector(categoryDidChangeNote:) name:VVCategoryDidChangeNote object:nil];

}

- (void)setupMapView {
    
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:mapView];
    
    self.mgr = [[CLLocationManager alloc]init];
    
    //请求授权
    [self.mgr requestWhenInUseAuthorization];
    
    //创建用户跟踪模式
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //设置代理监听mapView的移动
    mapView.delegate = self;
    
    self.mapView = mapView;

}

- (void)setupNav {
    
    self.title = @"地图";
    
    //返回Item
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(clickBackItem) icon:@"icon_back" highlighticon:@"icon_back_highlighted"];
    
    UIBarButtonItem *backItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(clickBackItem) icon:@"icon_back" highlighticon:@"icon_back_highlighted"];
    
    VVHomeView *categoryView = [VVHomeView homeNavView];
    //设置数据  利用拉伸优先级设置子标题为空时,让标题占满自定义视图的高度
    categoryView.title = @"全部分类";
    categoryView.subtitle = nil;
    categoryView.iconImgName = @"icon_category_-1";
    categoryView.iconHighligtedImgName = @"icon_category_highlighted_-1";
    
    //监听action事件
    [categoryView addTarget:self action:@selector(clickCategoryItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryView];
    
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];

}

- (void)clickCategoryItem{
    
    //创建控制器
    VVCategroyController *categoryVc = [VVCategroyController new];
    
    //设置modal展示样式
    categoryVc.modalPresentationStyle = UIModalPresentationPopover;
    
    //设置来源视图/barButtonItem
    categoryVc.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItems[1];
    //设置Popover的尺寸
    categoryVc.preferredContentSize = CGSizeMake(categoryVc.popoverView.width, categoryVc.popoverView.height);
    //进行modal展示
    [self presentViewController:categoryVc animated:YES completion:nil];
}

#pragma mark - 通知

//分类改变后调用
- (void)categoryDidChangeNote:(NSNotification *)note{
    
    //获取参数
    VVCategoryModel *category = note.userInfo[VVCategoryDidChangeNoteModelKey];
    NSString *subCategory = note.userInfo[VVCategoryDidChangeNoteSubtitleKey];
    //设置导航栏Item
    UIBarButtonItem *item = self.navigationItem.leftBarButtonItems[1];
    VVHomeView *categoryView = item.customView;
    categoryView.title = category.name;
    categoryView.subtitle = [subCategory isEqualToString:@"全部"] ? nil : subCategory;
    
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
    
    //删除地图上所有的大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //请求数据
    [self requestDataFromDPAPI];
}

- (void)clickBackItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//区域发生变化后调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //记录地图中心点的经纬度
    self.latitude = mapView.region.center.latitude;
    self.longitude = mapView.region.center.longitude;
    
    //调用网络请求
    [self requestDataFromDPAPI];
}

#pragma mark - 网络请求

- (void)requestDataFromDPAPI{
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //设置经纬度
    [param setValue:@(self.latitude) forKey:@"latitude"];
    [param setValue:@(self.longitude) forKey:@"longitude"];
    //设置限定
    [param setValue:@5 forKey:@"limit"];
    
    //设置分类
    if (self.currentCategory != nil) {
        
        [param setValue:self.currentCategory forKey:@"category"];
    }

    //请求团购数据
    [[DPAPI new] requestWithURL:@"v1/business/find_businesses" params:param delegate:self];
    
}

//自定义位置视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        return nil;
    }
    
    MKAnnotationView *annoV = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annoV == nil) {
        
        annoV = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    //类型转换
    VVBusinessModel *business = annotation;
    
    //设置数据  图片需要根据商户的分类到category.plist中查询对应的图片名
    annoV.image = [UIImage imageNamed:[VVCategoryTool categoryImgNameWithCategoryName:business.categories.firstObject]];
    
    annoV.canShowCallout = YES;
    
    return annoV;
}

//获取数据成功
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    
    NSArray *dictArr = result[@"businesses"];
    //字典转模型
//    VVLog(@"查询到%zd个商户", dictArr.count);
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSDictionary *dic in dictArr) {
        
        for (VVBusinessModel *bussines in self.mapView.annotations) {
            
            //过滤大头针
            if ([bussines isKindOfClass:[MKUserLocation class]]) {
                
                continue;
            }
            
            if ([dic[@"name"] isEqualToString:bussines.name]) {
                
                //已经存在
                [temp addObject:dic];
                
                break;
                
            }
        }
       
    }
    
    NSMutableArray *newBussinesses = dictArr.mutableCopy;
    
    [newBussinesses removeObjectsInArray:temp];
    
    VVLog(@"获取的数据%zd, 去重后的数据%zd", dictArr.count, newBussinesses.count);

    NSArray *businesses = [NSArray yy_modelArrayWithClass:[VVBusinessModel class] json:newBussinesses];
    
    //遍历模型数据
    for (VVBusinessModel *business in businesses) {
        
        //添加大头针模型
        [self.mapView addAnnotation:business];
    }
    
}


//获取数据失败
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    VVLog(@"获取数据失败%@", error);
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
