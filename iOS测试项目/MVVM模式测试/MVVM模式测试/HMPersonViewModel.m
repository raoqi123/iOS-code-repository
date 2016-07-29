//
//  HMPersonViewModel.m
//  MVVM模式测试
//
//  Created by 饶齐 on 16/7/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "HMPersonViewModel.h"
#import "HMPerson.h"

@implementation HMPersonViewModel

+(instancetype)initWithPerson:(HMPerson *)person
{
    HMPersonViewModel *personViewModel = [[HMPersonViewModel alloc] init];
    personViewModel.person = person;
    personViewModel.fullNameLabelText = [NSString stringWithFormat:@"%@:%@",person.firstName,person.lastName];
    
    return personViewModel;
}

+(instancetype)personViewModel
{
    HMPerson *person = [[HMPerson alloc] init];
    person.firstName = @"Jim";
    person.lastName = @"Green";
    
    return [self initWithPerson:person];
}

@end
