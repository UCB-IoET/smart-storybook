//
//  Tile.m
//  storybook
//
//  Created by Gavin Chu 05/01/15.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "TileView.h"

@implementation TileView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect mFrame = self.bounds;
//    CGContextSetLineWidth(context, 10);
//    [[UIColor brownColor] set];
//    UIRectFrame(mFrame);
//}

- (instancetype) initWithProperties:(NSDictionary *)properties {
    CGRect frame = [[properties objectForKey:kFrame] CGRectValue];
    self = [super initWithFrame:frame];
    if (self) {
        _properties = properties;
        self.backgroundColor = [Helper colorWithHexString:@"00C7FF"];
        
        self.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
        [self addShadow];
        
        // initilize all your UIView components
        NSString *letter = [properties objectForKey:@"letter"];
        NSString *imageURL = [properties objectForKey:kImageURL];
        NSString *sentence = [properties objectForKey:@"sentence"];

        
        if (letter) {
            _text = letter;
            _letterLabel = [[UILabel alloc]initWithFrame:frame];
            _letterLabel.text = letter;
            _letterLabel.textColor = [UIColor whiteColor];
            _letterLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:50.0f];
            _letterLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_letterLabel];
        }
        
        if (imageURL) {
            _imageView = [[UIImageView alloc]initWithFrame:frame];
            [self addSubview:_imageView];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                
                //set your image on main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_imageView setImage:[UIImage imageWithData:data]];
                });
            });
        }
        
        if (sentence) {
            _text = sentence;
            _letterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - 50, frame.size.width, 50)];
            _letterLabel.backgroundColor = [UIColor whiteColor];
            _letterLabel.text = sentence;
            _letterLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_letterLabel];
        }
        
        self.center = [[properties objectForKey:kCenter] CGPointValue];
        self.originalPosition = self.center;
        self.tag = [[properties objectForKey:kTag] integerValue];
        
    }
    return self;
}

- (void)addShadow
{
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2;
}

- (void)removeShadow
{
    self.layer.shadowRadius = 0;
    self.layer.shadowOpacity = 0;
    self.layer.shadowColor = nil;
}

@end
