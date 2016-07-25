//
//  MyViewController.m
//  UICollection测试
//
//  Created by 饶齐 on 16/7/25.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "MyViewController.h"
#import "TZImagePickerController.h"
#import "UIView+HM.h"

@interface MyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>

@property (strong,nonatomic) NSMutableArray *photoList;

@property (weak,nonatomic) UICollectionView *collectionView;

//长按cell，出现菜单。点击copy时，复制到的图片。
@property (weak,nonatomic) UIImage *copyImg;

@end

@implementation MyViewController

-(UIImage *)copyImg
{
    if(_copyImg == nil)
    {
        _copyImg = [UIImage imageNamed:@"1"];
    }
    return _copyImg;
}

-(NSMutableArray *)photoList
{
    if(_photoList == nil)
    {
        _photoList = [NSMutableArray array];
    }
    return _photoList;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addPhotoChooseBtn];
    
    [self addCollectionView];
    
    //添加手势
    [self addGesture];
    
}

-(void)addGesture
{
    //5.添加手势,支持移动cell
    //拖移，慢速移动手势
    UIPanGestureRecognizer *panGesture= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    
    [self.view addGestureRecognizer:panGesture];
}
-(void)panGesture:(UIPanGestureRecognizer*)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[pan locationInView:self.collectionView]];
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        
        [self.collectionView updateInteractiveMovementTargetPosition:[pan locationInView:self.collectionView]];
    }
    else if(pan.state == UIGestureRecognizerStateEnded)
    {
        [self.collectionView endInteractiveMovement];
    }
    else if(pan.state == UIGestureRecognizerStateCancelled)
    {
        [self.collectionView cancelInteractiveMovement];
    }
}

//添加图片显示的UICollectionView
-(void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, screenW, screenH-100) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
}

//添加选择图片按钮
-(void)addPhotoChooseBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(didClickPhotoChooseBtn) forControlEvents:UIControlEventTouchUpInside];
}

//按钮点击事件
-(void)didClickPhotoChooseBtn
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray *photos, NSArray *assets) {
        NSLog(@"%@",photos);
        
        [self.photoList addObjectsFromArray:photos];
        //刷新图片
        [self.collectionView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //cell有可能已经有了UIImageView
    for(UIView *view in cell.subviews)
    {
        if([view isKindOfClass:[UIImageView class]] && view.tag == 100)
        {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = self.photoList[indexPath.row];
    imgView.frame  = CGRectMake(5, 5, 90, 90);
    imgView.tag = 100;
    
    [cell addSubview:imgView];
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - layout代理方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

/**
 *  方法3:返回cell间的最小行间距
 *
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    return 20;
}
/**
 *  方法4:返回cell间的最小列间距
 *
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

#pragma mark - 代理方法
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"%s",__func__);
    [self.photoList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    [collectionView reloadData];
}

/**
 *  函数12:长按cell的时候出现可以出现菜单，这个菜单是由UIMenuController实现的，它包含了剪切、拷贝、粘贴、删除等等操作，
 *  要实现这个菜单，必须实现函数12，13，14这三个方法
 *
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 *  函数13:当长按cell时，应该对哪些操作进行响应。
 *  可按下面代码实现只对指定的操作进行响应
 *
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    return YES;
}

/**
 *  函数14:具体对于某个操作应该执行哪些代码，需要在本函数内实现。
 *
 */
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"cut:"])
    {
        NSLog(@"1");
        self.photoList[indexPath.row] = [UIImage imageNamed:@"1"];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
    else if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        NSLog(@"2");
        self.copyImg = self.photoList[indexPath.row];
    }
    else if ([NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        NSLog(@"3");
        self.photoList[indexPath.row] = self.copyImg;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
    NSLog(@"%@ %@",NSStringFromSelector(action),indexPath);
}























@end


