//
//  AwesomeMenu.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwesomeMenuItem.h"

@protocol AwesomeMenuDelegate;

@interface AwesomeMenu : UIView <AwesomeMenuItemDelegate>

@property (nonatomic, copy) NSArray *menuItems;
//菜单按钮
@property (nonatomic, strong) AwesomeMenuItem *startButton;
//set设置展开/get获取是否展开
@property (nonatomic, getter = isExpanded) BOOL expanded;
@property (nonatomic, weak) id<AwesomeMenuDelegate> delegate;
//菜单按钮背景图片
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
//菜单按钮内容图片
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *highlightedContentImage;
//弹出动画幅度
@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat farRadius;
//菜单按钮和弹出按钮的距离
@property (nonatomic, assign) CGFloat endRadius;
//菜单按钮位置
@property (nonatomic, assign) CGPoint startPoint;
//弹出动画时间间隔
@property (nonatomic, assign) CGFloat timeOffset;
//弹出按钮的旋转角度(菜单按钮为圆心)
@property (nonatomic, assign) CGFloat rotateAngle;
//弹出按钮的所在范围(菜单按钮为圆心)
@property (nonatomic, assign) CGFloat menuWholeAngle;
//展开时的旋转角度
@property (nonatomic, assign) CGFloat expandRotation;
//关闭时的旋转角度
@property (nonatomic, assign) CGFloat closeRotation;
//动画持续时间
@property (nonatomic, assign) CGFloat animationDuration;
//菜单按钮是否旋转
@property (nonatomic, assign) BOOL    rotateAddButton;

- (id)initWithFrame:(CGRect)frame startItem:(AwesomeMenuItem*)startItem menuItems:(NSArray *)menuItems;

- (id)initWithFrame:(CGRect)frame startItem:(AwesomeMenuItem*)startItem optionMenus:(NSArray *)aMenusArray DEPRECATED_MSG_ATTRIBUTE("use -initWithFrame:startItem:menuItems: instead.");

- (AwesomeMenuItem *)menuItemAtIndex:(NSUInteger)index;

- (void)open;

- (void)close;

@end

@protocol AwesomeMenuDelegate <NSObject>
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx;
@optional
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu;
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu;
- (void)awesomeMenuwillAnimateOpen:(AwesomeMenu *)menu;
- (void)awesomeMenuwillAnimateClose:(AwesomeMenu *)menu;
@end
