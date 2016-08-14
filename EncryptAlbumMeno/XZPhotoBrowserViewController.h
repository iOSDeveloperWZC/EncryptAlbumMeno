//
//  XZPhotoBrowserViewController.h
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/8/4.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface XZPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGRect finalCellRect;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@end
