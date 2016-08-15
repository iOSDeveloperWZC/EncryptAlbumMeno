//
//  PasswordViewController.m
//  TBaoApp
//
//  Created by ataw on 16/4/27.
//  Copyright © 2016年 杭州信使网络科技. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController
{
    UIButton *cancelButton;
    UILabel *navTitile;
    
    UIButton *nextStepButton;
    UITextField *telephoneField;
    UITextField *checkCodeField;
    UIView *firstLine;
    UIView *secondLine;

}
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
    navTitile.text = @"找回密码";
    [self.view addSubview:navTitile];
    
    //3、创建两个文本框和下划线
    //2、设置账号登录框
    telephoneField = [[UITextField alloc]initWithFrame:CGRectMake(25, 90, kScreenWidth - 2*25, 60)];
    telephoneField.placeholder = @"密码";
    telephoneField.secureTextEntry = YES;
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
    checkCodeField.placeholder = @"确认密码";
    checkCodeField.secureTextEntry = YES;
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
    [nextStepButton setTitle:@"确认" forState:UIControlStateNormal];
    nextStepButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nextStepButton.userInteractionEnabled = NO;
    nextStepButton.layer.cornerRadius = 10;
    [nextStepButton addTarget:self action:@selector(nextStepButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
    
    //8、注册通知改变登录按钮的背景颜色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
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

//下一步/app/SetResetPassword 参数 string password 
-(void)nextStepButtonAction
{
    [self.view endEditing:YES];
    
    if (![telephoneField.text isEqualToString:checkCodeField.text]) {
        
        [XHToast showCenterWithText:@"两次输入的密码不一致"];
        return;
    }

    [_keychainItemWrapper setObject:checkCodeField.text forKey:(id)kSecValueData];
    [XHToast showTopWithText:@"设置成功" topOffset:80 duration:1];
    
    [self cancelButtonAction];
}

//取消
-(void)cancelButtonAction
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    self.presentingViewController.view.alpha = 0;
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
