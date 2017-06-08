//
//  VVDealCell.m
//  MeiTunHD
//
//  Created by will on 2017/5/24.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVDealCell.h"
#import "VVDateFormater.h"

@interface VVDealCell ()
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
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
//新单图标
@property (weak, nonatomic) IBOutlet UIImageView *dealNewImageView;
//遮罩视图
@property (weak, nonatomic) IBOutlet UIButton *maskView;
//打钩视图
@property (weak, nonatomic) IBOutlet UIImageView *chooseView;

@end

@implementation VVDealCell

#pragma  mark - 响应事件
- (IBAction)clickChoosesView:(id)sender {
    
    //所有对打钩的操作都关联模型中记录打钩情况的属性

    //取反记录打钩情况的属性
    self.dealModel.showChooseView = !self.dealModel.showChooseView;
    
    //根据打钩数据属性来设置打钩情况
    self.chooseView.hidden = self.dealModel.showChooseView ? NO : YES;

}

- (void)setDealModel:(VVDealModel *)dealModel {
    
    _dealModel = dealModel;
    
    //设置控件对应的数据
    self.titleLabel.text = _dealModel.title;
    self.descLabel.text = _dealModel.desc;
    
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_dealModel.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];

    //设置现价 获取到价格/数量等float类型的数据,使用float类型来接近,使用NSNumber进行转换,去掉小数点后多余的位数
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:_dealModel.current_price]];
    self.listPriceLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:_dealModel.list_price]];
    
    //设置已售数量
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d",_dealModel.purchase_count];

    //设置新单  自定义规则: 发布日期(NSString) >= 当前日期(NSDate),显示新单
    //创建日期格式化对象 创建/设置格式时性能消耗很大   使用时注意: 1> 不要频繁创建 2> 不要频繁修改格式
    VVDateFormater *dateFormater = [VVDateFormater sharedIntance];
    
    //NSDate 转场NSString
    NSString *nowString = [dateFormater stringFromDate:[NSDate date]];
    
    //根据日期比较显隐新单图片
    self.dealNewImageView.hidden = ([_dealModel.publish_date compare:nowString] != NSOrderedAscending) ? NO : YES;
    
    //根据属性设置遮罩视图显隐
    self.maskView.hidden = _dealModel.showMaskView ? NO : YES;

    //根据属性设置打钩视图的显隐
    self.chooseView.hidden = _dealModel.showChooseView ? NO : YES;

}


@end
