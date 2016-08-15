//
//  AlertSettingPasswordViewController.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/4.
//  Copyright © 2016年 王宗成. All rights reserved.
//
#import <Security/Security.h>
#import "AlertSettingPasswordViewController.h"
#import "KeychainItemWrapper.h"
#import "SelectViewController.h"
#import "GBCustomCameraController.h"
#import "GBPhotoController.h"
#import "ModifyPasswordViewController.h"
#import "ForgetPassViewController.h"
@interface AlertSettingPasswordViewController ()<UITextFieldDelegate>
{
    KeychainItemWrapper *keychainItemWrapper;
    UIView *selectView;
    UIAlertController *alertVc;
    UITextField *password;
}
@end

@implementation AlertSettingPasswordViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    keychainItemWrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"secret" accessGroup:nil];
    [self creatSubView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeAction) name:WZCEnterGorground object:nil];
    
}

-(void)creatSubView
{
   
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"Image"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self.view);
    }];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    cameraBtn.layer.cornerRadius = 10;
    cameraBtn.backgroundColor = [UIColor whiteColor];
    [cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"进入相册/备忘录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(150, 45));
//        make.centerX.mas_equalTo(self.view.centerX);
        make.left.mas_equalTo(self.view.centerX).mas_offset(10);
        make.bottom.mas_equalTo(self.view.bottom).mas_offset(-130);
    }];
    
    
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(150, 45));
        make.top.mas_equalTo(btn.mas_top);
        make.right.mas_equalTo(btn.mas_left).mas_offset(-20);
    }];
    
    selectView = [[UIView alloc]init];
    selectView.backgroundColor = RGB(20, 160, 195);
    selectView.hidden = YES;
    [self.view addSubview:selectView];
    
    
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    password = [[UITextField alloc]init];
    password.borderStyle =  UITextBorderStyleNone;
    password.textAlignment = NSTextAlignmentCenter;
    [password setBackground:[UIImage imageNamed:@"password"]];
    password.secureTextEntry = YES;
    BOOL firstLanuchApp = [userDefualts boolForKey:@"firstLanuchApp"];
    
    //第一次启动
    if (!firstLanuchApp) {
        password.placeholder = @"设置隐私密码";
        
    }
    else
    {
        password.placeholder = @"输入隐私密码访问";
    }
    [selectView addSubview:password];
    
    
    UIImageView *logoIamge = [[UIImageView alloc]init];
    logoIamge.image = [UIImage imageNamed:@"log"];
    [selectView addSubview:logoIamge];
    
    [logoIamge mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(selectView.top).mas_offset(40);
        make.centerX.mas_equalTo(selectView.centerX);
    }];
    
    UIImageView *rebackImage = [[UIImageView alloc]init];
    rebackImage.image = [UIImage imageNamed:@"back_arrow@2x.png"];
    [selectView addSubview:rebackImage];
  
    [rebackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(25);
    }];

    UIButton *reBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reBackBtn setTitle:@"返回" forState:UIControlStateNormal];
    reBackBtn.backgroundColor = [UIColor clearColor];
    [reBackBtn addTarget:self action:@selector(rebackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [reBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectView addSubview:reBackBtn];
    
    [reBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.mas_equalTo(rebackImage.centerY);
        make.left.mas_equalTo(30);
    }];

    [password mas_makeConstraints:^(MASConstraintMaker *make) {
       
//        make.size.mas_equalTo(CGSizeMake(240, 44));
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
//        make.centerX.mas_equalTo(selectView.centerX);
//        make.bottom.mas_equalTo(selectView.centerY).mas_offset(-60);
        make.top.mas_equalTo(logoIamge.bottom).mas_offset(60);
    }];
    
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor orangeColor];
    sureBtn.layer.cornerRadius = 10;
    sureBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    sureBtn.layer.borderWidth = 1;
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(password.mas_width);
        make.height.mas_equalTo(password.mas_height);
        make.centerX.mas_equalTo(selectView.centerX);
        make.top.mas_equalTo(password.mas_bottom).mas_offset(40);
    }];
    
    if (!firstLanuchApp) {
        
    }
    else
    {
        UIButton *forBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        forBtn.backgroundColor = [UIColor clearColor];
        [forBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forBtn addTarget:self action:@selector(forBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:forBtn];
        
        [forBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.mas_equalTo(sureBtn.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(sureBtn.right);
        }];

        //修改密码
        UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [modifyBtn setTitle:@"修改密码" forState:UIControlStateNormal];
        modifyBtn.backgroundColor = [UIColor clearColor];
        [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectView addSubview:modifyBtn];
        [modifyBtn addTarget:self action:@selector(modifyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.top.mas_equalTo(sureBtn.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(44);
            make.left.mas_equalTo(sureBtn.left);
        }];

    }
    
}
#pragma mark - 修改密码
-(void)modifyBtnAction
{
    ModifyPasswordViewController *vc = [[ModifyPasswordViewController alloc]init];
    vc.keychainItemWrapper = keychainItemWrapper;
    [self presentViewController:vc animated:NO completion:nil];
}
#pragma mark - 忘记密码
-(void)forBtnAction
{
    ForgetPassViewController *vc = [[ForgetPassViewController alloc]init];
    vc.keychainItemWrapper = keychainItemWrapper;
    [self presentViewController:vc animated:NO completion:nil];
}



-(void)rebackBtnAction:(UIButton *)button
{
    [UIView transitionWithView:self.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        selectView.hidden = YES;
        
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - 拍照
-(void)cameraBtnAction:(UIButton *)button
{
 
    //定义拍照控制器
    GBCustomCameraController *customCameraVC = [[GBCustomCameraController alloc] init];
    
    [self presentViewController:customCameraVC animated:YES completion:nil];

}

-(void)sureBtnAction:(UIButton *)button
{
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
     BOOL firstLanuchApp = [userDefualts boolForKey:@"firstLanuchApp"];
    //第一次
    if (!firstLanuchApp) {
        
        [keychainItemWrapper setObject:password.text forKey:(id)kSecValueData];
        [XHToast showTopWithText:@"设置成功" topOffset:80 duration:1];
        [userDefualts setBool:YES forKey:@"firstLanuchApp"];
        SelectViewController *vc = [[SelectViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
         NSString *secret = [keychainItemWrapper objectForKey:(id)kSecValueData];
        if ([secret isEqualToString:password.text]) {
            
            SelectViewController *vc = [[SelectViewController alloc]init];
            [self presentViewController:vc animated:NO completion:nil];
        }
        else
        {
            [XHToast showCenterWithText:@"密码错误" duration:1.5];
        }
    }
    
}

-(void)btnAction
{
    [UIView transitionWithView:self.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
                selectView.hidden = NO;
        
            } completion:^(BOOL finished) {
        
    }];

}

-(void)noticeAction
{
    
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    
    BOOL firstLanuchApp = [userDefualts boolForKey:@"firstLanuchApp"];
    
    //第一次启动
    if (!firstLanuchApp) {
        
        alertVc = [UIAlertController alertControllerWithTitle:@"请输入保护密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
         __weak typeof(self) weakSelf = self;
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
            textField.delegate = weakSelf;
            textField.returnKeyType = UIReturnKeyDone;
        }];
        
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"再次输入密码";
            textField.secureTextEntry = YES;
            textField.delegate = weakSelf;
            textField.returnKeyType = UIReturnKeyDone;
        }];

    }
    else
    {
        
        alertVc = [UIAlertController alertControllerWithTitle:@"输入保护密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) weakSelf = self;
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
            textField.delegate = weakSelf;
            textField.returnKeyType = UIReturnKeyDone;
        }];
        
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)isSuccessVerifyPassword
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
