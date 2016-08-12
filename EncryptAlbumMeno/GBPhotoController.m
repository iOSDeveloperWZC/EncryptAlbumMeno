//
//  GBPhotoController.m
//  GBCustomCamera
//
//  Created by iMac on 16/7/20.
//  Copyright © 2016年 GB. All rights reserved.
//

#import "GBPhotoController.h"

@implementation GBPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatNavAndStateView];
    [self creatLeftBtn];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, GBWidth, GBWidth * self.image.size.height / self.image.size.width)];
    imageView.image = self.image;
    [self.view addSubview:imageView];
    
}


@end
