//
//  SampleViewController.h
//  storybook
//
//  Created by Romi Phadte 05/01/15.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animations.h"
#import "DictionaryKeys.h"
#import "Helper.h"
#import "UIBorderedLabel.h"

@interface BasePageViewController : UIViewController

@property (nonatomic, strong, setter=setdevices:, getter=devices) NSArray *devices;

- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews;
- (void)labelTapped:(UILabel *) label;

@end
