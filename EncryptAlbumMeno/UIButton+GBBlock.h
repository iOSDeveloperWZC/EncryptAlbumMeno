//
//  UIButton+GBBlock.h
//  GBCustomCamera
//
//  Created by iMac on 16/7/18.
//  Copyright © 2016年 GB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GBBlock)
- (void)addActionBlock:(void(^)(id sender))block forControlEvents:(UIControlEvents )event;
@end
