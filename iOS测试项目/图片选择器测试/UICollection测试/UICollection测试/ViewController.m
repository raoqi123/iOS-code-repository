//
//  ViewController.m
//  UICollection测试
//
//  Created by 饶齐 on 16/7/21.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ViewController.h"
#import "UIView+HM.h"

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) NSMutableArray* dataArray;
@property (strong,nonatomic) UICollectionView * collectionView;
//@property (strong,nonatomic) UICollectionViewLayout *customLayout;
@end

@implementation ViewController
-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray arrayWithObjects:@"红包", @"转账", @"手机充值", @"美团外卖",
                      @"大象", @"啦啦啦", @"美团团购", @"世界那么大",
                      @"我要去看看",  @"哈哈",@"红包1", @"转账1", @"手机充值1",
                       @"世界那么大1",nil];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.定义流式布局，可修改布局属性来达到修改布局的目的
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    /**
     设置headerView的size一定要结合scrollDirection来使用
     垂直移动时，headerView的width设置无效，实际width始终和屏幕宽一样
     水平移动时，headerView的height设置无效，实际height始终和屏幕宽一样
     headerView 和 footerView属于layout的附加控件
     设置了headerReferenceSize和footerReferenceSize 并实现了collectionView: viewForSupplementaryElementOfKind: atIndexPath:方法 就可以让headerView，footerView在屏幕中显示出来
     */
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //[layout setHeaderReferenceSize:CGSizeMake(50, 50)];
    //[layout setFooterReferenceSize:CGSizeMake(50, 50)];
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width/2, 5);
    //layout.headerReferenceSize = CGSizeMake(50, self.view.frame.size.height);
    //layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width/2, 5);
    
    //2.定义collectionView
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = colView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    
    //3.collectionView 用到的cell必须先注册才能使用
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    //4.设置代理
    colView.delegate = self;  //包含了UICollectionView的代理和UICollectionViewFlowLayout的代理
    colView.dataSource = self;//数据源代理
    
    //5.添加手势,支持移动cell
    //拖移，慢速移动手势
    UIPanGestureRecognizer   *_longPress = [[UIPanGestureRecognizer   alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionView addGestureRecognizer:_longPress];
    
    
}
#pragma mark - 手势方法
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
                
                //开始移动，记录移动开始位置
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //移动过程，更新最终移动位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            //结束移动
            [self.collectionView endInteractiveMovement];
            break;
        }
        default: [self.collectionView cancelInteractiveMovement];
            break;
    }
}


#pragma mark - layout代理方法
/**
 *  方法1:返回每个cell的size,也可以。通过layout.itemSize 直接设置
 *
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

/**
 *  方法2:返回每个section内部的元素与4个边界的距离
 *
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 30, 40);
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

/**
 *  方法5:设置headerView的size
 *
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width/2, 10);
}

/**
 *  方法6:设置footerView的size
 *
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width/2, 10);
}


#pragma mark - 数据源方法
/**
 *  方法1:返回section个数
 *
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

/**
 *  方法2:返回每个cell的View
 *
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    
    for(UIView *subView in cell.subviews)
    {
        if([subView isKindOfClass:[UIButton class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = cell.bounds;
    NSString *title = [NSString stringWithFormat:@"%ld:%@",indexPath.section,self.dataArray[indexPath.row]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    //禁用btn的点击事件，因为会跟cell的长按出现菜单事件冲突
    btn.userInteractionEnabled = NO;
    [cell addSubview:btn];
    
    
    //cell的frame或size不应该在这里设置
    //在这设置会出现cell点击没反应等错误
    //cell.frame = CGRectMake(200, 200, 100, 20);
    //cell.size = CGSizeMake(100, 50);
    
    //cell.selectedBackgroundView = btn;

    
    return cell;
}

/**
 *  方法3:返回每个section中cell的个数
 *
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

/**
 *  方法4:返回headerView和footerView
 *
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
        
        headerView.backgroundColor = [UIColor redColor];
        
        return headerView;
        
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor blueColor];
        return footerView;
        
    }
    
    return nil;
    

}

/**
 *  方法5:(iOS9)当前cell是否可以移动
 *
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

/**
 *  方法6:(iOS9)实现了此方法(空实现也行)就可以达到长按移动按钮的效果，不过最终内容是否真的改变了，还需要自己在方法内实现对应代码
 *  代码很简单，只需要调换数组内容，并且重载collectionView即可。
 *  只能实现一个section中的cell互相移动。
 */
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [collectionView reloadData];
}




#pragma mark - 代理方法
/**
 *  函数1:当cell被选中时，是否高亮
 *
 *  @return (不实现该方法时)默认返回YES
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 *  函数2:当cell高亮时，需要做什么？如果函数1返回NO，该函数无效。
 *
 */
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"high %@",indexPath);
}

//函数3，作用不明.函数2调用时，它也会调用
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"unhigh %@",indexPath);
}

/**
 *  函数4:点击某个cell，判断是否应该选中这个cell。
 *
 *  @return (不实现该方法时)默认返回YES
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%s %@",__func__,indexPath);
    return YES;
}

//函数5，作用不明
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%s %@",__func__,indexPath);
    return YES;
}

/**
 *  函数6:点击一个cell，cell被选中后调用
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@",indexPath);
}

//函数7，作用不明
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@",indexPath);
}

/**
 *  函数8:在即将显示某个cell时调用
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@ ",indexPath);
}

/**
 *  函数9:在即将显示headerView或footerView时调用
 *
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@ %@",indexPath,elementKind);
}

/**
 *  函数10:在某个cell消失后调用
 *  但是这个函数貌似调用不全，并不是每个cell消失都一定会调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@",indexPath);
}

/**
 *  函数11:在某个SupplementaryView即将消失时调用
 *  这个函数在每个SupplementaryView消失时都调用了
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@ %@",indexPath,elementKind);
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
//    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]
//        || [NSStringFromSelector(action) isEqualToString:@"paste:"])
//        return YES;
//    return NO;
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
        self.dataArray[indexPath.row] = @"be cut";
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
    NSLog(@"%@ %@",NSStringFromSelector(action),indexPath);
}

//函数15-21包含：转场布局，动画等新特性，所以暂时没有深入去了解。
//15- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout;

//16- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
//17- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0);
//18- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0);
//19- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView NS_AVAILABLE_IOS(9_0);

//20- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0);
//
//21- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset



























@end
