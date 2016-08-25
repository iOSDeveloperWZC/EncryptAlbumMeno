//
//  ForgetPassViewController.m
//  TBaoApp
//
//  Created by ataw on 16/4/27.
//  Copyright © 2016年 杭州信使网络科技. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "PasswordViewController.h"
@interface ForgetPassViewController ()
{
    UIButton *cancelButton;
    UILabel *navTitile;
    
    UIButton *nextStepButton;
    UIButton *fetchCheckButton;
    UITextField *telephoneField;
    UITextField *checkCodeField;
    UIView *firstLine;
    UIView *secondLine;
    NSInteger _count;
    NSInteger _number;
}
@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatView];
}

-(void)creatView
{
    //1、创建导航栏的取消按钮
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(15, 35, 15, 15);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_choice@2x.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    //2、创建导航栏标题
    navTitile = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 100)/2, 20, 100, 44)];
    navTitile.font = [UIFont systemFontOfSize:18];
    navTitile.textColor = RGB(51.0,51.0,51.0);
    navTitile.text = @"验证手机号";
    [self.view addSubview:navTitile];
    
    //3、创建两个文本框和下划线
    //2、设置账号登录框
    telephoneField = [[UITextField alloc]initWithFrame:CGRectMake(25, 90, kScreenWidth - 25 - 180, 60)];
    telephoneField.placeholder = @"输入绑定的手机号";
    telephoneField.keyboardType = UIKeyboardTypeNumberPad;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = RGB(204.0,204.0,204.0);
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *attributeString  = [[NSAttributedString alloc]initWithString:telephoneField.placeholder attributes:dic];
    [telephoneField setAttributedPlaceholder:attributeString];
    [self.view addSubview:telephoneField];
    
    //3、文本框底部的线条
    firstLine = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(telephoneField.frame), kScreenWidth - 2*25, 1)];
    firstLine.backgroundColor = RGB(217.0,217.0,217.0);
    [self.view addSubview:firstLine];
    
    //4、验证码文本框
    checkCodeField = [[UITextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(firstLine.frame), kScreenWidth - 2* 50, 60)];
    checkCodeField.placeholder = @"短信验证码";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] =  RGB(204.0,204.0,204.0);
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *as = [[NSAttributedString alloc]initWithString:checkCodeField.placeholder attributes:dict];
    [checkCodeField setAttributedPlaceholder:as];
    [self.view addSubview:checkCodeField];
    
    //5、设置第二个文本框底部的线条
    secondLine = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(checkCodeField.frame), kScreenWidth - 2*25, 1)];
    secondLine.backgroundColor = RGB(217.0,217.0,217.0);
    [self.view addSubview:secondLine];
    
    //6、创建登录按钮
    nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepButton.frame = CGRectMake(25, CGRectGetMaxY(secondLine.frame)+60, kScreenWidth - 2*25, 44);
    nextStepButton.backgroundColor = RGB(78.0,171.0,222.0);
    [nextStepButton setTitleColor:RGB(255.0,255.0,255.0) forState:UIControlStateNormal];
    [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextStepButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nextStepButton.layer.cornerRadius = 10;
    nextStepButton.userInteractionEnabled = NO;
    [nextStepButton addTarget:self action:@selector(nextStepButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];

    
    //7、创建发送验证码按钮
    fetchCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fetchCheckButton.frame = CGRectMake(kScreenWidth - 25 - 100, CGRectGetMinY(telephoneField.frame) + 10, 100, 40);
    [fetchCheckButton addTarget:self action:@selector(fetchCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [fetchCheckButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    fetchCheckButton.titleLabel.textColor = [UIColor whiteColor];
    fetchCheckButton.titleLabel.font = [UIFont systemFontOfSize:14];
    fetchCheckButton.backgroundColor = RGB(246.0,70.0,70.0);
    fetchCheckButton.layer.cornerRadius = 5;
    [self.view addSubview:fetchCheckButton];
    //8、注册通知改变登录按钮的背景颜色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)fetchCodeButtonAction
{
    [self performSelector:@selector(sendAction) withObject:nil];
}

// 模拟交易成功
- (void)sendAction
{
    fetchCheckButton.enabled = NO;
    _count = 60;
    _number = 0;
    if (telephoneField.text.length != 11) {
        
        [XHToast showCenterWithText:@"输入11位电话号码"];
        fetchCheckButton.enabled = YES;
        return;
    }
    
//    //验证手机号
//    [AVUser requestMobilePhoneVerify:telephoneField.text withBlock:^(BOOL succeeded, NSError *error) {
//        if(succeeded){
//            //发送成功
//        }
//    }];
    
    [AVOSCloud requestSmsCodeWithPhoneNumber:telephoneField.text
                                     appName:@"Encrypt"
                                   operation:@"忘记密码操作"
                                  timeToLive:10
                                    callback:^(BOOL succeeded, NSError *error) {
                                        
                                        if (succeeded) {
                                            // 发送成功
                                            //短信格式类似于：
                                            //您正在{某应用}中进行{具体操作名称}，您的验证码是:{123456}，请输入完整验证，有效期为:{10}分钟
                                            [XHToast showCenterWithText:@"发送成功,请注意查收短信"];
                                        }
                                        
                                    }];
    

    [fetchCheckButton setTitle:@"60秒后重发" forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(NSTimer *)_timer
{
    if (_count !=0 && _number ==0) {
        _count -=1;
        NSString *str = [NSString stringWithFormat:@"%ld秒后重发", (long)_count];
        [fetchCheckButton setTitle:str forState:UIControlStateDisabled];
    }else{
        [_timer invalidate];
        fetchCheckButton.enabled = YES;
        [fetchCheckButton setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}


-(void)textChange:(NSNotification *)notice
{
    [self nextButtonBackColor:[self hasValueTwoTextField]];
}


-(BOOL)hasValueTwoTextField
{
    if (telephoneField.text.length != 0&&telephoneField.text != nil&&checkCodeField.text != nil && checkCodeField.text.length != 0) {
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}


-(void)nextButtonBackColor:(BOOL)value
{
    if (value) {
        
        nextStepButton.backgroundColor = RGB(0.0,134.0,207.0);
        nextStepButton.userInteractionEnabled = YES;
    }
    else
    {
        nextStepButton.backgroundColor = RGB(78.0,171.0,222.0);
        nextStepButton.userInteractionEnabled = NO;
    }
    
}

//下一步 验证手机  /app/ValidResetPhone 参数 string phone, string code, string needValid = "1" (needValid可空， 1则判断验证码有效期) 
-(void)nextStepButtonAction
{
    
    if (checkCodeField.text.length == 0) {
        
        [XHToast showCenterWithText:@"请输入验证码"];
        return;
    }
//    UITextField *telephoneField;
//    UITextField *checkCodeField;
    
    [AVOSCloud verifySmsCode:checkCodeField.text mobilePhoneNumber:telephoneField.text callback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            //验证成功
            PasswordViewController *vc = [[PasswordViewController alloc]init];
            vc.keychainItemWrapper = _keychainItemWrapper;
            [self presentViewController:vc animated:YES completion:nil];
        }
        else
        {
            [XHToast showCenterWithText:@"验证电话号码失败?"];
        }
        
    }];
}

//取消
-(void)cancelButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
