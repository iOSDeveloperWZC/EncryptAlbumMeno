//
//  BaseViewController.m
//  TBaoApp
//
//  Created by ataw on 16/4/27.
//  Copyright © 2016年 杭州信使网络科技. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    
}
@end


@implementation BaseViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
  
}


-(UIViewController *)findRootViewController
{
    UIViewController *vc = self.presentingViewController;
    do {
        
        if ([vc isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)vc;
        }
        vc = vc.presentingViewController;
        
    } while (vc != nil);

    return nil;
}


//1、创建导航栏 、状态栏
-(void)creatNavAndStateView
{
    //
    _navAndStateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GBWidth, 64)];
    [self.view addSubview:_navAndStateView];
    _navAndStateView.backgroundColor = RGB(0,134.0,207.0);
    _navTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, GBWidth, 44)];
    _navTitleLable.backgroundColor = [UIColor clearColor];
    _navTitleLable.font = [UIFont systemFontOfSize:18];
    _navTitleLable.text = _navTitle;
    _navTitleLable.textColor = [UIColor whiteColor];
    _navTitleLable.textAlignment = NSTextAlignmentCenter;
    [_navAndStateView addSubview:_navTitleLable];
}

-(void)creatLeftBtn
{
    _leftSlideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftSlideButton.frame = CGRectMake(0, 20, 44, 44);
    [_leftSlideButton setImage:[UIImage imageNamed:@"icon_返回@2x.png"]  forState:UIControlStateNormal];
    _leftSlideButton.backgroundColor = [UIColor clearColor];
    [_navAndStateView addSubview:_leftSlideButton];
    [_leftSlideButton addTarget:self action:@selector(leftSlideAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)leftSlideAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
