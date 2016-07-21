//
//  UIBarButtonItem+HM.m
//  SinaWeibo1
//
//  Created by 饶齐 on 16/7/17.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "UIBarButtonItem+HM.h"
#import "UIView+HM.h"

@implementation UIBarButtonItem (HM)

+(UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    btn.size = btn.currentBackgroundImage.size;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return item;
}

@end
