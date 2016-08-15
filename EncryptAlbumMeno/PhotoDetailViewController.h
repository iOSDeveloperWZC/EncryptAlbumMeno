//
//  PhotoDetailViewController.h
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/8/4.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : BaseViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIImageView *tmpImageView;

@property(nonatomic,strong)NSArray *modelArr;
@end
