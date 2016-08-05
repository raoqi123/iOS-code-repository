//
//  ViewController.m
//  蓝牙测试iBeacon3
//
//  Created by 饶齐 on 16/8/4.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.5);
    self.textView = textView;
    [self.view addSubview:self.textView];
    textView.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"%s",__func__);
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
