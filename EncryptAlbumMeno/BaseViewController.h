//
//  BaseViewController.h
//  TBaoApp
//
//  Created by ataw on 16/4/27.
//  Copyright © 2016年 杭州信使网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property(nonatomic,strong) UIView *navAndStateView;
@property(nonatomic,copy)NSString *navTitle;
@property(nonatomic,strong)UILabel *navTitleLable;
@property(nonatomic,strong)UIButton *leftSlideButton;
-(void)creatNavAndStateView;
-(void)creatLeftBtn;
@end
