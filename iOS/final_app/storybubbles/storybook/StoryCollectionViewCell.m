//
//  StoryCollectionViewCell.m
//  storybook
//
//  Created by Gavin Chu on 11/25/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "StoryCollectionViewCell.h"

@implementation StoryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bookImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.bookImage];
    }
    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    
    // reset image property of imageView for reuse
    self.bookImage.image = nil;
    
    // update frame position of subviews
    self.bookImage.frame = self.contentView.bounds;
}

@end
