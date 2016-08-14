//
//  XZPhotoBrowserViewController.m
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/8/4.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import "XZPhotoBrowserViewController.h"
#import "XZPhotoBrowserItem.h"
#import "XZPhotoBrowserFlowLayout.h"
#import "PhotoDetailViewController.h"
#import "XZPhotoBrowserPushTransition.h"
#import "XZPhotoBrowserModel.h"
#import "ImageModel.h"
#import "PHImageManager+CTAssetsPickerController.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <CTAssetsPickerController/CTAssetCollectionViewCell.h>
#import <CTAssetsPickerController/CTAssetsGridView.h>
#import <CTAssetsPickerController/CTAssetsGridViewFooter.h>
#import <CTAssetsPickerController/CTAssetsGridViewCell.h>
#import <CTAssetsPickerController/CTAssetsGridSelectedView.h>
#import <CTAssetsPickerController/CTAssetCheckmark.h>
#import <CTAssetsPickerController/CTAssetSelectionLabel.h>
#import <CTAssetsPickerController/CTAssetsPageView.h>
#define tableViewRowHeight 80.0f
@interface XZPhotoBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *identifierDic;

@property (nonatomic, strong) XZPhotoBrowserFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSMutableArray *plistArray;
@property(nonatomic,strong)NSMutableArray *assets;


@property (nonatomic, strong) UIColor *color1;
@property (nonatomic, strong) UIColor *color2;
@property (nonatomic, strong) UIColor *color3;
@property (nonatomic, strong) UIFont *font;

@end

static NSString *identifier = @"identifierCell";

@implementation XZPhotoBrowserViewController
{
    NSMutableArray *array;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor= RGB(0,134.0,207.0);
    [self creatRightBtn];
    [self.collectionView registerClass:[XZPhotoBrowserItem class] forCellWithReuseIdentifier:identifier];
    self.identifierDic = [NSMutableDictionary dictionary];
    [self.view addSubview:self.collectionView];
    
    //    self.color1 = [UIColor colorWithRed:102.0/255.0 green:161.0/255.0 blue:130.0/255.0 alpha:1];
    self.color1 = RGB(0,134.0,207.0);
    self.color2 = [UIColor whiteColor];
    //    self.color3 = [UIColor colorWithWhite:0.9 alpha:1];
    self.color3 = [UIColor whiteColor];
    self.font   = [UIFont fontWithName:@"Futura-Medium" size:18.0];
    
    // Navigation Bar apperance
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]];
    
    // set nav bar style to black to force light content status bar style
    navBar.barStyle = UIBarStyleBlack;
    
    // bar tint color
    navBar.barTintColor = self.color1;
    
    // tint color
    navBar.tintColor = self.color2;
    
    // title
    navBar.titleTextAttributes =
    @{NSForegroundColorAttributeName: self.color2,
      NSFontAttributeName : self.font};
    
//    // bar button item appearance
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]];
    [barButtonItem setTitleTextAttributes:@{NSFontAttributeName : [self.font fontWithSize:18.0]}
                                 forState:UIControlStateNormal];
    
    // albums view
    UITableView *assetCollectionView = [UITableView appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]];
    assetCollectionView.backgroundColor = self.color2;
    
    // asset collection appearance
    CTAssetCollectionViewCell *assetCollectionViewCell = [CTAssetCollectionViewCell appearance];
    assetCollectionViewCell.titleFont = [self.font fontWithSize:16.0];
    assetCollectionViewCell.titleTextColor = self.color1;
    assetCollectionViewCell.selectedTitleTextColor = self.color2;
    assetCollectionViewCell.countFont = [self.font fontWithSize:12.0];
    assetCollectionViewCell.countTextColor = self.color1;
    assetCollectionViewCell.selectedCountTextColor = self.color2;
    assetCollectionViewCell.accessoryColor = self.color1;
    assetCollectionViewCell.selectedAccessoryColor = self.color2;
    assetCollectionViewCell.backgroundColor = self.color3;
    assetCollectionViewCell.selectedBackgroundColor = [self.color1 colorWithAlphaComponent:0.4];
    
    // grid view
    CTAssetsGridView *assetsGridView = [CTAssetsGridView appearance];
    assetsGridView.gridBackgroundColor = self.color3;
    
    // assets grid footer apperance
    CTAssetsGridViewFooter *assetsGridViewFooter = [CTAssetsGridViewFooter appearance];
    assetsGridViewFooter.font = [self.font fontWithSize:16.0];
    assetsGridViewFooter.textColor = self.color2;
    
    // grid view cell
    CTAssetsGridViewCell *assetsGridViewCell = [CTAssetsGridViewCell appearance];
    assetsGridViewCell.highlightedColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    // selected grid view
    CTAssetsGridSelectedView *assetsGridSelectedView = [CTAssetsGridSelectedView appearance];
    assetsGridSelectedView.selectedBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    assetsGridSelectedView.tintColor = self.color1;
    assetsGridSelectedView.borderWidth = 3.0;
    
    // check mark
    CTAssetCheckmark *checkmark = [CTAssetCheckmark appearance];
    checkmark.tintColor = self.color1;
    [checkmark setMargin:0.0 forVerticalEdge:NSLayoutAttributeRight horizontalEdge:NSLayoutAttributeTop];
    
    // selection label
    CTAssetSelectionLabel *assetSelectionLabel = [CTAssetSelectionLabel appearance];
    assetSelectionLabel.borderWidth = 1.0;
    assetSelectionLabel.borderColor = self.color3;
    [assetSelectionLabel setSize:CGSizeMake(24.0, 24.0)];
    [assetSelectionLabel setCornerRadius:12.0];
    [assetSelectionLabel setMargin:4.0 forVerticalEdge:NSLayoutAttributeRight horizontalEdge:NSLayoutAttributeTop];
    [assetSelectionLabel setTextAttributes:@{NSFontAttributeName : [self.font fontWithSize:12.0],
                                             NSForegroundColorAttributeName : self.color3,
                                             NSBackgroundColorAttributeName : self.color1}];
    
    // page view (preview)
    CTAssetsPageView *assetsPageView = [CTAssetsPageView appearance];
    assetsPageView.pageBackgroundColor = self.color3;
    assetsPageView.fullscreenBackgroundColor = self.color2;
    
    // progress view
    [UIProgressView appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]].tintColor = self.color1;
    
    [self initData];
    
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

}

-(void)initData
{
    
    NSArray *modelArr = [DataBaseManager queryValueFormTable];
    
    [self.dataArray addObjectsFromArray:modelArr];
     array = @[].mutableCopy;
    for (NSInteger index = 0; index < self.dataArray.count; index ++) {
        ImageModel *model = self.dataArray[index];
        UIImage *image = [UIImage imageWithData:model.imageData];
        [array addObject:image];
    }
    self.flowLayout.images = array;
    [self.collectionView reloadData];
}

-(void)reLoadData
{
    [self.dataArray removeAllObjects];
    [array removeAllObjects];
    
    NSArray *modelArr = [DataBaseManager queryValueFormTable];
    
    [self.dataArray addObjectsFromArray:modelArr];
    array = @[].mutableCopy;
    for (NSInteger index = 0; index < self.dataArray.count; index ++) {
        ImageModel *model = self.dataArray[index];
        UIImage *image = [UIImage imageWithData:model.imageData];
        [array addObject:image];
    }
    self.flowLayout.images = array;
    [self.collectionView reloadData];

}

-(void)creatRightBtn
{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    lable.textColor = [UIColor whiteColor];
    lable.adjustsFontSizeToFitWidth = YES;
    
    lable.font = [UIFont systemFontOfSize:17];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"图库";
    self.navigationItem.titleView = lable;
    UIButton *rightButton;
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(GBWidth - 80, 20 + 7, 80, 30);
    [rightButton setTitle:@"相册导入" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton *leftButton;
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 20 + 7, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"back_arrow@2x.png"]  forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
}


-(void)leftButtonAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 从相册导入
-(void)submitButtonAction:(UIButton *)button
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            
            // to present picker as a form sheet in iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
            
        });
    }];

}

#pragma mark - 从图库选择之后
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    
    
    //选择的到的照片
    
    PHImageManager *manager = [PHImageManager defaultManager];
//    CGFloat scale = UIScreen.mainScreen.scale;
    
//    CGSize targetSize = CGSizeMake(tableViewRowHeight * scale, tableViewRowHeight * scale);
    for (NSInteger i = 0; i < self.assets.count; i++) {
        
//        PHAsset *asset = [self.assets objectAtIndex:i];
        [manager ctassetsPickerRequestImageForAsset:self.assets[i]
                                         targetSize:PHImageManagerMaximumSize
                                        contentMode:PHImageContentModeAspectFill
                                            options:self.requestOptions
                                      resultHandler:^(UIImage *image, NSDictionary *info){
                                          
                                          if (image == nil) {
                                              return ;
                                          }
                                          NSData *imageData = UIImageJPEGRepresentation(image, 0);
                                          ImageModel *model = [[ImageModel alloc]init];
                                          model.imageName = [NSString stringWithFormat:@"%@",[NSDate date]];
                                          
                                          CGFloat length =[imageData length];
                                          CGFloat size = length/1024/1024;
                                          model.imageSize = [NSString stringWithFormat:@"%.1fM",size];
                                          model.imageData = imageData;
                                          //
                                          [DataBaseManager insertValueByBindVar:@[model]];
                                          //保存到数据库
                                          [self reLoadData];
                                      }];
    }

}


#pragma mark --- 代理方法
// 设置分区内视图个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return array.count;
}
// 设置视图cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *fier = [self.identifierDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (fier == nil) {
        fier = [NSString stringWithFormat:@"XZPhotoBrowser%@", indexPath];
        [self.identifierDic setValue:fier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [self.collectionView registerClass:[XZPhotoBrowserItem class] forCellWithReuseIdentifier:fier];
    }
    XZPhotoBrowserItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:fier forIndexPath:indexPath];
    

    cell.photo.image = array[indexPath.row];
    return cell;
}
// 设置分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoDetailViewController *detail = [[PhotoDetailViewController alloc] init];
    
    detail.dataArray = array;
    
    detail.selectIndex = indexPath.row;

    [self presentViewController:detail animated:NO completion:nil];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (XZPhotoBrowserFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[XZPhotoBrowserFlowLayout alloc] init];
        _flowLayout.images = array;
        _flowLayout.xzColumnsCount = 3;
    }
    return _flowLayout;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray *)plistArray
{
    if (!_plistArray) {
        _plistArray = [NSMutableArray array];
    }
    return _plistArray;
}

- (void)dealloc
{
    // reset appearance
    // for demo purpose. it is not necessary to reset appearance in real case.
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]];
    
    navBar.barStyle = UIBarStyleDefault;
    
    navBar.barTintColor = nil;
    
    navBar.tintColor = nil;
    
    navBar.titleTextAttributes = nil;
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]];
    [barButtonItem setTitleTextAttributes:nil
                                 forState:UIControlStateNormal];
    
    UITableView *assetCollectionView = [UITableView appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]];
    assetCollectionView.backgroundColor = [UIColor whiteColor];
    
    CTAssetCollectionViewCell *assetCollectionViewCell = [CTAssetCollectionViewCell appearance];
    assetCollectionViewCell.titleFont = nil;
    assetCollectionViewCell.titleTextColor = nil;
    assetCollectionViewCell.selectedTitleTextColor = nil;
    assetCollectionViewCell.countFont = nil;
    assetCollectionViewCell.countTextColor = nil;
    assetCollectionViewCell.selectedCountTextColor = nil;
    assetCollectionViewCell.accessoryColor = nil;
    assetCollectionViewCell.selectedAccessoryColor = nil;
    assetCollectionViewCell.backgroundColor = nil;
    assetCollectionViewCell.selectedBackgroundColor = nil;
    
    CTAssetsGridView *assetsGridView = [CTAssetsGridView appearance];
    assetsGridView.gridBackgroundColor = nil;
    
    CTAssetsGridViewFooter *assetsGridViewFooter = [CTAssetsGridViewFooter appearance];
    assetsGridViewFooter.font = nil;
    assetsGridViewFooter.textColor = nil;
    
    CTAssetsGridViewCell *assetsGridViewCell = [CTAssetsGridViewCell appearance];
    assetsGridViewCell.highlightedColor = nil;
    
    CTAssetsGridSelectedView *assetsGridSelectedView = [CTAssetsGridSelectedView appearance];
    assetsGridSelectedView.selectedBackgroundColor = nil;
    assetsGridSelectedView.tintColor = nil;
    assetsGridSelectedView.borderWidth = 0.0;
    
    CTAssetCheckmark *checkmark = [CTAssetCheckmark appearance];
    checkmark.tintColor = nil;
    [checkmark setMargin:0.0 forVerticalEdge:NSLayoutAttributeRight horizontalEdge:NSLayoutAttributeBottom];
    
    CTAssetSelectionLabel *assetSelectionLabel = [CTAssetSelectionLabel appearance];
    assetSelectionLabel.borderWidth = 0.0;
    assetSelectionLabel.borderColor = nil;
    [assetSelectionLabel setSize:CGSizeZero];
    [assetSelectionLabel setCornerRadius:0.0];
    [assetSelectionLabel setMargin:0.0 forVerticalEdge:NSLayoutAttributeRight horizontalEdge:NSLayoutAttributeBottom];
    [assetSelectionLabel setTextAttributes:nil];
    
    CTAssetsPageView *assetsPageView = [CTAssetsPageView appearance];
    assetsPageView.pageBackgroundColor = nil;
    assetsPageView.fullscreenBackgroundColor = nil;
    
    [UIProgressView appearanceWhenContainedInInstancesOfClasses:@[[CTAssetsPickerController class]]].tintColor = nil;
}


@end
