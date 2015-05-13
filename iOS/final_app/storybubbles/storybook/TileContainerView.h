//
//  TileContainerView.h
//  storybook
//
//  Created by Gavin Chu on 11/18/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileView.h"
#import "Helper.h"

@interface TileContainerView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) TileView *containedTile;
@property (strong, nonatomic) NSString *containedText;

@end
