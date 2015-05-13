//
//  Helper.h
//  storybook
//
//  Created by Alice J. Liu on 2014-11-26.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHexString:(NSString *)hex andAlpha:(float)alpha;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (void)reassignFrameSizeToMinimumEnclosingSize:(UILabel *)label;
+ (void)addButtonWithCenter:(CGPoint)point title:(NSString *)title selector:(SEL)sel withTarget:(UIViewController *)target toView:(UIView *)view;
+ (NSString*) serverURL;

@end
