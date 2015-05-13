//
//  TileContainerView.m
//  storybook
//
//  Created by Gavin Chu on 11/18/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "TileContainerView.h"

@implementation TileContainerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        //[[NSBundle mainBundle] loadNibNamed:@"TileContainerView" owner:self options:nil];
        //self.bounds = self.view.bounds;
        //[self addSubview:self.view];
        if (frame.size.height == frame.size.width) {
            self.backgroundColor = [Helper colorWithHexString:@"D1D3D4"];
            self.layer.borderColor = [Helper colorWithHexString:@"00C7FF"].CGColor;
            self.layer.borderWidth = 10.0f;

        } else {
            self.backgroundColor = [Helper colorWithHexString:@"EEEEEE"];
        }
        self.containedTile = nil;
        self.containedText = @"";
    }
    return self;
}

@end
