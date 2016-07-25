//
//  UIImage+HM.m
//  SinaWeibo1
//
//  Created by 饶齐 on 16/7/17.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "UIImage+HM.h"

@implementation UIImage (HM)

+(UIImage *)imageWithOriginRender:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
}

@end
