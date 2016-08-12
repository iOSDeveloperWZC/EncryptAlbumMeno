//
//  GBCustomCameraController.h
//  GBCustomCamera
//
//  Created by iMac on 16/7/18.
//  Copyright © 2016年 GB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

typedef void(^CustomCameraBlock)(UIImage *);

@interface GBCustomCameraController : UIViewController
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter, *secondFilter, *terminalFilter;
    
    GPUImagePicture *memoryPressurePicture1, *memoryPressurePicture2;
}

@property (nonatomic , copy) CustomCameraBlock customCameraBlock;

@end
