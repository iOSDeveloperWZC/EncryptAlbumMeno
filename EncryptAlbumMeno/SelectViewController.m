//
//  SelectViewController.m
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/5.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "SelectViewController.h"
#import "XZPhotoBrowserViewController.h"
#import "GBCustomCameraController.h"
#import "MemoTableViewController.h"
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
//        self.view.backgroundColor = RGB(20, 160, 195) ;
    self.view.backgroundColor = [UIColor whiteColor];
        UIView *selectView = self.view;
        UILabel *albumLable = [[UILabel alloc]init];
        albumLable.layer.cornerRadius = 10;
        albumLable.clipsToBounds = YES;
        albumLable.layer.borderColor = [UIColor purpleColor].CGColor;
        albumLable.layer.borderWidth = 1;
    
        albumLable.textAlignment = NSTextAlignmentCenter;
        albumLable.text = @"相册";
        albumLable.backgroundColor = [UIColor whiteColor];
        albumLable.textColor = [UIColor grayColor];
        albumLable.font = Font(20);
        albumLable.shadowOffset = CGSizeMake(0, -10);
        albumLable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(albumTap)];
        [albumLable addGestureRecognizer:tap1];
        [selectView addSubview:albumLable];
    
        UILabel *cameraLable = [[UILabel alloc]init];
        cameraLable.textAlignment = NSTextAlignmentCenter;
        cameraLable.text = @"相机";
        cameraLable.backgroundColor = [UIColor whiteColor];
        cameraLable.textColor = [UIColor grayColor];
        cameraLable.font = Font(20);
        cameraLable.layer.cornerRadius = 10;
        cameraLable.layer.borderColor = [UIColor purpleColor].CGColor;
        cameraLable.layer.borderWidth = 1;
        cameraLable.clipsToBounds = YES;
        cameraLable.shadowOffset = CGSizeMake(0, -3);
        cameraLable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraTap)];
        [cameraLable addGestureRecognizer:tap3];
        [selectView addSubview:cameraLable];

    
    
        UILabel *menoLable = [[UILabel alloc]init];
        menoLable.textAlignment = NSTextAlignmentCenter;
        menoLable.text = @"备忘录";
        menoLable.userInteractionEnabled = YES;
        menoLable.font = Font(20);
        menoLable.backgroundColor = [UIColor whiteColor];
        menoLable.textColor = [UIColor grayColor];
        menoLable.layer.cornerRadius = 10;
        menoLable.layer.borderWidth = 1;
        menoLable.layer.borderColor = [UIColor purpleColor].CGColor;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MenoTap)];
        [menoLable addGestureRecognizer:tap2];
        [selectView addSubview:menoLable];
    
    
        [albumLable mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.bottom.mas_equalTo(selectView.centerY).mas_offset(-20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(65);
        }];
    
        [cameraLable mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(selectView.centerY).mas_offset(20);
            make.left.mas_equalTo(albumLable.left);
            make.right.mas_equalTo(albumLable.right);
            make.height.mas_equalTo(albumLable.height);

        }];
    
        [menoLable mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.top.mas_equalTo(cameraLable.bottom).mas_offset(40);
            make.left.mas_equalTo(cameraLable.left);
            make.right.mas_equalTo(cameraLable.right);
            make.height.mas_equalTo(cameraLable.height);
        }];
}

-(void)cameraTap
{
    //定义拍照控制器
    GBCustomCameraController *customCameraVC = [[GBCustomCameraController alloc] init];
    
    [self presentViewController:customCameraVC animated:YES completion:nil];
}

#pragma mark - 选择相册
-(void)albumTap
{
    
    XZPhotoBrowserViewController *vc = [[XZPhotoBrowserViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}

//备忘录
-(void)MenoTap
{
    MemoTableViewController *vc = [[MemoTableViewController alloc]init];
    [self presentViewController:vc animated:NO completion:nil];
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
