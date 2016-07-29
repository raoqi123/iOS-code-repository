//
//  ViewController.m
//  MVVM模式测试
//
//  Created by 饶齐 on 16/7/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ViewController.h"
#import "HMPerson.h"
#import "HMPersonViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong,nonatomic) HMPersonViewModel *personViewModel;
@end

@implementation ViewController
-(HMPersonViewModel *)personViewModel
{
    if(_personViewModel == nil)
    {
        _personViewModel = [HMPersonViewModel personViewModel];
    }
    return _personViewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.fullNameLabel.text = self.personViewModel.fullNameLabelText;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end













