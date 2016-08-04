//
//  AlertSettingPasswordViewController.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/4.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "AlertSettingPasswordViewController.h"
#import "KeychainItemWrapper.h"
@interface AlertSettingPasswordViewController ()
{
    KeychainItemWrapper *keychainItemWrapper;
}
@end

@implementation AlertSettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    keychainItemWrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"secret" accessGroup:nil];
    [self creatSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeAction) name:WZCEnterGorground object:nil];
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
}

-(void)noticeAction
{
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    
    BOOL firstLanuchApp = [userDefualts boolForKey:@"firstLanuchApp"];
    
    //第一次启动
    if (!firstLanuchApp) {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请输入保护密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
        }];
        
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"再次输入密码";
            textField.secureTextEntry = YES;
        }];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.view endEditing:YES];
            
            UITextField *first = [alertVc.textFields firstObject];
            UITextField *second = [alertVc.textFields lastObject];
            
            if ([first.text isEqualToString:second.text]) {
                
                [keychainItemWrapper setObject:second.text forKey:WZCSecret];
                [userDefualts setBool:YES forKey:@"firstLanuchApp"];
                [XHToast showTopWithText:@"设置成功" topOffset:80 duration:3];
            }
            else
            {
                [XHToast showTopWithText:@"两次密码不一致" topOffset:80 duration:3];
            }
            
            [alertVc dismissViewControllerAnimated:YES completion:^{
                
                
            }];
        }];
        
        [alertVc addAction:action];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else
    {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"输入保护密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
        }];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
//            [self.view endEditing:YES];
             UITextField *textFiled = [alertVc.textFields lastObject];
            [textFiled resignFirstResponder];
            NSString *secret = [keychainItemWrapper objectForKey:WZCSecret];
            if ([textFiled.text isEqualToString:secret]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [XHToast showTopWithText:@"验证成功" topOffset:80 duration:3];
                });
            }
            else
            {
                [XHToast showTopWithText:@"验证失败，稍后再试" topOffset:80 duration:3];
            }

            [alertVc dismissViewControllerAnimated:YES completion:^{
                            }];
        }];
        
        [alertVc addAction:action];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }

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
