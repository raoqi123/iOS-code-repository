//
//  ViewController.m
//  KVO与KVC测试
//
//  Created by 饶齐 on 16/7/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ViewController.h"
#import "HMPerson.h"
#import "HMJob.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self test1];
    
    //[self test2];
    
    [self test3];
}
-(void)test1
{
    HMPerson *person = [[HMPerson alloc] init];
    
    //一定要person添加观察者
    [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxx"];

    
    [person setValue:@"raoqi" forKeyPath:@"name"];
    
    [person removeObserver:self forKeyPath:@"name"];
}

-(void)test2
{
    HMPerson *person = [[HMPerson alloc] init];
    
    //一定要person添加观察者
    [person addObserver:self forKeyPath:@"job" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxx"];
    
    
    [person setValue:nil forKeyPath:@"job"];
    
    [person removeObserver:self forKeyPath:@"job"];
}

/**
 *  kvc+kvo也适合多级路径，但是有个前提(我一直犯这个错)->person.job一定要有值，不能为nil，否则无效
 */
-(void)test3
{
    HMPerson *person = [[HMPerson alloc] init];
    //job一定要实现赋值
    person.job = [[HMJob alloc] init];
    
    //一定要person添加观察者
    [person addObserver:self forKeyPath:@"job.money" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxx"];
    
    
    [person setValue:@123 forKeyPath:@"job.money"];
    
    [person removeObserver:self forKeyPath:@"job.money"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@",[object class]);
    NSLog(@"%@ %@ %@",change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey],context);
}
























@end
