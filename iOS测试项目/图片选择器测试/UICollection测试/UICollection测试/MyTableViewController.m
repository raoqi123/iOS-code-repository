//
//  MyTableViewController.m
//  UICollection测试
//
//  Created by 饶齐 on 16/7/25.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyViewController.h"
#import "MyTestImagePickerController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = indexPath.row==0? @"UIImagePickerController测试":@"UICollectionView+TZImageManager框架测试";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        //UICollectionView ＋ TZImageManager
        MyViewController *vc = [[MyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //UIImagePickerController
        MyTestImagePickerController *vc = [[MyTestImagePickerController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}














@end
