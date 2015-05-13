//
//  DrawingPageViewController.h
//  storybook
//
//  Created by Romi Phadte on 11/18/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "DrawingPrompterViewController.h"
#import "Helper.h"

@interface DrawingPageViewController : BasePageViewController <UIGestureRecognizerDelegate> {
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *tempDrawImage;
@property (weak, nonatomic) DrawingPrompterViewController *presenter;

- (IBAction)colorPressed:(id)sender;

- (IBAction)donePressed:(id)sender;
- (UIColor *)getColorFromTag:(NSNumber *)tag;

- (id)initWithImage:(UIImage *)image;

@end
