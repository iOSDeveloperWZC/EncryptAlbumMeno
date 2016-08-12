//
//  ImageModel.h
//  EncryptAlbumMeno
//
//  Created by ataw on 16/8/12.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,copy)NSString *imageSize;
@property(nonatomic,strong)NSData *imageData;
@end
