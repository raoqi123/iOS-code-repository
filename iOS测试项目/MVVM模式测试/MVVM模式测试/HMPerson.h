//
//  HMPerson.h
//  MVVM模式测试
//
//  Created by 饶齐 on 16/7/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPerson : NSObject

@property (copy,nonatomic) NSString *firstName;
@property (copy,nonatomic) NSString *lastName;

+(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;

@end
