//
//  Animations.h
//  storybook
//
//  Created by Alice J. Liu on 2014-11-24.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import "Helper.h"

@interface Animations : NSObject

+ (void)spawnBubblesInView:(UIView *)view;
+ (void)congratulateInView:(UIView *)view;
+ (void)throwFireworksInView:(UIView *)view;

@end
