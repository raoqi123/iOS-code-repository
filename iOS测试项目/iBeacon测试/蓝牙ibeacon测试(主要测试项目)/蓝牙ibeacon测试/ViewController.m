//
//  ViewController.m
//  蓝牙ibeacon测试
//
//  Created by 饶齐 on 16/8/4.
//  Copyright © 2016年 xxx. All rights reserved.
//

/**
 *  1.扫描iBeacon需要用到CLLocationManager,所以在iOS8之后需要授权并且在plist文件中添加NSLocationWhenInUseUsageDescription
 *  2.扫描iBeacon可以用monitor和range两种模式,monitor模式最多能监控20个iBeacon,range模式可以监控很多iBeacon
 *  3.想要扫描iBeacon,必须指定想扫描iBeacon的UUID信息,只有指定了该信息,才能扫描到这个UUID对应的iBeacon(无法大范围扫描iBeacons)
 *  4.在monitor模式下,指定一个iBeacon的UUID,可以监控到进入和离开该iBeacon区域的事件,但是无法得知iBeacon的major和minor值
 *  5.在range模式下,指定一个iBeacon的UUID,可以通过代理方法didRangeBeacons来监控到所有UUID等于指定UUID的iBeacons(但是它们major和minor值不同)
 *  6.app有三种状态:前台,后台,被杀死(但是手机蓝牙功能必须开启)
 *  7.在monitor和range模式下,enterRange和exitRange方法都会在进入和离开iBeacon区域时被调用(在前台和被杀死状态时)
 *  8.在range模式下的didRangeBeacons代理方法,在前台状态时,调用频率较高(大概1秒1次).在被杀死状态时,会随着enterRange和exitRange代理方法的代用,而被调用连续执行几次
 */



#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate,UITextViewDelegate>

/*beacon区域*/
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

/*位置管理器*/
@property (nonatomic, strong) CLLocationManager *locMgr;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

//增加iBeacon区域
-(CLBeaconRegion *)beaconRegion
{
    if(_beaconRegion == nil)
    {
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"beacon"];
    }
    return _beaconRegion;
}

//创建位置管理器,并设置代理
-(CLLocationManager *)locMgr
{
    if(_locMgr == nil)
    {
        _locMgr = [[CLLocationManager alloc] init];
        _locMgr.delegate = self;
    }
    
    return _locMgr;
}

//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置textView用于显示log信息在手机屏幕上
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.5);
    self.textView.userInteractionEnabled = NO;
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    self.textView.delegate = self;
    self.view.backgroundColor = [UIColor redColor];
    
    //位置管理器开启监控模式:startMonitoringForRegion 与 startRangingBeaconsInRegion
    //这两种模式效果不同:http://tech.meituan.com/iBeacaon-first-glance.html
    //[self.locMgr startMonitoringForRegion:self.beaconRegion];
    [self.locMgr startRangingBeaconsInRegion:self.beaconRegion];
    [self.locMgr requestStateForRegion:self.beaconRegion];
    
    //获取定位权限
    //iOS8之后还需要在plist文件添加NSLocationWhenInUseUsageDescription的string类型键, value为提示信息，可以为空。
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        if ([self.locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locMgr requestAlwaysAuthorization];
        }
    }
    
    //进入和离开iBeacon区域时,调用代理didEnterRegion和didExitRegion方法
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    //注册本地通知
    UIUserNotificationSettings *local = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:local];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.locMgr requestStateForRegion:self.beaconRegion];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    
}

#pragma mark - CLLocationManager代理方法

//开启monitor模式后 触发该代理方法
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self showMsgAndMakeLocalNotification:@"Start Monitor!"];
}

//进入iBeacon区域触发该代理(app在前台,后台,被杀死三种状态都行)
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self showMsgAndMakeLocalNotification:[NSString stringWithFormat:@"进入区域:%@",region]];
}

//退出监控的region区域(app在前台,后台,被杀死三种状态都行)
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self showMsgAndMakeLocalNotification:[NSString stringWithFormat:@"离开区域:%@",region]];
}

//开启range模式会调用该方法(app在前台时大概每秒调用1次,在后台时几乎不调用,被杀死后随着enterRegion和exitRegion代理方法调用而调用多次之后就停止)
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
{
    [self showMsgAndMakeLocalNotification:[NSString stringWithFormat:@"RangeBeacons:%@",region]];
    if(beacons.count)
    {
        for(NSInteger i=0; i<beacons.count; i++)
        {
            CLBeacon *beacon = beacons[i];
            
            //proximity远近范围的,有Near(在几米内),Immediate(在几厘米内),Far(超过10米以外,不过在测试中超不过10米就是far),Unknown(无效)
            //accuracy:与指定iBeacon的距离,单位米.如果距离未知,返回负数
            //rssi:信号强度,为负值，越接近0信号越强，等于0时无法获取信号强度
            NSString *str = [NSString stringWithFormat:@"major:%@ minor:%@ %ld %f %ld",beacon.major,beacon.minor,(long)beacon.proximity,beacon.accuracy,(long)beacon.rssi];
            [self showMsgAndMakeLocalNotification:[NSString stringWithFormat:@"RangeBeacons:%@",str]];
        }
    }
}

//当调用requestStateForRegion方法时,会调用下面代理方法
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *stateStr = state == CLRegionStateInside? @"inside":@"outside";
    [self showMsgAndMakeLocalNotification:[NSString stringWithFormat:@"%@",stateStr]];
}

//range模式失败时调用
-(void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    [self showMsgAndMakeLocalNotification:[NSString stringWithFormat:@"FailForRegion:%@",region]];
}

//monitor模式失败时调用
-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    [self showMsgAndMakeLocalNotification:[NSString stringWithFormat:@"monitoringDidFailForRegion%@",region]];
}

#pragma mark - 工具函数
//显示信息到log和屏幕并且发送本地通知
-(void)showMsgAndMakeLocalNotification:(NSString*)str
{
    [self showStringInTextViewAndLog:str];
    [self makeLocalNotification:str];
}

//在控制台log以及手机屏幕的textView同时显示str信息
-(void)showStringInTextViewAndLog:(NSString *)str
{
    //显示信息
    NSLog(@"%@",str);
    self.textView.text = [self.textView.text stringByAppendingString:[str stringByAppendingString:@"\n"]];
    
    //让屏幕的textView滚动并始终显示最后一行内容
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
}

//执行本地通知
-(void)makeLocalNotification:(NSString*)notiStr
{
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.alertBody = notiStr;
    notice.alertAction = @"Open";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
}




















@end
