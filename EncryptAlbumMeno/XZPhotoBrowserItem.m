//
//  XZPhotoBrowserItem.m
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/7/30.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import "XZPhotoBrowserItem.h"

@implementation XZPhotoBrowserItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.photo = [UIImageView new];
        [self.contentView addSubview:self.photo];
//        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.photo.frame = self.contentView.frame;
}

@end
