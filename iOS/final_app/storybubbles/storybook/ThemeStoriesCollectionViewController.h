//
//  ThemeStoriesCollectionViewController.h
//  storybook
//
//  Created by Gavin Chu on 11/25/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeStoriesCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSMutableArray* books;
@property int currentIndex;

- (void)incrementIndex;
- (void)decrementIndex;

@end
