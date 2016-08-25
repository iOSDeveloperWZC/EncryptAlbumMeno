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
#import <LocalAuthentication/LocalAuthentication.h>
@interface AlertSettingPasswordViewController ()<UITextFieldDelegate>
{
    KeychainItemWrapper *keychainItemWrapper;
    UIView *selectView;
    UIAlertController *alertVc;
    UITextField *password;
    UITextField *telephone;
    UITextField *smsCodel;
    UIButton *sendCodeBtn;
    UIButton *sureBtn;
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
 
//    bgImageView.image = [UIImageEffects imageByApplyingExtraLightEffectToImage:[UIImage imageNamed:@"Image"]];
//    bgImageView.image = [UIImageEffects imageByApplyingLightEffectToImage:[UIImage imageNamed:@"Image"]];
//    bgImageView.image = [UIImageEffects imageByApplyingDarkEffectToImage:[UIImage imageNamed:@"Image"]];
//    bgImageView.image = [UIImageEffects imageByApplyingTintEffectWithColor:[UIColor colorWithWhite:0.9 alpha:01] toImage:[UIImage imageNamed:@"Image"]];

    bgImageView.image = [UIImage imageNamed:@"Image"];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(64);
        make.centerX.mas_equalTo(self.view.centerX);
    }];
    
    UILabel *logoLable = [[UILabel alloc]init];
    logoLable.text = @"杭州之行网络科技";
    logoLable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:logoLable];
    [logoLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(bgImageView.mas_bottom).with.mas_offset(15);
        make.centerX.mas_equalTo(self.view.centerX);

    }];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    cameraBtn.layer.cornerRadius = 10;
    cameraBtn.layer.borderColor = [UIColor purpleColor].CGColor;
    cameraBtn.layer.borderWidth = 1;
    cameraBtn.backgroundColor = [UIColor whiteColor];
    [cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"进入相册/备忘录" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.layer.borderColor = [UIColor purpleColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(logoLable.bottom).mas_offset(70);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cameraBtn.left);
        make.right.mas_equalTo(cameraBtn.right);
        make.height.mas_equalTo(cameraBtn.height);
        make.top.mas_equalTo(cameraBtn.bottom).mas_offset(40);
    }];
    
    
    //反面
    selectView = [[UIView alloc]init];
//    selectView.backgroundColor = RGB(20, 160, 195);
    selectView.backgroundColor = [UIColor whiteColor];
    
    selectView.hidden = YES;
    [self.view addSubview:selectView];
    
    
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    password = [[UITextField alloc]init];
    password.borderStyle =  UITextBorderStyleNone;
    password.textAlignment = NSTextAlignmentCenter;
    [password setBackground:[UIImage imageNamed:@"password"]];
    password.secureTextEntry = YES;
    BOOL firstLanuchApp = [userDefualts boolForKey:@"firstLanuchApp"];
    
    telephone = [[UITextField alloc]init];
    telephone.borderStyle = UITextBorderStyleNone;
    telephone.textAlignment = NSTextAlignmentCenter;
    telephone.placeholder =  @"绑定电话号码";
    [telephone setBackground:[UIImage imageNamed:@"Tele"]];
    telephone.keyboardType = UIKeyboardTypeNumberPad;
    [selectView addSubview:telephone];
    
    sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCodeBtn addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    [sendCodeBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [selectView addSubview:sendCodeBtn];
    
    smsCodel = [[UITextField alloc]init];
    smsCodel.borderStyle = UITextBorderStyleNone;
    smsCodel.textAlignment = NSTextAlignmentCenter;
    smsCodel.placeholder =  @"输入验证码验证手机号";
    [smsCodel setBackground:[UIImage imageNamed:@"password"]];
    smsCodel.keyboardType = UIKeyboardTypeNumberPad;
    [selectView addSubview:smsCodel];

    
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
    logoIamge.image = [UIImage imageNamed:@"Image"];
    [selectView addSubview:logoIamge];
    
    [logoIamge mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(selectView.top).mas_offset(64);
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
    [reBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectView addSubview:reBackBtn];
    
    [reBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.mas_equalTo(rebackImage.centerY);
        make.left.mas_equalTo(15);
    }];
    
    UILabel *logo1Lable = [[UILabel alloc]init];
    logo1Lable.text = @"杭州之行网络科技";
    logo1Lable.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:logo1Lable];
    [logo1Lable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(logoIamge.mas_bottom).with.mas_offset(15);
        make.centerX.mas_equalTo(self.view.centerX);
        
    }];

    //第一次启动
    if (!firstLanuchApp) {
        
        
        
        [telephone mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(20);
//            make.right.mas_equalTo(sendCodeBtn);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(logo1Lable.bottom).mas_offset(70);

        }];
        
        [sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(telephone.right).mas_offset(10);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(telephone.centerY);
        }];
        
        [smsCodel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(telephone.bottom).mas_offset(40);
        }];
        
        [password mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.size.mas_equalTo(CGSizeMake(240, 44));
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(50);
            //        make.centerX.mas_equalTo(selectView.centerX);
            //        make.bottom.mas_equalTo(selectView.centerY).mas_offset(-60);
            make.top.mas_equalTo(smsCodel.bottom).mas_offset(40);
        }];
    }
    else
    {
        [password mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.size.mas_equalTo(CGSizeMake(240, 44));
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(50);
            //        make.centerX.mas_equalTo(selectView.centerX);
            //        make.bottom.mas_equalTo(selectView.centerY).mas_offset(-60);
            make.top.mas_equalTo(logo1Lable.bottom).mas_offset(70);
        }];
    }


 
    
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!firstLanuchApp) {
        
        [sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
    else
    {
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }

    
    sureBtn.layer.cornerRadius = 10;
    sureBtn.layer.borderColor = [UIColor purpleColor].CGColor;
    sureBtn.layer.borderWidth = 1;
    [sureBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
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
        [forBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
        [modifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
    [password resignFirstResponder];
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

//发送验证码
-(void)sendCode:(UIButton *)btn
{
    if (telephone.text.length != 11) {
        
        [XHToast showCenterWithText:@"请输入11位电话号码"];
        return;
    }
    
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = [NSString stringWithFormat:@"%@",[NSDate date]];// 设置用户名
    user.password =  [NSString stringWithFormat:@"%@00890098",password.text];// 设置密码
    user.mobilePhoneNumber = telephone.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
            [XHToast showCenterWithText:@"发送成功，请查收"];
            
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
        }
    }];

    
}

//注册按钮
-(void)sureBtnAction:(UIButton *)button
{
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
     BOOL firstLanuchApp = [userDefualts boolForKey:@"firstLanuchApp"];
    //第一次
    if (!firstLanuchApp) {
        
        if (password.text.length == 0) {
            
            [XHToast showCenterWithText:@"还没设定密码"];
            return;
        }
        
        if (telephone.text.length != 11) {
            
            [XHToast showCenterWithText:@"绑定号码不是11位？"];
            return;
        }
        
        [XHToast showCenterWithText:@"请稍等.." duration:2];
        [AVUser verifyMobilePhone:smsCodel.text withBlock:^(BOOL succeeded, NSError *error) {
            //验证结果
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [keychainItemWrapper setObject:password.text forKey:(id)kSecValueData];
                    [XHToast showTopWithText:@"设置成功" topOffset:80 duration:1];
                    [userDefualts setBool:YES forKey:@"firstLanuchApp"];
                    
                    SelectViewController *vc = [[SelectViewController alloc]init];
                    [self presentViewController:vc animated:YES completion:nil];
                });
            }
        }];
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
                NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
                BOOL firstLanuchApp = [userDefualts boolForKey:@"firstLanuchApp"];
                //不是第一次
                if (firstLanuchApp) {
                    
                    //弹出
                    LAContext *myContext = [[LAContext alloc] init];
                    NSError *authError = nil;
                    //授权原因
                    NSString *myLocalizedReasonString = @"验证密码";
                    //if条件判断设备是否支持Touch ID 是否开启Touch id等

                    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
                        //弹出指纹识别界面
                        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                  localizedReason:myLocalizedReasonString
                                            reply:^(BOOL success, NSError *authenticationError) {
                                                if (success) {
                                                    
                                                    NSLog(@"验证成功成功");
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                        //用户选择输入密码，切换主线程处理
                                                        SelectViewController *vc = [[SelectViewController alloc]init];
                                                        [self presentViewController:vc animated:NO completion:nil];
                                                    }];
                                                }
                                                else {
                                                    
                                                    switch (authenticationError.code) {
                                                            
                                                        case LAErrorAuthenticationFailed:
                                                        {
                                                    
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [XHToast showTopWithText:@"指纹错误" topOffset:80 duration:1];
                                                            });
                                                           
                                                            break;
                                                        }
                                                        case LAErrorUserCancel:
                                                        {
                                                            NSLog(@"用户点击了取消按钮");
                                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                //用户选择输入密码，切换主线程处理
                                                    
                                                                [password becomeFirstResponder];
                                                            }];
                                                            //用户取消验证Touch ID
                                                            break;
                                                        }
                                                        case LAErrorUserFallback:
                                                        {
                                                            NSLog(@"用户选择输入密码");
                                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                //用户选择输入密码，切换主线程处理
                                                                [password becomeFirstResponder];
                                                            }];
                                                            break;
                                                        }
                                                        case LAErrorSystemCancel :
                                                        {
                                                            NSLog(@"切换到其他的app(按了Home按键)，被系统取消");
                                                            
                                                            break;
                                                        }//
                                                        case LAErrorTouchIDLockout :
                                                        {
                                                            NSLog(@"用户指纹错误多次，TOuch ID 被锁定");
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [XHToast showTopWithText:@"指纹错误多次,被锁定" topOffset:80 duration:1];
                                                            });
                                                         
                                                            break;
                                                        }//9.0 我试了验证过程中电话进来 返回的LAErrorSystemCancel 错误码 不是这个
                                                        case LAErrorAppCancel:
                                                        {
                                                            NSLog(@"被(突如其来的)应用（电话）取消");
                                                            
                                                            break;
                                                        }//LAErrorInvalidContext
                                                        default:
                                                        {
                                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                //其他情况，切换主线程处理
                                                            }];
                                                            break;
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }];
                    }
                    else {
                        
                        switch (authError.code) {
                                //9.0 试过了不设置密码返回的是 LAErrorTouchIDNotEnrolled 错误码
                            case LAErrorPasscodeNotSet:
                            {
                                NSLog(@"在设置里面没有设置密码");
                                break;
                            }
                            case LAErrorTouchIDNotAvailable:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    //用户选择输入密码，切换主线程处理
//                                    [password becomeFirstResponder];
                                    [XHToast showTopWithText:@"设备不支持Touch ID" topOffset:80 duration:1];
                                }];
                                NSLog(@"设备不支持Touch ID");
                                break;
                            }
                            case LAErrorTouchIDNotEnrolled:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    //用户选择输入密码，切换主线程处理
//                                    [password becomeFirstResponder];
                                    [XHToast showTopWithText:@"没有开启指纹验证" topOffset:80 duration:1];
                                }];
                                NSLog(@"在设置里面没有设置Touch Id 指纹");
                                break;
                            }
                            case LAErrorInvalidContext:
                            {
                                NSLog(@"创建的指纹对象失效");
                                break;
                            }
                                
                            default:
                            {
                                break;
                            }
                        }
                    }
                    
                }
                
                
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
