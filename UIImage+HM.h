//
//  UIImage+HM.h
//  SinaWeibo1
//
//  Created by 饶齐 on 16/7/17.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HM)


//让图片保持原样，不会被ios再次渲染
+(UIImage*)imageWithOriginRender:(NSString*)imageName;

@end
