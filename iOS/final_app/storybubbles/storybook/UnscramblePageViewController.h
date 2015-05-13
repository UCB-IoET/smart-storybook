//
//  UnscrambleWordsViewController.h
//  storybook
//
//  Created by Gavin Chu 05/01/15.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"

@interface UnscramblePageViewController : BasePageViewController <UIGestureRecognizerDelegate>

- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews andWord:(NSString *)word;
- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews andScenes:(NSArray *)scenes;

@end
