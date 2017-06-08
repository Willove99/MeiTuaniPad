//
//  VVHomeView.m
//  MeiTunHD
//
//  Created by will on 2017/5/18.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import "VVHomeView.h"

@interface VVHomeView ()

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation VVHomeView


+ (instancetype) homeNavView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"VVHomeView" owner:nil options:nil].lastObject;
}

- (IBAction)clickImgBtn:(UIButton *)sender {
    
    //生成点击事件
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    self.titleLabel.text = _title;
}

- (void)setSubtitle:(NSString *)subtitle {
    
    _subtitle = subtitle;
    
    self.subtitleLabel.text = _subtitle;
}

- (void)setIconImgName:(NSString *)iconImgName {
    
    _iconImgName = iconImgName;
    
    [self.imgBtn setImage:[UIImage imageNamed:_iconImgName] forState:UIControlStateNormal];
    
}

- (void)setIconHighligtedImgName:(NSString *)iconHighligtedImgName {
    
    _iconHighligtedImgName = iconHighligtedImgName;
    [self.imgBtn setImage:[UIImage imageNamed:_iconHighligtedImgName] forState:UIControlStateHighlighted];
}
@end
