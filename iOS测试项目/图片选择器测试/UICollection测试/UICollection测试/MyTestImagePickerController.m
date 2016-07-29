//
//  MyTestImagePickerController.m
//  UICollection测试
//
//  Created by 饶齐 on 16/7/25.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "MyTestImagePickerController.h"

@interface MyTestImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation MyTestImagePickerController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 通过代码构建按钮
    UIButton *pickerImageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pickerImageBtn.frame = CGRectMake(100, 100, 100, 100);
    [pickerImageBtn setTitle:@"打开相册" forState:UIControlStateNormal];
    //指定单击事件
    [pickerImageBtn addTarget:self action:@selector(openImage)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerImageBtn];
    pickerImageBtn.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    self.imageView = imgView;
    [self.view addSubview:imgView];
    imgView.frame  = CGRectMake(100, 210, 100, 100);
    imgView.backgroundColor = [UIColor lightGrayColor];
}

/*
 点击按钮后的事件
 */
-(void)openImage
{
    
    //构建图像选择器
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    //设置代理为本身（实现了UIImagePickerControllerDelegate协议）
    pickerController.delegate = self;
    //是否允许对选中的图片进行编辑
    pickerController.allowsEditing = YES;
    
    //设置图像来源类型(先判断系统中哪种图像源是可用的)
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else {
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    //打开模态视图控制器选择图像
    [self presentModalViewController:pickerController animated:YES];
}



#pragma Delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(editedImage:) withObject:image afterDelay:.5];
}

/*
 选取成功后在界面上进行显示
 */
-(void)editedImage:(UIImage *)image
{
    NSLog(@"选择成功");
    [self.imageView setImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选择");
    [picker dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



@end
