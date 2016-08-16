//
//  ModifyPasswordViewController.m
//  TBaoApp
//
//  Created by ataw on 16/6/12.
//  Copyright © 2016年 杭州信使网络科技. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *oldPasswordField;
    UITextField *newPasswordField;
    UITextField *confirNewPasswordField;
    UIView *firstLine;
    UIView *secondLine;
    UIView *thirdLine;
    UIButton *rightButton;
}
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navTitle = @"修改密码";
    [self creatNavAndStateView];
    [self creatLeftBtn];
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth - 60, 20 + 7, 60, 30);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navAndStateView addSubview:rightButton];


    
    //2、设置账号登录框
    oldPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(25, 64 + 15 + 40, kScreenWidth - 2*25, 60)];
    oldPasswordField.placeholder = @"请输入旧密码";
    oldPasswordField.secureTextEntry = YES;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = RGB(204.0,204.0,204.0);
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *attributeString  = [[NSAttributedString alloc]initWithString:oldPasswordField.placeholder attributes:dic];
    [oldPasswordField setAttributedPlaceholder:attributeString];
    [self.view addSubview:oldPasswordField];
    oldPasswordField.delegate = self;
    
    //3、文本框底部的线条
    firstLine = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(oldPasswordField.frame), kScreenWidth - 2*25, 1)];
    firstLine.backgroundColor = RGB(217.0,217.0,217.0);
    [self.view addSubview:firstLine];
    
    //4、密码文本框
    newPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(firstLine.frame), kScreenWidth - 2* 50, 60)];
    newPasswordField.placeholder = @"密码";
    newPasswordField.secureTextEntry = YES;
    newPasswordField.delegate = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] =  RGB(204.0,204.0,204.0);
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *as = [[NSAttributedString alloc]initWithString:newPasswordField.placeholder attributes:dict];
    [newPasswordField setAttributedPlaceholder:as];
    [self.view addSubview:newPasswordField];
    
    //5、设置第二个文本框底部的线条
    secondLine = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(newPasswordField.frame), kScreenWidth - 2*25, 1)];
    secondLine.backgroundColor = RGB(217.0,217.0,217.0);
    [self.view addSubview:secondLine];
    
    //4、密码文本框
    confirNewPasswordField = [[UITextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(secondLine.frame), kScreenWidth - 2* 50, 60)];
    confirNewPasswordField.placeholder = @"再次输入密码";
    confirNewPasswordField.secureTextEntry = YES;
    confirNewPasswordField.delegate = self;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[NSForegroundColorAttributeName] =  RGB(204.0,204.0,204.0);
    dict1[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSAttributedString *as1 = [[NSAttributedString alloc]initWithString:confirNewPasswordField.placeholder attributes:dict1];
    [confirNewPasswordField setAttributedPlaceholder:as1];
    [self.view addSubview:confirNewPasswordField];
    
    //5、设置第二个文本框底部的线条
    thirdLine = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(confirNewPasswordField.frame), kScreenWidth - 2*25, 1)];
    thirdLine.backgroundColor = RGB(217.0,217.0,217.0);
    [self.view addSubview:thirdLine];

    
}
//string oldpwd, string newpwd)
-(void)submitButtonAction:(UIButton *)button
{
    if (oldPasswordField.text.length == 0||newPasswordField.text.length == 0||confirNewPasswordField.text.length == 0) {
         [XHToast showCenterWithText:@"输入信息不全"];
        return;
    }
    if (![newPasswordField.text isEqualToString:confirNewPasswordField.text]) {
        [XHToast showCenterWithText:@"新密码不一致"];
    
        return;
    }
    
    NSString *secret = [_keychainItemWrapper objectForKey:(id)kSecValueData];
    
    if ([secret isEqualToString:oldPasswordField.text]) {
        
        [_keychainItemWrapper setObject:confirNewPasswordField.text forKey:(id)kSecValueData];
        [self dismissViewControllerAnimated:NO completion:nil];
        [XHToast showCenterWithText:@"修改成功" duration:1.5];
    }
    else
    {
        [XHToast showCenterWithText:@"原密码错误" duration:1.5];
    }


}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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
