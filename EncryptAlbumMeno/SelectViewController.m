//
//  SelectViewController.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/5.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()
{
    UIWebView *imageWebView;
}
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showGifImageWithWebView];
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
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(albumTap)];
    [albumLable addGestureRecognizer:tap1];
        [selectView addSubview:albumLable];
    
    
        UILabel *menoLable = [[UILabel alloc]init];
        menoLable.textAlignment = NSTextAlignmentCenter;
        menoLable.text = @"备忘录";
        menoLable.font = Font(20);
        menoLable.backgroundColor = [UIColor cyanColor];
        menoLable.textColor = [UIColor lightGrayColor];
        menoLable.layer.borderWidth = 1;
        menoLable.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MenoTap)];
    [menoLable addGestureRecognizer:tap2];
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

-(void)albumTap
{
    
}

-(void)MenoTap
{
    
}

-(void)showGifImageWithWebView{
    //读取gif图片数据
    NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"BB" ofType:@"gif"]];
    //UIWebView生成
    imageWebView = [[UIWebView alloc] init];
    imageWebView.backgroundColor = [UIColor clearColor];
     [imageWebView setOpaque:NO];
    imageWebView.userInteractionEnabled = NO;
    //加载gif数据
    [imageWebView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    //视图添加此gif控件

    [self.view addSubview:imageWebView];

    [imageWebView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(40);;
        make.centerX.mas_equalTo(self.view.centerX);
        make.height.mas_equalTo(208);
        make.width.mas_equalTo(208);
    }];
    //用户不可交互
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
