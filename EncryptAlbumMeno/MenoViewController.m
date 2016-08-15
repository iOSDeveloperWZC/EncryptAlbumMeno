//
//  MenoViewController.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/15.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "MenoViewController.h"
#import "MenoModel.h"
@interface MenoViewController ()<UITextViewDelegate>

@end

@implementation MenoViewController
{
    UITextView *view;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitle = @"编辑备忘录";
    [self creatNavAndStateView];
    [self creatLeftBtn];
    [self creatRightBtn];
    
    view = [[UITextView alloc]init];
    view.delegate = self;
    view.font = [UIFont boldSystemFontOfSize:17];
    if (_mod != nil) {
        
        view.text = _mod.content;
    }
//    view.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(UIEdgeInsetsMake(74, 10, -10, -10));
    }];
    
}

-(void)creatRightBtn
{
    UIButton *rightButton;
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(GBWidth - 60, 20 + 7, 60, 30);
    if (_mod != nil) {
        
        [rightButton setTitle:@"更新" forState:UIControlStateNormal];
    }
    else
    {
    
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navAndStateView addSubview:rightButton];
}

//保存数据
-(void)submitButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    //新增
    if (_mod == nil) {
        
        MenoModel *model = [[MenoModel alloc]init];
        if (view.text.length > 50) {
            
            model.title = [view.text substringToIndex:50];;
        }
        else
        {
            model.title = view.text;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        model.time = [formatter stringFromDate:[NSDate date]];
        model.content = view.text;
        
        [DataBaseManager insertMenoValueByBindVar:@[model]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NSString *title = @"";
        if (view.text.length > 50) {
            
            title = [view.text substringToIndex:50];;
        }
        else
        {
            title = view.text;
        }

        if ([DataBaseManager updataMenoAccordingTime:_mod.time modifyContent:view.text andTitle:title]) {
            [XHToast showCenterWithText:@"更新成功"];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        else
        {
            [XHToast showCenterWithText:@"更新失败"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
