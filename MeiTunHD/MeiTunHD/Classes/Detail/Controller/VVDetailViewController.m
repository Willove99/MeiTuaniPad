//
//  VVDetailViewController.m
//  MeiTunHD
//
//  Created by will on 2017/5/27.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVDetailViewController.h"
#import "VVDateFormater.h"

@interface VVDetailViewController ()<DPRequestDelegate,UIWebViewDelegate>


//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//描述
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//当前价格
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
//原价
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
//已售数
@property (weak, nonatomic) IBOutlet UIButton *purchaseCountBtn;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
//团购截止时间
@property (weak, nonatomic) IBOutlet UIButton *deadlineBtn;
//随时退按钮
@property (weak, nonatomic) IBOutlet UIButton *refunableBtn;
//过期退按钮
@property (weak, nonatomic) IBOutlet UIButton *outDateBtn;
//网页
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//加载指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;



@end

@implementation VVDetailViewController

//设置当前界面的朝向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置UI
    [self setupUI];
    
    //请求数据
    [self requestDataFromDPAPI];
    
    //设置网页
    [self setupWebView];

}

- (void)setupWebView {
    
    //截取deal_id
    NSRange rang = [_dealModel.deal_id rangeOfString:@"-"];
    
    NSString *paramStr = [_dealModel.deal_id substringFromIndex:rang.location + 1];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", paramStr]]];
    
    [self.webView loadRequest:request];
    
    //设置停止时隐藏loading视图
    self.loadingView.hidesWhenStopped = YES;
    
    //停止弹簧
    self.webView.scrollView.bounces = NO;
    
    //显示加载动画
    [self.loadingView startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //封装js语句
    NSMutableString *jsStr = [NSMutableString string];
    
    //当前网页加载完成后,再利用webview实现OC调用JS语句,通过html的dom对象管理html标签(增删改查)
    //获取header标签
    [jsStr appendString:@"var header = document.getElementsByTagName('header')[0];"];
    
    //删除header标签
    [jsStr appendString:@"header.parentNode.removeChild(header);"];
    
    [jsStr appendString:@"var costbox = document.getElementsByClassName('cost-box')[0];costbox.parentNode.removeChild(costbox);"];
    
//    [jsStr appendString:@"costbox.parentNode.removeChild(costbox);"];
    
    //获取buy-now标签
    [jsStr appendString:@"var buynow =document.getElementsByClassName('buy-now')[0];"];
    //删除buy-now标签
    [jsStr appendString:@"buynow.parentNode.removeChild(buynow);"];
    
    //获取footer标签
    [jsStr appendString:@"var footer =document.getElementsByClassName('footer')[0];"];
    //删除footer标签
    [jsStr appendString:@"footer.parentNode.removeChild(footer);"];


    //oc调用js
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    //停止loading动画
    [self.loadingView stopAnimating];
}

- (void)setupUI {
    
    //设置控件数据
    self.titleLabel.text = _dealModel.title;
    self.descLabel.text = _dealModel.desc;
    
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_dealModel.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    //设置现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:_dealModel.current_price]];
    
    self.listPriceLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:_dealModel.list_price]];

    [self.purchaseCountBtn setTitle:[NSString stringWithFormat:@"已售: %d", _dealModel.purchase_count] forState:UIControlStateNormal];

    //获取截至时间
    NSDate *deadlineDate = [[VVDateFormater sharedIntance] dateFromString:_dealModel.purchase_deadline];

    //服务端返回的数据不包含时分秒, 计算截至日期时会少算一天,应该截至时间加1天进行计算
    deadlineDate = [deadlineDate dateByAddingTimeInterval:60*60*24];
    
    //创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //获取时间差组件(天&小时&分钟)  截至日期和当前时间的差值  需求的组件必须设置,否则就无法获取
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date] toDate:deadlineDate options:0];
    
    //判断是否超过一年
    if (components.day > 365) {
        
        [self.deadlineBtn setTitle:@"超过一年" forState:UIControlStateNormal];
        
    }else {
        
        [self.deadlineBtn setTitle:[NSString stringWithFormat:@"%zd天%zd小时%zd分钟", components.day, components.hour, components.minute] forState:UIControlStateNormal];
    }

    //设置收藏按钮状态
    self.collectBtn.selected = [VVDataBase hasDeal:self.dealModel] ? YES : NO;
}

- (void)requestDataFromDPAPI {
    
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //设置dealID 必须设置
    [param setValue:self.dealModel.deal_id forKey:@"deal_id"];
    
    //请求团购数据
    [[DPAPI new] requestWithURL:@"v1/deal/get_single_deal" params:param delegate:self];
}


//获取数据成功
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    NSArray *deals = result[@"deals"];
    
    if (deals.count) {
        
        self.refunableBtn.selected = ([result[@"deals"][0][@"restrictions"][@"is_refundable"] boolValue]) ? YES : NO;
        self.outDateBtn.selected = self.refunableBtn.selected;

    }
    
    
}


//获取数据失败
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    VVLog(@"获取数据失败%@", error);
}

#pragma mark - 响应事件


- (IBAction)clickCollectBtn:(UIButton *)sender {

    if (sender.selected) {//删除收藏
        
        [VVDataBase deleteDealWithDealModel:self.dealModel];
        
    } else {//添加收藏
        
        [VVDataBase insertDealWithDealModel:self.dealModel];
    }

    //状态取反
    sender.selected = !sender.selected;
}

- (IBAction)clickBackButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
