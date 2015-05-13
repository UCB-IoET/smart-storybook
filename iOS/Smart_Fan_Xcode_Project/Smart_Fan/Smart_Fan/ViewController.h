//
//  ViewController.h
//  Smart_Fan
//
//  Created by Romi Phadte on 3/15/15.
//  Copyright (c) 2015 Romi Phadte. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreBluetooth;
@import QuartzCore;

@interface ViewController : UIViewController < CBCentralManagerDelegate, CBPeripheralDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) NSMutableData *data;
@property (weak, nonatomic) IBOutlet UITextView *statusView;
@property (weak, nonatomic) IBOutlet UITextField *writeField;
@end



