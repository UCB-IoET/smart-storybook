//
//  ThemeViewController.m
//  storybook
//
//  Created by Gavin Chu on 12/1/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeDetailViewController.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

BOOL animating;

- (void)viewDidLoad {
    self.earth.hidden = YES;
    self.kid.hidden = YES;
    self.saturn.hidden = YES;
    self.alien.hidden = YES;
    self.pluto.hidden = YES;
    self.comet.hidden = YES;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startEarthAnimations];
    animating = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.earth.hidden = YES;
    self.kid.hidden = YES;
    self.saturn.hidden = YES;
    self.alien.hidden = YES;
    self.pluto.hidden = YES;
    self.comet.hidden = YES;
}

- (IBAction)themeViewTouched:(UITapGestureRecognizer *)sender {
    if (animating) {
        [self bringToFinalPositions];
        
        [self onAnimationsEnd];
    } else {
        [(ThemeDetailViewController *)self.parentViewController closeBookDetailView];
    }
}

- (void)bringToFinalPositions
{
    CGFloat SCREEN_WIDTH = self.view.frame.size.width;
    CGFloat SCREEN_HEIGHT = self.view.frame.size.height;
    
    self.earth.hidden = NO;
    self.earth.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.earth.center = self.view.center;
    
    self.kid.hidden = NO;
    self.kid.frame = CGRectMake(0,0,SCREEN_HEIGHT*0.3,SCREEN_HEIGHT*0.3);
    self.kid.center = CGPointMake(SCREEN_WIDTH*0.32,SCREEN_HEIGHT*0.645);
    
    self.pluto.hidden = NO;
    self.saturn.hidden = NO;
    self.alien.hidden = NO;
    
    self.earth.center = CGPointMake(SCREEN_WIDTH*0.5,SCREEN_HEIGHT+50);
    self.pluto.center = CGPointMake(self.pluto.center.x,SCREEN_HEIGHT*0.22);
    self.saturn.center = CGPointMake(self.saturn.center.x,SCREEN_HEIGHT*0.5);
    self.alien.center = CGPointMake(self.alien.center.x,SCREEN_HEIGHT*0.25);
    
    self.comet.hidden = NO;
    self.comet.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.comet.center = CGPointMake(SCREEN_WIDTH+200, SCREEN_HEIGHT*0.1);
}

- (void)startEarthAnimations {
    CGFloat SCREEN_WIDTH = self.view.frame.size.width;
    CGFloat SCREEN_HEIGHT = self.view.frame.size.height;
    
    self.earth.frame = CGRectMake(0,0,SCREEN_HEIGHT*0.85,SCREEN_HEIGHT*0.85);
    self.earth.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.earth.center = self.view.center;
    
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.earth.hidden = NO;
                         self.earth.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         self.earth.center = self.view.center;
                     }
                     completion:^(BOOL finished) {
                         [self slidePlanetsDownAnimations];
                     }];
}

- (void)slidePlanetsDownAnimations {
    CGFloat SCREEN_WIDTH = self.view.frame.size.width;
    CGFloat SCREEN_HEIGHT = self.view.frame.size.height;
    
    self.pluto.frame = CGRectMake(0,0,SCREEN_HEIGHT*0.5,SCREEN_HEIGHT*0.5);
    self.pluto.center = CGPointMake(SCREEN_WIDTH*0.15,-SCREEN_HEIGHT*0.4);
    
    self.saturn.frame = CGRectMake(0,0,SCREEN_HEIGHT*0.3,SCREEN_HEIGHT*0.3);
    self.saturn.center = CGPointMake(SCREEN_WIDTH*0.75,-SCREEN_HEIGHT*0.4);
    
    self.alien.frame = CGRectMake(0,0,SCREEN_HEIGHT*0.18,SCREEN_HEIGHT*0.18);
    self.alien.center = CGPointMake(SCREEN_WIDTH*0.55,-SCREEN_HEIGHT*0.4);
    
    [UIView animateWithDuration:1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.pluto.hidden = NO;
                         self.saturn.hidden = NO;
                         self.alien.hidden = NO;
                         
                         self.earth.center = CGPointMake(SCREEN_WIDTH*0.5,SCREEN_HEIGHT+50);
                         self.pluto.center = CGPointMake(self.pluto.center.x,SCREEN_HEIGHT*0.22);
                         self.saturn.center = CGPointMake(self.saturn.center.x,SCREEN_HEIGHT*0.5);
                         self.alien.center = CGPointMake(self.alien.center.x,SCREEN_HEIGHT*0.25);
                     }
                     completion:^(BOOL finished) {
                         if (animating) {
                             [self kidPopOutAnimations];
                         }
                     }];
}

- (void)kidPopOutAnimations {
    CGFloat SCREEN_WIDTH = self.view.frame.size.width;
    CGFloat SCREEN_HEIGHT = self.view.frame.size.height;
    
    self.kid.frame = CGRectMake(0,0,SCREEN_HEIGHT*0.3,SCREEN_HEIGHT*0.3);
    self.kid.center = CGPointMake(SCREEN_WIDTH*0.5,SCREEN_HEIGHT);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.kid.hidden = NO;
                         self.kid.center = CGPointMake(SCREEN_WIDTH*0.32,SCREEN_HEIGHT*0.645);
                     }
                     completion:^(BOOL finished) {
                         if (animating) {
                             [self cometFlyByAnimations];
                         }
                     }];
}

- (void)cometFlyByAnimations {
    CGFloat SCREEN_WIDTH = self.view.frame.size.width;
    CGFloat SCREEN_HEIGHT = self.view.frame.size.height;
    
    self.comet.frame = CGRectMake(0,0,SCREEN_HEIGHT*0.2,SCREEN_HEIGHT*0.2);
    self.comet.transform = CGAffineTransformMakeScale(1, 1);
    self.comet.center = CGPointMake(-200, SCREEN_HEIGHT*0.8);
    
    [UIView animateWithDuration:2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.comet.hidden = NO;
                         self.comet.transform = CGAffineTransformMakeScale(0.5, 0.5);
                         self.comet.center = CGPointMake(SCREEN_WIDTH+200, SCREEN_HEIGHT*0.1);
                     }
                     completion:^(BOOL finished) {
                         if (animating) {
                             [self onAnimationsEnd];
                         }
                     }];
}

- (void)onAnimationsEnd {
    animating = NO;
    [(ThemeDetailViewController *)self.parentViewController openStoriesCollectionView];
}

@end
