//
//  BubbleThemesViewController.h
//  storybook
//
//  Created by Romi Phadte on 11/21/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animations.h"
#import "Helper.h"
#import "iCarousel.h"
#import "DictionaryKeys.h"
#import <UICountingLabel.h>

@interface ThemesViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@end
