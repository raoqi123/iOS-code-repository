//
//  ViewController.m
//  蓝牙扫描周边所有iBeacons测试
//
//  Created by 饶齐 on 16/8/5.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


/* 代码参考于 */
/* http://developer.radiusnetworks.com/2013/10/21/corebluetooth-doesnt-let-you-see-ibeacons.html */

@interface ViewController ()<CBPeripheralDelegate,CBCentralManagerDelegate>

@property (nonatomic, strong)CBCentralManager* manager;

@property (nonatomic, strong)CBPeripheral *peripheral;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"loaded test view for finding beacons using core bluetooth");
    _manager = [[CBCentralManager alloc] initWithDelegate:self
                                                    queue:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
        {
            NSDictionary *options = @{
                                      CBCentralManagerScanOptionAllowDuplicatesKey: @YES
                                      };
            [_manager scanForPeripheralsWithServices:nil
                                             options:options];
            NSLog(@"I just started scanning for peripherals");
            break;
        }
    }
}

- (void)   centralManager:(CBCentralManager *)central
    didDiscoverPeripheral:(CBPeripheral *)peripheral
        advertisementData:(NSDictionary *)advertisementData
                     RSSI:(NSNumber *)RSSI
{
    NSLog(@"I see an advertisement with identifer: %@, state: %ld, name: %@, services: %@, description: %@",
          [peripheral identifier],
          (long)[peripheral state],
          [peripheral name],
          [peripheral services],
          [advertisementData description]);
    
    if (_peripheral == nil)
    {
        NSLog(@"Trying to connect to peripheral");
        _peripheral = peripheral;
        _peripheral.delegate = (id)self;
        [central connectPeripheral:_peripheral
                           options:nil];
    }
}

- (void)  centralManager:(CBCentralManager *)central
    didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral == nil)
    {
        NSLog(@"connect callback has nil peripheral");
    } else {
        NSLog(@"Connected to peripheral with identifer: %@, state: %ld, name: %@, services: %@",
              [peripheral identifier],
              (long)[peripheral state],
              [peripheral name],
              [peripheral services]);
        
        NSLog(@"discovering services...");
        _peripheral = peripheral;
        _peripheral.delegate = (id)self;
        [_peripheral discoverServices:nil];
    }
}

- (void)     peripheral:(CBPeripheral *)peripheral
    didDiscoverServices:(NSArray *)serviceUuids
{
    NSLog(@"discovered a peripheral's services: %@", serviceUuids);
}

@end
