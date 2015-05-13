//
//  ViewController.m
//  Wallet
//
//  Created by Romi Phadte on 03/15/15.
//  Copyright (c) 2015 Romi Phadte. All rights reserved.
//

#import "ViewController.h"
#import "UUID.h"
#import "FirestormManager.h"

@interface ViewController ()

@property (strong,nonatomic) FirestormManager * FSManager;
           
@end

@implementation ViewController

BOOL _connected;
BOOL _connecting;

- (void)viewDidLoad {
    [super viewDidLoad];
    _writeField.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
    _connected = false;
    _connecting = false;
    self.FSManager=[[FirestormManager alloc] initWithStatusCallback:^(NSString * status) {
        NSLog(status);
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:YES];
}

- (IBAction) buttonPress {
    [self.FSManager connect];
   // [self cleanup];
    // implicit memory cleanup for old instances
   // _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //_data = [[NSMutableData alloc] init];
    
}

-(BOOL)textFieldShouldReturn:(id)sender
{
    [sender resignFirstResponder];
    return YES;
}

- (IBAction) write {
    if (_writeCharacteristic && _connected) {
        //int i = _writeField.text.intValue;
        NSData *d = [_writeField.text dataUsingEncoding:NSUTF8StringEncoding];
        //NSData *d = [NSData dataWithBytes: &i length:1];
        [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@%@", [_statusView text], @"Writing data ", d]];
        
        [_discoveredPeripheral writeValue:d forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
        
    }
}
- (IBAction)print:(id)sender {
    NSLog([[_FSManager devices] description]);
    NSLog([[_FSManager devices_information] description]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [_centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        
        [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Scanning for Nordic"]];
        NSLog(@"Scanning started");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ at %@ with identifier %@", peripheral.name, RSSI, [[peripheral identifier] UUIDString]);
    
    if ([[[peripheral identifier] UUIDString] isEqual:[[CBUUID UUIDWithString:FIRESTORM_DEVICE_UUID] UUIDString]]) {
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        _discoveredPeripheral = peripheral;
        
        
        if (!_connecting && !_connected) {
            // And connect
            [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Connecting to Nordic" ]];
            NSLog(@"Connecting to peripheral %@", peripheral);
            [_centralManager connectPeripheral:peripheral options:nil];
            _connecting = true;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Failed to connect"]];
    NSLog(@"Failed to connect");
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
    
    [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Disconnected from Nordic"]];
    _connecting = false;
    _connected = false;
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Connected to Nordic"]];
    _discoveredPeripheral = peripheral;
    NSLog(@"Connected to peripheral %@", peripheral);
    _connecting = false;
    _connected = true;
    
    [_centralManager stopScan];
    [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Scanning stopped"]];
    NSLog(@"Scanning stopped");
    
    [_data setLength:0];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Found service %@", service);
        //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:NORDIC_READ_UUID], [CBUUID UUIDWithString:NORDIC_WRITE_UUID]] forService:service];
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
            [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Found write characteristic" ]];
            _writeCharacteristic = characteristic;
        } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FIRESTORM_READ_UUID]]) {
            [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Found read characteristic" ]];
            if (characteristic.properties & CBCharacteristicPropertyNotify) {
                [peripheral setNotifyValue:TRUE forCharacteristic:characteristic];
                [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Subscribed to read" ]];
            } else {
                [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Read not notifiable" ]];
            }
        } else {
            [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Found unknown characteristic" ]];
            _writeCharacteristic = characteristic;
        }
        NSLog(@"Found characteristic %@", characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error");
        return;
    }
    
    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:FIRESTORM_READ_UUID]]) {
        [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@%@", [_statusView text], @"Notification from Nordic, value: ", characteristic.value]];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (characteristic.isNotifying) {
        [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Subscription successful"]];
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
        
        [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Disconnected from Nordic"]];
        
        _connecting = false;
        _connected = false;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    [_statusView setText:[[NSString alloc] initWithFormat:@"%@\n%@", [_statusView text], @"Write was successful" ]];
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
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
