//
//  PhotoDetailViewController.m
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/8/4.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "PhotoDetailItem.h"
#import "XZPhotoBrowserViewController.h"
#import "XZPhotoBrowserPopTransition.h"

@interface PhotoDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatNavAndStateView];
    [self creatLeftBtn];
    [self creatRight];
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePanGestureRecognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
    
    [self.collectionView registerClass:[PhotoDetailItem class] forCellWithReuseIdentifier:@"identifier"];
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentOffset = CGPointMake(self.view.frame.size.width * self.selectIndex, 0);
    [self initTmpImageView:self.selectIndex];
}

-(void)creatRight
{
    
    UIButton *rightButton;
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(GBWidth - 100, 20 + 7, 100, 30);
    [rightButton setTitle:@"保存至本地" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navAndStateView addSubview:rightButton];
    
    UIButton *centerButton;
    centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton setTitle:@"删除" forState:UIControlStateNormal];
    centerButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [centerButton addTarget:self action:@selector(deletAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navAndStateView addSubview:centerButton];
    
    [centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.navAndStateView.centerX);
        make.centerY.mas_equalTo(self.navAndStateView.centerY).mas_offset(10);
    }];
    
}


-(void)deletAction:(UIButton *)btn
{
  
    if ([DataBaseManager deleteImage:@[_modelArr[self.selectIndex]]]) {
        
        [XHToast showCenterWithText:@"删除成功"];
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    else
    {
        [XHToast showCenterWithText:@"删除失败"];
    }
}
-(void)submitAction:(UIButton *)button
{
    UIImageWriteToSavedPhotosAlbum(self.dataArray[_index.row], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)initTmpImageView:(NSInteger)index
{
    self.tmpImageView.image = self.dataArray[index];
    CGFloat w = self.view.frame.size.width - 10;
    CGFloat h = [self getImageHeight:self.tmpImageView.image width:w];
    self.tmpImageView.frame = CGRectMake(5, (self.view.frame.size.height - 64 - h) / 2.0, w, h);
}

-(void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        }else{
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[XZPhotoBrowserPopTransition class]]) {
        return self.percentDrivenTransition;
    }else{
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    XZPhotoBrowserPopTransition *pop = [[XZPhotoBrowserPopTransition alloc] init];
    return pop;
}

- (CGFloat)getImageHeight:(UIImage *)image width:(CGFloat)width
{
    float integerW = image.size.width;
    float integerH = image.size.height;
    float scale = width / integerW;
    NSNumber *number = [NSNumber numberWithFloat:scale * integerH];
    return [number floatValue];
}

- (UIImageView *)tmpImageView
{
    if (!_tmpImageView) {
        _tmpImageView = [UIImageView new];
        [self.view addSubview:_tmpImageView];
        _tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tmpImageView.alpha = 0;
    }
    return _tmpImageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.selectIndex = scrollView.contentOffset.x / self.view.frame.size.width;
    
    [self initTmpImageView:self.selectIndex];
}

#pragma mark --- 代理方法
// 设置分区内视图个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
// 设置视图cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoDetailItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    _index = indexPath;
    cell.detailImageView.image = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        
    }else{
        
        [XHToast showCenterWithText:@"图片保存到相册"];
    }
    
}

// 设置分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", (long)indexPath.row);
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // item尺寸
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width - 10, self.view.frame.size.height - 64);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[];
    }
    return _dataArray;
}

@end
