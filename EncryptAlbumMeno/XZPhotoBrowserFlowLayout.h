//
//  XZPhotoBrowserFlowLayout.h
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/7/30.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZPhotoBrowserFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) NSArray <UIImage *> *images;

@property (nonatomic, assign) NSUInteger xzColumnsCount;

@end
