//
//  AppDelegate.m
//  蓝牙测试iBeacon3
//
//  Created by 饶齐 on 16/8/4.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate>

/*beacon区域*/
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
/*位置管理器*/
@property (nonatomic, strong) CLLocationManager *locMgr;

@property (nonatomic, strong) ViewController *vc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //添加根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    self.vc = vc;
    
    
    
    
    
    
    
    //设置iBeacon监听器 和 位置管理器
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"beacon"];
//    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID major:3 minor:777 identifier:@"beacon"];
    
    
    _locMgr = [[CLLocationManager alloc] init];
    _locMgr.delegate = self;
    
    //[self.locMgr startMonitoringForRegion:self.beaconRegion];
    [self.locMgr startRangingBeaconsInRegion:self.beaconRegion];
    
    [self.locMgr requestStateForRegion:self.beaconRegion];
    
    //获取定位权限
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        if ([self.locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locMgr requestAlwaysAuthorization];
        }
    }
    
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//设置我们需要的本地通知类型
    UIUserNotificationSettings *local = [UIUserNotificationSettings settingsForTypes:1 << 2 categories:nil];
//对通知进行注册，让系统知道
    [[UIApplication sharedApplication] registerUserNotificationSettings:local];
    
    // always update UI
    //[self _updateUIForState:state];
    NSLog(@"%s",__func__);
    //    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        // don't send any notifications
    //        return;
    //    }
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.alertBody = @"Left Estimote beacon region!";
    notice.alertAction = @"Open";
    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
    if (state == CLRegionStateInside)
    {
        NSLog(@"inside!");
        //self.textView.text = [self.textView.text stringByAppendingString:@"inside!\n"];
        //[self _sendEnterLocalNotification];
    }
    else
    {
        NSLog(@"outside!");
        //[self _sendExitLocalNotification];
        //self.textView.text = [self.textView.text stringByAppendingString:@"outside!\n"];
    }
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    //NSLog(@"%@",region);
    //NSLog(@"%s ,line = %d",__FUNCTION__,__LINE__);
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.locMgr requestStateForRegion:self.beaconRegion];
    [self.vc.textView scrollRangeToVisible:NSMakeRange(self.vc.textView.text.length, 1)];
    
}
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    
    
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.alertBody = @"Left Estimote beacon region!";
    notice.alertAction = @"Open";
    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
    
    NSLog(@"%@",region);
    
    NSString *text = [NSString stringWithFormat:@"Enter region%@",region];
    self.vc.textView.text = [self.vc.textView.text stringByAppendingString:text];
    //    if([region isEqual:self.beaconRegion])
    //    {
    //        //确认当前iBeacon区域内的iBeacon设备数量,并且确定我们的设备与区域中的一个或
    //        //多个iBeacon设备的相对距离,并在距离改变时被通知,出发代理didRangeBeacons
    //        [self.locMgr startRangingBeaconsInRegion:self.beaconRegion];
    //
    //        NSDictionary *info = [self.beaconRegion peripheralDataWithMeasuredPower:@0];
    //
    //        //通知外设(当前我自己用的手机)开启广播
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterRegionNotification" object:nil userInfo:info];
    //
    //    }
}

//-(void)loca

//退出监控的region区域
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"You are inside region %@", region.identifier];
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    UILocalNotification *notice = [[UILocalNotification alloc] init];
    notice.alertBody = @"Left Estimote beacon region!";
    notice.alertAction = @"Open";
    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
    
    //外设关闭广播
    //通知外设开启广播
    NSLog(@"%@",region);
    NSString *text = [NSString stringWithFormat:@"Exit regin: %@\n",region];
    self.vc.textView.text = [self.vc.textView.text stringByAppendingString:text];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"didExitRegionNotification" object:nil];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count)
    {
        for(NSInteger i=0; i<beacons.count; i++)
        {
            CLBeacon *beacon = beacons[i];
            //beacon.accuracy 与指定iBeacon的距离,单位米.如果距离未知,返回负数
            //beacon.rssi 检测到指定iBeacon的信号强弱,为负数,距离越远负数越小. 近距离-33,远一点可能就-60强度了.
            NSLog(@"距离%lf 信号强度%ld()",beacon.accuracy,(long)beacon.rssi);
            if(beacon.proximity == CLProximityNear)
            {
                
                //                beacon.accuracy
                //                beacon.rssi
                NSLog(@"Near:major = %@ || minor = %@",beacon.major,beacon.minor);
                NSString *text = [NSString stringWithFormat:@"Near:major = %@ || minor = %@\n",beacon.major,beacon.minor];
                self.vc.textView.text = [self.vc.textView.text stringByAppendingString:text];
            }
            else if(beacon.proximity == CLProximityFar)
            {
                NSLog(@"Far:major = %@ || minor = %@",beacon.major,beacon.minor);
                NSString *text = [NSString stringWithFormat:@"Far:major = %@ || minor = %@\n",beacon.major,beacon.minor];
                self.vc.textView.text = [self.vc.textView.text stringByAppendingString:text];
            }
            else if(beacon.proximity == CLProximityImmediate)
            {
                NSLog(@"Immediate:major = %@ || minor = %@",beacon.major,beacon.minor);
                NSString *text = [NSString stringWithFormat:@"Immediate:major = %@ || minor = %@\n",beacon.major,beacon.minor];
                self.vc.textView.text = [self.vc.textView.text stringByAppendingString:text];
            }
            else
            {
                NSLog(@"Unknow:major = %@ || minor = %@",beacon.major,beacon.minor);
                NSString *text = [NSString stringWithFormat:@"Immediate:major = %@ || minor = %@\n",beacon.major,beacon.minor];
                self.vc.textView.text = [self.vc.textView.text stringByAppendingString:text];
            }
        }
    }
}








- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
