//
//  ThemeDetailViewController.h
//  storybook
//
//  Created by Gavin Chu on 11/25/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeStoriesCollectionViewController.h"
#import "BookDetailViewController.h"

@interface ThemeDetailViewController : UIViewController


@property (strong, nonatomic) ThemeStoriesCollectionViewController *collectionViewController;
@property (strong, nonatomic) BookDetailViewController *bookDetailViewController;
@property (strong, nonatomic) IBOutlet UIView *bookDetailView;
@property (strong, nonatomic) IBOutlet UIView *storiesCollectionView;
@property (strong, nonatomic) IBOutlet UIView *themeView;
@property (strong, nonatomic) IBOutlet UIView *emptyWhiteView;

@property (weak, nonatomic) IBOutlet UIButton *upArrow;
@property (weak, nonatomic) IBOutlet UIButton *downArrow;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

- (IBAction)upArrowClicked:(UIButton *)sender;
- (IBAction)downArrowClicked:(UIButton *)sender;

- (void)openStoriesCollectionView;

- (void)openBookDetailView;
- (void)closeBookDetailView;

- (void)loadBookDetailTitle:(NSString *)title
                     Author:(NSString *)author
                Illustrator:(NSString *)illustrator
                  BookCover:(NSString *)imageName
                Description:(NSString *)description;

@property BOOL bookDetailOpened;

@end
