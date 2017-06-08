//
//  VVHomeViewController.h
//  MeiTunHD
//
//  Created by will on 2017/5/16.
//  Copyright © 2017年 will wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVCityModel.h"
#import "VVCollectionViewController.h"

@interface VVHomeViewController : VVCollectionViewController

//城市集合缓存
@property(nonatomic,strong,readonly) NSArray <VVCityModel*> *cities;
@end
