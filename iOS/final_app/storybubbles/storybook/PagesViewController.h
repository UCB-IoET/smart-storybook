//
//  PagesViewController.h
//  storybook
//
//  Created by Romi Phadte 05/01/15.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagesViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSString *title;

@end
