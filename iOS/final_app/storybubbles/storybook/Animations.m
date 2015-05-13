//
//  Animations.m
//  storybook
//
//  Created by Alice J. Liu on 2014-11-24.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "Animations.h"

@implementation Animations

+ (void)spawnBubblesInView:(UIView *)view
{
    // Configure the particle emitter to the top edge of the screen
    NSMutableArray *bubbles = [NSMutableArray array];
    
    CAEmitterLayer *bubbleEmitter = [CAEmitterLayer layer];
    bubbleEmitter.emitterPosition = CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height + 100);
    bubbleEmitter.emitterSize		= CGSizeMake(view.bounds.size.width * 2.0, 0.0);
    
    
    
    // Spawn points for the bubbles are within on the outline of the line
    bubbleEmitter.emitterMode		= kCAEmitterLayerOutline;
    bubbleEmitter.emitterShape	= kCAEmitterLayerLine;
    
    
    for (int i = 0; i < 10; i++) {
        
        // Configure the bubble emitter cell
        CAEmitterCell *bubble = [CAEmitterCell emitterCell];
        
        bubble.birthRate		= 0.3;
        bubble.lifetime         = 30.0;
        
        bubble.velocity         = 10;				// inital speed going up
        bubble.velocityRange    = 5;
        bubble.yAcceleration    = -5;              // quickly accelerating up
        bubble.emissionRange    = 5.0 * M_PI;		// some variation in angle
        bubble.spinRange		= 1.0 * M_PI;		// medium spin
        
        bubble.scale            = 0.1;
        bubble.scaleRange       = 0.5;
        
        bubble.contents	= (id) [[UIImage imageNamed:@"bubble_large"] CGImage];
        //bubble.color = [[UIColor colorWithRed:1 green:1 blue:1 alpha:(arc4random()%100)/150.0] CGColor];
        
        [bubbles addObject:bubble];
        
    }

    // Add everything to our backing layer below the UIContol defined in the storyboard
    bubbleEmitter.emitterCells = bubbles;
    [view.layer insertSublayer:bubbleEmitter atIndex:0];
}

+ (void)congratulateInView:(UIView *)view {
    CGFloat SCREEN_WIDTH = view.frame.size.width;
    CGFloat SCREEN_HEIGHT = view.frame.size.height;
    
    /*UILabel *congrats = [[UILabel alloc] init];
    congrats.text = @"HOORAY!!";
    congrats.textAlignment = NSTextAlignmentCenter;
    congrats.font = [UIFont fontWithName:@"Fredoka One" size:100.0f];
    congrats.textColor = [UIColor whiteColor];
    
    [Helper reassignFrameSizeToMinimumEnclosingSize:congrats];
    congrats.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT * .9f);*/
    
    UIImageView *congrats = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HOORAY"]];
    congrats.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 200);
    congrats.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT * .9f);
    
    
    POPSpringAnimation *scaleUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleUp.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)];
    scaleUp.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleUp.springBounciness = 20.0f;
    scaleUp.springSpeed = 20.0f;
    
    [congrats.layer pop_addAnimation:scaleUp forKey:@"first"];
    
    [view addSubview:congrats];
}

+ (void)throwFireworksInView:(UIView *)view
{
    /*
    // Cells spawn in the bottom, moving up
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 1.0;
    rocket.emissionRange	= 0.25 * M_PI;  // some variation in angle
    rocket.velocity			= 600;
    rocket.velocityRange	= 100;
    rocket.yAcceleration	= 75;
    rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
    
    rocket.contents			= (id) [[UIImage imageNamed:@"DazRing"] CGImage];
    rocket.scale			= 0.2;
    rocket.color			= [[UIColor redColor] CGColor];
    rocket.greenRange		= 1.0;		// different colors
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    rocket.spinRange		= M_PI;		// slow spin
    
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=-1.5;		// shifting
    burst.blueSpeed			=+1.5;		// shifting
    burst.greenSpeed		=+1.0;		// shifting
    burst.lifetime			= 0.35;
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 400;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;	// 360 deg
    spark.yAcceleration		= 75;		// gravity
    spark.lifetime			= 3;
    
    spark.contents			= (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=-0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=-0.1;
    spark.alphaSpeed		=-0.25;
    spark.spin				= 2* M_PI;
    spark.spinRange			= 2* M_PI;
    
    // putting it together
    fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells				= [NSArray arrayWithObject:burst];
    burst.emitterCells				= [NSArray arrayWithObject:spark];
    [view.layer addSublayer:fireworksEmitter];
     */
}

@end
