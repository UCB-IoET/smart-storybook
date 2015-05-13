//
//  ThemeViewController.h
//  storybook
//
//  Created by Gavin Chu on 12/1/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeViewController : UIViewController

- (IBAction)themeViewTouched:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *kid;
@property (strong, nonatomic) IBOutlet UIImageView *earth;
@property (strong, nonatomic) IBOutlet UIImageView *saturn;
@property (strong, nonatomic) IBOutlet UIImageView *alien;
@property (strong, nonatomic) IBOutlet UIImageView *pluto;
@property (strong, nonatomic) IBOutlet UIImageView *comet;

@end
