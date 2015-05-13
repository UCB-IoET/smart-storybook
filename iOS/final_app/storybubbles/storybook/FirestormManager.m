//
//  FirestormManager.m
//  Smart_Fan
//
//  Created by Romi Phadte on 4/17/15.
//  Copyright (c) 2015 Romi Phadte. All rights reserved.
//

#import "FirestormManager.h"
#import "UUID.h"

@interface FirestormManager()

@property (nonatomic,copy) void (^statusCallback)(NSString*);
@end

BOOL _connected;
BOOL _connecting;

@implementation FirestormManager

FirestormManager* _sharedInstance;

-(instancetype) init{
    if(!self){
        self=[self initWithStatusCallback:^(NSString *s) {
            NSLog(s);
        }];
    }
    
    return self;
}


-(instancetype)initWithStatusCallback:(void(^)(NSString*)) callback{
    if(!self){
        self=[super init];
    }
    self.statusCallback=callback;
    _connected = false;
    _connecting = false;
    _devices=[[NSMutableSet alloc] init];
    _devices_information=[[NSMutableDictionary alloc] init];
    
    return self;
}

+(FirestormManager *)sharedInstance{
    if(!_sharedInstance){
        _sharedInstance=[[FirestormManager alloc] initWithStatusCallback:^(NSString *s) {
            NSLog(s);
        }];
    }
    return _sharedInstance;
}

-(void)connect{
    [self cleanup];
    // implicit memory cleanup for old instances
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}


-(void)write:(NSString*) string {
    if (_writeCharacteristic && _connected) {
        NSData *d = [string dataUsingEncoding:NSUTF8StringEncoding];
        _statusCallback(@"Writing data");
        [_discoveredPeripheral writeValue:d forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [_centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        _statusCallback(@"Scanning for Firestorm");
    }
}

- (void)connectToUUID:(NSString *)UUID{
     _discoveredPeripheral =[_devices_information objectForKey:UUID];
    
    if (!_connecting && !_connected) {
        // And connect
        _statusCallback(@"Connecting to Firestorm");
        [_centralManager connectPeripheral:_discoveredPeripheral options:nil];
        _connecting = true;
    }   
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if(![_devices containsObject:[[peripheral identifier] UUIDString]]){
        [_devices addObject:[[peripheral identifier] UUIDString]];
        [_devices_information setValue:peripheral forKey:[[peripheral identifier] UUIDString]];
        
        _statusCallback([NSString stringWithFormat:@"Discovered %@ at %@ with identifier %@", peripheral.name, RSSI, [[peripheral identifier] UUIDString]]);
    
        if ([[[peripheral identifier] UUIDString] isEqual:[[CBUUID UUIDWithString:FIRESTORM_DEVICE_UUID] UUIDString]]) {
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            [self connectToUUID:FIRESTORM_DEVICE_UUID];
           
            }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    _statusCallback(@"Failed to connect");
    [self cleanup];
}

- (void)cleanup {
    
    // See if we are subscribed to a characteristic on the peripheral
    if (_discoveredPeripheral.services != nil) {
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if (characteristic.isNotifying) {
                        [_discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                        return;
                    }
                }
            }
        }
    }
    
    [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
    _statusCallback(@"Disconnected");
    _connecting = false;
    _connected = false;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    _statusCallback(@"Connected to Firestorm");
    _discoveredPeripheral = peripheral;
    _connecting = false;
    _connected = true;
    
    [_centralManager stopScan];
    _statusCallback(@"Scanning stopped");
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        _statusCallback(@"Found service");
        //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:FIRESTORM_READ_UUID], [CBUUID UUIDWithString:FIRESTORM_WRITE_UUID]] forService:service];
        [peripheral discoverCharacteristics:nil forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FIRESTORM_WRITE_UUID]]) {
            _statusCallback(@"Found write characteristic");
            _writeCharacteristic = characteristic;
        } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FIRESTORM_READ_UUID]]) {
            _statusCallback(@"Found read characteristic");
            if (characteristic.properties & CBCharacteristicPropertyNotify) {
                [peripheral setNotifyValue:TRUE forCharacteristic:characteristic];
                _statusCallback(@"Subscribed to read");
            } else {
                _statusCallback(@"Read not notifiable");
            }
        } else {
            _statusCallback(@"Found unknown characteristics");
            _writeCharacteristic = characteristic;
        }
        _statusCallback([NSString stringWithFormat:@"Found characteristic %@", characteristic]);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        _statusCallback(@"Error");
        return;
    }
    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:FIRESTORM_READ_UUID]]) {
        _statusCallback([NSString stringWithFormat:@"Notification from Firestorm, value: %@", characteristic.value]);
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (characteristic.isNotifying) {
        _statusCallback(@"Subscription successful");
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
        
        _statusCallback(@"Disconnected from Firesorm");
        
        _connecting = false;
        _connected = false;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    
    _statusCallback(@"Write was successful");
    
    if (error) {
        _statusCallback([NSString stringWithFormat:@"Error writing characteristic value: %@",
                         [error localizedDescription]]);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    _discoveredPeripheral = nil;
    
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:FIRESTORM_DEVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [_centralManager stopScan];
}

@end