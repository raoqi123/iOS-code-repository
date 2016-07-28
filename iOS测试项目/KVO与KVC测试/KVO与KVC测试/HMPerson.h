//
//  HMPerson.h
//  KVO与KVC测试
//
//  Created by 饶齐 on 16/7/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMPerson.h"
#import "HMJob.h"

@interface HMPerson : NSObject

@property (strong,nonatomic) HMJob *job;
@property (copy,nonatomic) NSString *name;
@end
