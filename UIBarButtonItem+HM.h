//
//  UIBarButtonItem+HM.h
//  SinaWeibo1
//
//  Created by 饶齐 on 16/7/17.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HM)

+(UIBarButtonItem*)itemWithImageName:(NSString*)imageName highImageName:(NSString*)highImageName target:(id)target action:(SEL)action;

@end
