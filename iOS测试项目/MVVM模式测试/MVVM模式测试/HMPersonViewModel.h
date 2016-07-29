//
//  HMPersonViewModel.h
//  MVVM模式测试
//
//  Created by 饶齐 on 16/7/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMPerson;

@interface HMPersonViewModel : NSObject

@property (strong,nonatomic) HMPerson *person;
@property (copy,nonatomic) NSString *fullNameLabelText;

+(instancetype)initWithPerson:(HMPerson*)person;
+(instancetype)personViewModel;
@end
