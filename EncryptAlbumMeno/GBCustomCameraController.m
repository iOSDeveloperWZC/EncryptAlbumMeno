//
//  GBCustomCameraController.m
//  GBCustomCamera
//
//  Created by iMac on 16/7/18.
//  Copyright © 2016年 GB. All rights reserved.
//
#import <Photos/Photos.h>
#import "GBCustomCameraController.h"
@interface GBCustomCameraController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic , weak) GPUImageView *cameraView;
@end

@implementation GBCustomCameraController
{
    NSMutableArray *btnArr;
    GPUImageView *cameraView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    btnArr = [NSMutableArray array];
    
    //定义相机现实的界面及设置相关滤镜等属性
    [self setupCameraView];
    
    //定义切换相机按钮
    [self setupChangeCamera];
    
    //定义拍照按钮
    [self setupTakePhotoBtn];
    
    //定义取消按钮
    [self setupCancleBtn];
    
    //定义相册按钮
    [self setupPhotoAlbumBtn];
    
    [self switchFilter];
}


//定义相机现实的界面及设置相关滤镜等属性
- (void)setupCameraView
{
    //定义相机输出界面
    cameraView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 44,GBWidth, GBWidth + 145 * GBScale - 44)];
    //设置为水平镜像，因为磨人是前置，会有镜像
    [cameraView setInputRotation:kGPUImageFlipHorizonal atIndex:0];
    cameraView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:cameraView];
    self.cameraView = cameraView;

    
    //定义滤镜操作对象
    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:@"AVCaptureSessionPresetPhoto" cameraPosition:AVCaptureDevicePositionFront];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    filter = [[GPUImageBilateralFilter alloc] init];
    //操作对象添加滤镜
    [stillCamera addTarget:filter];
    //滤镜添加到相机中
    [filter addTarget:cameraView];
    //开启滤镜
    [stillCamera startCameraCapture];
    
}

-(void)switchFilter
{
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, GBWidth - 44, 44)];
    
    NSArray *btnTitle = @[@"磨皮",@"绿巨人",@"幻影",@"怀旧",@"黑白",@"像素",@"油画",@"素描",@"学轮眼"];
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*55, 0, 55, 44);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [scroller addSubview:btn];
        [btnArr addObject:btn];
        
    }
    
    UIButton *btn = btnArr[0];
    btn.selected = YES;
    scroller.contentSize = CGSizeMake(60*9, 44);
    [self.view addSubview:scroller];
}

-(void)btnAction:(UIButton *)bt
{
    for (UIButton *btn in btnArr) {
        
        if (btn.tag != bt.tag) {
            
            btn.selected = NO;
        }
    }
    
    if (!bt.selected) {
        
        bt.selected = !bt.selected;
    }
    if (bt.selected) {
        
        bt.titleLabel.font = [UIFont systemFontOfSize:17];
        
        switch (bt.tag - 100) {
            case 0:
            {
                
                [stillCamera removeTarget:filter];
                filter = [[GPUImageBilateralFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
            }
                break;

            case 1:
            {
                [stillCamera removeTarget:filter];
                filter = [[GPUImageHueFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];            }
                break;

            case 2:
            {
                [stillCamera removeTarget:filter];
                filter = [[GPUImageLowPassFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
            }
                break;

            case 3:
            {
                //
                [stillCamera removeTarget:filter];
                filter = [[GPUImageMonochromeFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
            }
                break;

            case 4:
            {
                [stillCamera removeTarget:filter];
                filter = [[GPUImageOpeningFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
            }
                break;

            case 5:
            {
                [stillCamera removeTarget:filter];
                 filter = [[GPUImagePixellateFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
                
            }
                break;

            case 6:
            {

                [stillCamera removeTarget:filter];
                filter = [[GPUImagePosterizeFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
                
           
            }
                break;

            case 7:
            {

                [stillCamera removeTarget:filter];
                filter = [[GPUImageSketchFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
                
           
            }
                break;

            case 8:
            {
                
                [stillCamera removeTarget:filter];
                filter = [[GPUImageSwirlFilter alloc] init];
                //操作对象添加滤镜
                [stillCamera addTarget:filter];
                //滤镜添加到相机中
                [filter removeTarget:cameraView];
                [filter addTarget:cameraView];
                //开启滤镜
                [stillCamera startCameraCapture];
                
             
            }
                break;

            default:
                break;
        }
    }
    

}

//定义切换摄像头按钮
- (void)setupChangeCamera
{
    UIButton *changeCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(GBWidth - 44, 0, 44, 44)];
    changeCameraBtn.titleLabel.font = [UIFont fontWithName:@"iconFont" size: 20];
    [changeCameraBtn setTitle:@"\U0000e63f" forState:UIControlStateNormal];
    [changeCameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeCameraBtn setTitleColor:GBHeightColor forState:UIControlStateHighlighted];
    changeCameraBtn.tag = 0;
    WS(weakSelf);
    [changeCameraBtn addActionBlock:^(id sender) {
        UIButton *btn = (UIButton *)sender;
        if (btn.tag == 0) {
            stillCamera.cameraPost = AVCaptureDevicePositionFront;
            btn.tag = 1;
            //前摄像头需要镜像。。
            [weakSelf.cameraView setInputRotation:kGPUImageFlipHorizonal atIndex:0];
        }else{
            stillCamera.cameraPost = AVCaptureDevicePositionBack;
            btn.tag = 0;
            //后摄像头不需要镜像
            [weakSelf.cameraView setInputRotation:kGPUImageNoRotation atIndex:0];
            
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCameraBtn];
}

//定义拍照按钮
- (void)setupTakePhotoBtn
{
    UIButton *takePhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake((GBWidth - 60 * GBScale) / 2, GBWidth + 145 * GBScale +(GBHeight - GBWidth - 205 * GBScale) / 2, 60 * GBScale, 60 * GBScale)];
    [takePhotoBtn setImage:[UIImage imageNamed:@"btn_camera_all"] forState:UIControlStateNormal];
    [takePhotoBtn setImage:[UIImage imageNamed:@"btn_camera_all_click"] forState:UIControlStateHighlighted];
    [self.view addSubview:takePhotoBtn];
    
    [takePhotoBtn addActionBlock:^(id sender) {
        
        UIButton *btn = (UIButton *)sender;
        btn.enabled = NO;
        
        [stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
            //取得的图片
            if (processedJPEG == nil) {
                return ;
            }
            
            CGFloat length =[processedJPEG length];
            CGFloat size = length/1024/1024;
            ImageModel *model = [[ImageModel alloc]init];
            model.imageName = [NSString stringWithFormat:@"%@",[NSDate date]];
            model.imageSize = [NSString stringWithFormat:@"%.1fM",size];
            model.imageData = processedJPEG;
            
            [DataBaseManager insertValueByBindVar:@[model]];
            //保存到数据库
            btn.enabled = YES;
            
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}

//取消按钮
- (void)setupCancleBtn
{
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 * GBScale, GBWidth + 180 * GBScale, 40 * GBScale, 30 * GBScale)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn setTitleColor:GBHeightColor forState:UIControlStateHighlighted];
    [self.view addSubview:cancleBtn];
    WS(weakSelf)
    [cancleBtn addActionBlock:^(id sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
}

//定义相册按钮
- (void)setupPhotoAlbumBtn
{
    UILabel *photoAlbumL = [[UILabel alloc] initWithFrame:CGRectMake(GBWidth - 60 * GBScale, GBWidth + 202 * GBScale, 40 * GBScale, 15 * GBScale)];
    photoAlbumL.textAlignment = NSTextAlignmentCenter;
    photoAlbumL.text = @"相册";
    photoAlbumL.font = [UIFont systemFontOfSize:11.f];
    photoAlbumL.textColor = [UIColor whiteColor];
//    [self.view addSubview:photoAlbumL];
    
    
    UIButton *photoAlbumBtn = [[UIButton alloc] initWithFrame:CGRectMake(GBWidth - 60 * GBScale, GBWidth + 175 * GBScale, 40 * GBScale, 40 * GBScale)];
    photoAlbumBtn.titleLabel.font = [UIFont fontWithName:@"iconFont" size: 22];
    [photoAlbumBtn setTitle:@"\U0000e640" forState:UIControlStateNormal];
    [photoAlbumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoAlbumBtn setTitleColor:GBHeightColor forState:UIControlStateHighlighted];
//    [self.view addSubview:photoAlbumBtn];
    WS(weakSelf)
    [photoAlbumBtn addActionBlock:^(id sender) {
        //打开相册
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = weakSelf;
        [weakSelf presentViewController:ipc animated:YES completion:nil];

    } forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 图片选择控制器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 2.取的图片
    UIImage *takeImage = info[UIImagePickerControllerOriginalImage];
 
    
    if (self.customCameraBlock) {
        
        self.customCameraBlock(takeImage);
    }

    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
       
    }else{
  
        [XHToast showCenterWithText:@"图片保存到相册"];
    }
    
}



//隐藏时间条
- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}

@end
