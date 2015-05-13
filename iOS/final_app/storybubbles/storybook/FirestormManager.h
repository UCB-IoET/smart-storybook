//
//  FirestormManager.h
//  Smart_Fan
//
//  Created by Romi Phadte on 4/17/15.
//  Copyright (c) 2015 Romi Phadte. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@import QuartzCore;

@interface FirestormManager : NSObject< CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) NSMutableData *data;
@property (readonly,nonatomic) NSMutableSet* devices;
@property (readonly,nonatomic) NSMutableDictionary* devices_information;

-(instancetype)initWithStatusCallback:(void(^)(NSString*)) callback;
-(void)connect;
-(void)connectToUUID:(NSString*)UUID;

+(instancetype)sharedInstance;
-(void)write:(NSString *)string;

@end
