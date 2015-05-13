//
//  Helper.m
//  storybook
//
//  Created by Alice J. Liu on 2014-11-26.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (UIColor *)colorWithHexString:(NSString *)hex
{
    return [self colorWithHexString:hex andAlpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hex andAlpha:(float)alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)reassignFrameSizeToMinimumEnclosingSize:(UILabel *)label
{
    CGSize size = [label.text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [label.font fontWithSize:label.font.pointSize]}];
    
    CGRect newFrame = label.frame;
    newFrame.size.height = size.height;
    newFrame.size.width = size.width;
    label.frame = newFrame;
}

+ (void)addButtonWithCenter:(CGPoint)point title:(NSString *)title selector:(SEL)sel withTarget:(UIViewController *)target toView:(UIView *)view
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:target
               action:sel
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [Helper colorWithHexString:@"00C7FF"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"FredokaOne-Regular" size:30]];
    
    CGSize size = [button.titleLabel.text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [button.titleLabel.font fontWithSize:button.titleLabel.font.pointSize]}];
    
    CGRect newFrame = button.frame;
    newFrame.size.height = size.height;
    newFrame.size.width = size.width;
    button.frame = newFrame;
    
    // Give a 10 padding on each side.
    button.frame = CGRectInset(button.frame, -10, -10);
    
    button.center = point;
    
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.5;
    button.layer.shadowRadius = 2;
    button.layer.shadowOffset = CGSizeMake(3.0f,3.0f);
    
    [view addSubview:button];
}

+ (NSString *) serverURL{
    return @"http://expresso.cearto.com";
}

@end
