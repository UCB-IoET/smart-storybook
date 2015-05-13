//
//  DrawingPageViewController.m
//  storybook
//
//  Created by Romi Phadte on 11/18/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "DrawingPageViewController.h"

@interface DrawingPageViewController ()

@property (nonatomic, strong) UIImage *initializationImage;
@property (nonatomic, strong) NSMutableDictionary *colorToTag;

@end

@implementation DrawingPageViewController

CGRect workingFrame;
CGRect normalizedFrame;

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    
    if (self != nil)
    {
        self.initializationImage = image;
        _colorToTag = [[NSMutableDictionary alloc] init];
        // Further initialization if needed
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    CGFloat SCREEN_HEIGHT = self.view.frame.size.height;
    CGFloat SCREEN_WIDTH = self.view.frame.size.width;

    workingFrame = CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT - 220);
    
    // Normalized frame is a copy of working frame with (0, 0) as origin. This is
    // so draw in rect will work
    normalizedFrame = workingFrame;
    normalizedFrame.origin = CGPointZero;
    
    self.mainImage = [[UIImageView alloc] initWithFrame:workingFrame];
    
    UIGraphicsBeginImageContext(workingFrame.size);
    [self.initializationImage drawInRect:normalizedFrame];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.tempDrawImage = [[UIImageView alloc] initWithFrame:workingFrame];
    
    [self.view addSubview:self.mainImage];
    [self.view addSubview:self.tempDrawImage];
    
    [self.mainImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.mainImage.layer setBorderWidth: 2.0];
    
    NSArray *colors = [[NSArray alloc] initWithObjects:@"Black", @"Gray", @"Red", @"Orange", @"Yellow", @"Green", @"Blue", @"Indigo", @"Violet", @"Erase", nil];
    
    int i;
    NSString *colorName;
    UIColor *color;
    UIButton *circleView;
    NSNumber *tagNumber;
    for (i = 0; i < [colors count]; i++) {
        colorName = [colors objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(colorPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:colorName forState:UIControlStateNormal];
        button.frame = CGRectMake(i * 90 + 40.0, SCREEN_HEIGHT - 40, 60, 40);
        button.tag = i;
        tagNumber = [NSNumber numberWithInt:i];
        [_colorToTag setValue:tagNumber forKey:colorName];
        
        color = [self getColorFromTag:tagNumber];
        
        [button setTitleColor:color forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        if ([colorName  isEqual: @"Erase"]) {
            // Use the erase picture
            circleView = [[UIButton alloc] initWithFrame:CGRectMake(i * 90 + 35.0, SCREEN_HEIGHT - 100, 120, 70)];
            [circleView setBackgroundImage:[UIImage imageNamed:@"eraser"]
                                forState:UIControlStateNormal];
        } else {
            // use a circle color
            circleView = [[UIButton alloc] initWithFrame:CGRectMake(i * 90 + 35.0, SCREEN_HEIGHT - 100, 70, 70)];
            [circleView setBackgroundImage:[Helper imageWithColor:color] forState:UIControlStateNormal];
            circleView.layer.cornerRadius = 35;
            circleView.clipsToBounds = YES;
        }
        
        circleView.tag = i;
        [circleView addTarget:self
                       action:@selector(colorPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:circleView];
        
    }
    
    UILabel *title = [[UILabel alloc] init];
    
    title.font = [UIFont fontWithName:@"Fredoka One" size:30.0];
    title.text = @"What do you think the mammals looks like?";
    
    [Helper reassignFrameSizeToMinimumEnclosingSize:title];
    
    title.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * .08);
    
    [self.view addSubview:title];
    
    [Helper addButtonWithCenter:CGPointMake(SCREEN_WIDTH * .08, SCREEN_HEIGHT * .08) title:@"CLEAR" selector:@selector(clearPressed:) withTarget:self toView:self.view];
    
    [Helper addButtonWithCenter:CGPointMake(SCREEN_WIDTH * .92, SCREEN_HEIGHT * .08) title:@"DONE" selector:@selector(donePressed:) withTarget:self toView:self.view];
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIColor *)getColorFromTag:(NSNumber *)tag {
    UIColor *color;
    
    int i = [tag intValue];
    
    switch(i)
    {
        case 0:
            // Black
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            // Gray
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 2:
            // Red
            red = 209.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            // Orange
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 34.0/255.0;
            break;
        case 4:
            // Yellow
            red = 255.0/255.0;
            green = 218.0/255.0;
            blue = 33.0/255.0;
            break;
        case 5:
            // Green
            red = 51.0/255.0;
            green = 221.0/255.0;
            blue = 0/255.0;
            break;
        case 6:
            // Blue
            red = 17.0/255.0;
            green = 51.0/255.0;
            blue = 204.0/255.0;
            break;
        case 7:
            // Indigo
            red = 75.0/255.0;
            green = 0.0/255.0;
            blue = 130.0/255.0;
            break;
        case 8:
            // Violet
            red = 34.0/255.0;
            green = 0.0/255.0;
            blue = 102.0/255.0;
            break;
        case 9:
            // Erase
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 255.0/255.0;
            opacity = 1.0;
            break;
    }
    
    color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    return color;
}

- (IBAction)colorPressed:(id)sender {
    UIButton *pressedButton = (UIButton*)sender;
    [self getColorFromTag:[NSNumber numberWithInt:pressedButton.tag]];
}

- (IBAction)donePressed:(id)sender {    
    [_presenter updateCustomImage:self.mainImage.image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearPressed:(id)sender {
    self.mainImage.image = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.mainImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.mainImage];
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.tempDrawImage.image drawInRect:normalizedFrame];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.tempDrawImage.image drawInRect:normalizedFrame];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:normalizedFrame blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:normalizedFrame blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

@end
