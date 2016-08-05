//
//  SelectViewController.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/5.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(20, 160, 195) ;
        UIView *selectView = self.view;
        UILabel *albumLable = [[UILabel alloc]init];
        albumLable.textAlignment = NSTextAlignmentCenter;
        albumLable.text = @"相册";
        albumLable.backgroundColor = [UIColor orangeColor];
        albumLable.textColor = [UIColor lightGrayColor];
        albumLable.font = Font(20);
        albumLable.layer.borderColor = [UIColor whiteColor].CGColor;
        albumLable.layer.borderWidth = 1;
        albumLable.shadowOffset = CGSizeMake(0, -3);
        [selectView addSubview:albumLable];
    
    
        UILabel *menoLable = [[UILabel alloc]init];
        menoLable.textAlignment = NSTextAlignmentCenter;
        menoLable.text = @"备忘录";
        menoLable.font = Font(20);
        menoLable.backgroundColor = [UIColor cyanColor];
        menoLable.textColor = [UIColor lightGrayColor];
        menoLable.layer.borderWidth = 1;
        menoLable.layer.borderColor = [UIColor whiteColor].CGColor;
    
        [selectView addSubview:menoLable];
    
    
        [albumLable mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.bottom.mas_equalTo(selectView.centerY).mas_offset(-20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(65);
        }];
    
        [menoLable mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.top.mas_equalTo(selectView.centerY).mas_offset(20);
            make.left.mas_equalTo(albumLable.left);
            make.right.mas_equalTo(albumLable.right);
            make.height.mas_equalTo(albumLable.height);
        }];
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
