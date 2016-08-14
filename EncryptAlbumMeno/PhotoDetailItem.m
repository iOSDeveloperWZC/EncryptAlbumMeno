//
//  PhotoDetailItem.m
//  XZPhotoBrowser
//
//  Created by 徐洋 on 16/8/4.
//  Copyright © 2016年 徐洋. All rights reserved.
//

#import "PhotoDetailItem.h"

@implementation PhotoDetailItem
{
    CGFloat lastScale;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.detailImageView = [UIImageView new];
        [self.contentView addSubview:self.detailImageView];
        self.detailImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.detailImageView.userInteractionEnabled = YES;
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scan:)];
        [pinchRecognizer setDelegate:self];
        [self.detailImageView addGestureRecognizer:pinchRecognizer];
        lastScale = 1.0;
        
        UITapGestureRecognizer *tapImgViewTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgViewHandleTwice:)];
        tapImgViewTwice.numberOfTapsRequired = 2;
        tapImgViewTwice.numberOfTouchesRequired = 1;
        [self.detailImageView addGestureRecognizer:tapImgViewTwice];

    }
    return self;
}

-(void)tapImgViewHandleTwice:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.5 animations:^{
        self.detailImageView.transform = CGAffineTransformIdentity;
    }];
    
}

-(void)scan:(UIGestureRecognizer *)ges
{
    
    if([(UIPinchGestureRecognizer*)ges state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)ges scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)ges view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [[(UIPinchGestureRecognizer*)ges view]setTransform:newTransform];
    lastScale = [(UIPinchGestureRecognizer*)ges scale];
    
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.detailImageView.frame = self.contentView.frame;
}

@end
