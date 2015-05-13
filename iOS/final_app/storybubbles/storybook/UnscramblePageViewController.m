//
//  UnscrambleWordsViewController.m
//  storybook
//
//  Created by Gavin Chu 05/01/15.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "UnscramblePageViewController.h"
#import "TileView.h"
#import "TileContainerView.h"
#import <pop/POP.h>

@interface UnscramblePageViewController ()

@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSArray *scenes;
@property (strong, nonatomic) NSMutableArray *answer;
@property (strong, nonatomic) NSMutableArray *containers; //array of TileContainerView
@property (strong, nonatomic) NSMutableArray *tiles;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *hint;

@end

@implementation UnscramblePageViewController

const int TILE_TAG= 1;
const int TILE_CONTAINER_TAG = 2;

const int MAX_SPACING = 80;
const int PADDING = 50;
const int CONTAINER_SIZE = 110;
const int TILE_SIZE = 100;

const int SCENE_CONTAINER_SIZE = 180;
const int SCENE_PADDING = 25;

CGFloat SCREEN_WIDTH, SCREEN_HEIGHT;

- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews andWord:(NSString *)word {
    self = [super initWithTextLabels:textLabels andImageViews:imageViews];
    if (self) {
        _word = word;
    }
    return self;
}

- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews andScenes:(NSArray *)scenes {
    self = [super initWithTextLabels:textLabels andImageViews:imageViews];
    if (self) {
        _scenes = scenes;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCREEN_WIDTH = self.view.frame.size.width;
    SCREEN_HEIGHT = self.view.frame.size.height;
    
    if (_word) {
        [self addTileContainersWithSize:(int)_word.length];
        //[self addLetterTiles];
        NSArray *propertiesArray = [self createPropertiesArrayForWord:_word];
        [self addTilesWithPropertiesArray:propertiesArray toView:self.view];
    }
    if (_scenes) {
        [self addSceneContainersWithSize:(int)[_scenes count]];
        NSArray *propertiesArray = [self createPropertiesArrayForScenes:_scenes];
        [self addTilesWithPropertiesArray:propertiesArray toView:self.view];
    }
    [self applyGesureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTileContainersWithSize:(int)size {
    _containers = [[NSMutableArray alloc] init];
    
    int maxContainerSpace = CONTAINER_SIZE + MAX_SPACING;
    int spaceContainersCanOccupy = SCREEN_WIDTH - 2 * PADDING;
    
    int spaceForEachContainer = spaceContainersCanOccupy/size; //container plus padding space
    int startingPostion;
    
    if (spaceForEachContainer > maxContainerSpace) {
        //NSLog(@"need to reudce spacing from %d to %d", spaceForEachContainer, maxContainerSpace);
        spaceForEachContainer = maxContainerSpace;
        
        int totalContainerSpace = size * CONTAINER_SIZE + (size - 1) * MAX_SPACING; //n-1 spacing
        int padding = (SCREEN_WIDTH - totalContainerSpace)/2; //left and right padding outside containers
        startingPostion = padding + CONTAINER_SIZE/2; //recalculate padding and add container center offset
        
    } else {
        int paddingForEachContainer = (spaceForEachContainer - CONTAINER_SIZE)/2; //left or right padding
        startingPostion = PADDING + paddingForEachContainer + CONTAINER_SIZE/2; //add half of container size for center offset
    }
    
    for (int i = 0; i < size; i++) {
        TileContainerView *tileContainer;
        tileContainer = [[TileContainerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        tileContainer.center = CGPointMake(startingPostion + i*spaceForEachContainer, 500);
        tileContainer.tag = TILE_CONTAINER_TAG;
        [_containers addObject:tileContainer];
        [self.view addSubview:tileContainer];
    }
}

- (void)addSceneContainersWithSize:(int)size {
    _containers = [[NSMutableArray alloc] init];
    
    int maxContainerSpace = SCENE_CONTAINER_SIZE + MAX_SPACING;
    int spaceContainersCanOccupy = SCREEN_WIDTH - 2 * SCENE_PADDING;
    
    int spaceForEachContainer = spaceContainersCanOccupy/size; //container plus padding space
    int startingPostion;
    
    if (spaceForEachContainer > maxContainerSpace) {
        spaceForEachContainer = maxContainerSpace;
        
        int totalContainerSpace = size * SCENE_CONTAINER_SIZE + (size - 1) * MAX_SPACING; //n-1 spacing
        int padding = (SCREEN_WIDTH - totalContainerSpace)/2; //left and right padding outside containers
        startingPostion = padding + SCENE_CONTAINER_SIZE/2; //recalculate padding and add container center offset
        
    } else {
        int paddingForEachContainer = (spaceForEachContainer - SCENE_CONTAINER_SIZE)/2; //left or right padding
        startingPostion = SCENE_PADDING + paddingForEachContainer + SCENE_CONTAINER_SIZE/2; //add half of container size for center offset
    }
    
    for (int i = 0; i < size; i++) {
        TileContainerView *tileContainer;
        tileContainer = [[TileContainerView alloc] initWithFrame:CGRectMake(0, 0, 180, 150)];
        tileContainer.center = CGPointMake(startingPostion + i*spaceForEachContainer, SCREEN_HEIGHT*0.25);
        tileContainer.tag = TILE_CONTAINER_TAG;
        [_containers addObject:tileContainer];
        [self.view addSubview:tileContainer];
    }
}

- (void)addTilesWithPropertiesArray:(NSArray *)propertiesArray toView:(UIView *)view {
    _tiles = [[NSMutableArray alloc] init];
    
    for (int i=0; i < [propertiesArray count]; i++) {
        NSDictionary *properties = [propertiesArray objectAtIndex:i];
        TileView *tileView = [[TileView alloc] initWithProperties:properties];
        [_tiles addObject:tileView];
        [view addSubview:tileView];
    }
}

- (NSMutableArray *)createPropertiesArrayForWord:(NSString *)word {
    NSMutableArray *propertiesArray = [NSMutableArray array];
    
    //get all characters
    _answer = [NSMutableArray array];
    NSMutableArray *characters = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_word length]; i++) {
        NSString *character = [_word substringWithRange:NSMakeRange(i, 1)];
        [characters addObject:character];
        [_answer addObject:character];
    }
    
    //keep shuffling characters until the word is no longer the same
    while ([_word isEqualToString:[self getScrambledTileWordFromCharacters:characters]]) {
        for (int i = 0; i < characters.count*2; i++) { //shuffle many times
            int randomInt1 = arc4random() % [characters count];
            int randomInt2 = arc4random() % [characters count];
            [characters exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
        }
    }
    
    //always evenly split tiles regardless of spacing
    int size = (int) _word.length;
    int spaceTilesCanOccupy = SCREEN_WIDTH - 2 * PADDING;
    int spaceForEachTile = spaceTilesCanOccupy/size; //tile plus padding space
    int paddingForEachTile = (spaceForEachTile - TILE_SIZE)/2; //left or right padding
    int startingPostion = PADDING + paddingForEachTile + TILE_SIZE/2; //add half of tile size for center offset
    
    NSValue *frame = [NSValue valueWithCGRect:CGRectMake(0,0,100,100)];
    
    for (int i = 0; i < [characters count]; i++) {
        NSString *character = [characters objectAtIndex:i];
        NSDictionary *properties = @{
                                     kFrame:frame,
                                     @"letter":character,
                                     kCenter:[NSValue valueWithCGPoint:CGPointMake(startingPostion + i*spaceForEachTile, 650)],
                                     kTag:[NSNumber numberWithInt:TILE_TAG]
                                     };
        [propertiesArray addObject:properties];
    }
    return propertiesArray;
}

- (NSMutableArray *)createPropertiesArrayForScenes:(NSArray *)scenes {
    NSMutableArray *propertiesArray = [NSMutableArray array];
    
    //get the plot.
    _answer = [NSMutableArray array];
    for (int i = 0; i < [_scenes count]; i++) {
        NSDictionary *scene = [_scenes objectAtIndex:i];
        [_answer addObject:[scene objectForKey:@"sentence"]];
    }

    NSMutableArray *copy = [_scenes mutableCopy];
    
    //keep shuffling tiles until order of the scenes is no longer the same
    while ([_scenes isEqualToArray:copy]) {
        for (int i = 0; i < copy.count*2; i++) { //shuffle many times
            int randomInt1 = arc4random() % [copy count];
            int randomInt2 = arc4random() % [copy count];
            [copy exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
        }
    }
    
    NSValue *frame = [NSValue valueWithCGRect:CGRectMake(0,0,240,200)];
    
    int spaceTilesCanOccupy = SCREEN_WIDTH - 2 * PADDING;
    int spaceForTopRow = spaceTilesCanOccupy/3;
    int spaceForBottomRow = spaceTilesCanOccupy/2;
    int startingPositionTop = PADDING + spaceForTopRow/2;
    int startingPositionBottom = PADDING + spaceForBottomRow/2;

    //manually add scenes
    NSDictionary *scene1 = [copy objectAtIndex:0];
    NSDictionary *properties1 = @{
                                 kFrame:frame,
                                 kImageURL:[scene1 objectForKey:kImageURL],
                                 @"sentence":[scene1 objectForKey:@"sentence"],
                                 kCenter:[NSValue valueWithCGPoint:CGPointMake(startingPositionTop, SCREEN_HEIGHT*0.56)],
                                 kTag:[NSNumber numberWithInt:TILE_TAG]
                                 };
    TileView *tileView1 = [[TileView alloc] initWithProperties:properties1];
    [_tiles addObject:tileView1];
    
    NSDictionary *scene2 = [copy objectAtIndex:1];
    NSDictionary *properties2 = @{
                                  kFrame:frame,
                                  kImageURL:[scene2 objectForKey:kImageURL],
                                  @"sentence":[scene2 objectForKey:@"sentence"],
                                  kCenter:[NSValue valueWithCGPoint:CGPointMake(startingPositionTop + spaceForTopRow, SCREEN_HEIGHT*0.56)],
                                  kTag:[NSNumber numberWithInt:TILE_TAG]
                                  };
    TileView *tileView2 = [[TileView alloc] initWithProperties:properties2];
    [_tiles addObject:tileView2];
    
    NSDictionary *scene3 = [copy objectAtIndex:2];
    NSDictionary *properties3 = @{
                                  kFrame:frame,
                                  kImageURL:[scene3 objectForKey:kImageURL],
                                  @"sentence":[scene3 objectForKey:@"sentence"],
                                  kCenter:[NSValue valueWithCGPoint:CGPointMake(startingPositionTop + 2 * spaceForTopRow, SCREEN_HEIGHT*0.56)],
                                  kTag:[NSNumber numberWithInt:TILE_TAG]
                                  };
    TileView *tileView3 = [[TileView alloc] initWithProperties:properties3];
    [_tiles addObject:tileView3];
    
    NSDictionary *scene4 = [copy objectAtIndex:3];
    NSDictionary *properties4 = @{
                                  kFrame:frame,
                                  kImageURL:[scene4 objectForKey:kImageURL],
                                  @"sentence":[scene4 objectForKey:@"sentence"],
                                  kCenter:[NSValue valueWithCGPoint:CGPointMake(startingPositionBottom, SCREEN_HEIGHT*0.85)],
                                  kTag:[NSNumber numberWithInt:TILE_TAG]
                                  };
    TileView *tileView4 = [[TileView alloc] initWithProperties:properties4];
    [_tiles addObject:tileView4];
    
    NSDictionary *scene5 = [copy objectAtIndex:4];
    NSDictionary *properties5 = @{
                                  kFrame:frame,
                                  kImageURL:[scene5 objectForKey:kImageURL],
                                  @"sentence":[scene5 objectForKey:@"sentence"],
                                  kCenter:[NSValue valueWithCGPoint:CGPointMake(startingPositionBottom + spaceForBottomRow, SCREEN_HEIGHT*0.85)],
                                  kTag:[NSNumber numberWithInt:TILE_TAG]
                                  };
    TileView *tileView5 = [[TileView alloc] initWithProperties:properties5];
    [_tiles addObject:tileView5];

    [propertiesArray addObjectsFromArray:@[properties1, properties2, properties3, properties4, properties5]];
    return propertiesArray;
}

- (void)applyGesureRecognizer {
    NSArray *arrToSearchForTiles = self.view.subviews;
    
    for (UIView * view in arrToSearchForTiles) {
        if (view.tag == TILE_TAG) {
            //simple drag
            UIPanGestureRecognizer * recognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            recognizer1.delegate = self;
            [view addGestureRecognizer:recognizer1];
        }
    }
}

- (void) prepareToMove:(TileView *)tileView andViewPoint:(CGPoint)point {
    //NSLog(@"preparedToMove from %f, %f", point.x, point.y);
    [tileView removeShadow];
    [self.view bringSubviewToFront:tileView];
    
    if (_scenes) {
        // scenes should initially scale up
        [self scaleUpView:tileView];
    }
    
    //reset tile and container if moved out of container
    for (TileContainerView *containerView in _containers) {
        if (containerView.containedTile == tileView) {
            tileView.matched = NO;
            containerView.containedTile = nil;
            containerView.containedText = @"";
            //tileView.scaledDown = NO;
        }
    }
}

- (void)movedView:(TileView *)tileView toPoint:(CGPoint)point {
    //NSLog(@"moved to %f, %f", point.x, point.y);
    [tileView removeShadow];
    
    if (_scenes && point.y < SCREEN_HEIGHT*0.28 && !tileView.scaledDown) {
        //NSLog(@"entering top half");
        [self scaleDownView:tileView];
    } else if (_scenes && point.y > SCREEN_HEIGHT*0.35 && !tileView.scaledUp) {
        //NSLog(@"entering bottom half");
        [self scaleUpView:tileView];
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    TileView *tv = (TileView *) recognizer.view;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self prepareToMove:tv andViewPoint:[recognizer locationInView:self.view]];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        
        //scale down to film strip size if close to it
        [self movedView:tv toPoint:[recognizer locationInView:self.view]];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //check if tile is dragged near a container
        [self checkIfTileMatchesAnyContainer:recognizer.view];
        
        if (((TileView *)recognizer.view).matched) {
            //keep position
            
            //make sure to scale down if it's a scene
            if (_scenes && !tv.scaledDown) {
                [self scaleDownView:tv];
            }
            
        } else {
            //animate tile back to original position
            [self resetTileStateGivenTile:tv andViewPoint:[recognizer locationInView:self.view]];
        }
        
        NSMutableArray *result = [self getResult];
        NSLog(@"actual%@", _answer);
        if ([result isEqualToArray:_answer]) {
            [_scrollView removeFromSuperview];
            [Animations congratulateInView:self.view];
        }
    }
}

- (void)scaleUpView:(TileView *)tileView {
    // make sure object is at original size before attempting transformation
    tileView.transform = CGAffineTransformIdentity;
    
    POPSpringAnimation *scaleUp = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleUp.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
    scaleUp.springBounciness = 10.0f;
    scaleUp.springSpeed = 20.0f;
    [tileView pop_addAnimation:scaleUp forKey:@"toUp"];
    
    tileView.scaledDown = NO;
    tileView.scaledUp = YES;
}

- (void)scaleDownView:(TileView *)tileView {
    TileContainerView *container = [_containers firstObject];
    NSUInteger width = container.frame.size.width - 10;
    NSUInteger height = container.frame.size.height - 10;
    
    // make sure object is at original size before attempting transformation
    tileView.transform = CGAffineTransformIdentity;
    
    POPSpringAnimation *scaleDown = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleDown.toValue = [NSValue valueWithCGSize:CGSizeMake(width / tileView.frame.size.width, height / tileView.frame.size.height)];
    scaleDown.springBounciness = 10.0f;
    scaleDown.springSpeed = 20.0f;
    [tileView pop_addAnimation:scaleDown forKey:@"toDown"];
    
    tileView.scaledDown = YES;
    tileView.scaledUp = NO;
}

- (void) resetTileStateGivenTile:(TileView *)tileView andViewPoint:(CGPoint) point {
    [tileView addShadow];
    
    [self animateView:tileView ToPosition:tileView.originalPosition];
    POPSpringAnimation *scaleToOriginal = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleToOriginal.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleToOriginal.springBounciness = 20.0f;
    scaleToOriginal.springSpeed = 20.0f;
    [tileView pop_addAnimation:scaleToOriginal forKey:@"toOriginal"];
}

- (void)checkIfTileMatchesAnyContainer:(UIView *)view {
    TileView *currentTileView = (TileView *)view;
    
    for (TileContainerView *containerView in _containers) {
        
        if ([self view1:currentTileView isCloseToView2:containerView]) { //if close enough to be contained
            
            if (containerView.containedTile) { //if container already has a tile: swap
                
                //animate tile in container back to original position
                [self resetTileStateGivenTile:containerView.containedTile andViewPoint:containerView.center];
                
                //update matched bool
                containerView.containedTile.matched = NO;
                currentTileView.matched = YES;
                
                //assign new tile to container
                containerView.containedTile = currentTileView;
                containerView.containedText = currentTileView.text;
                
            } else {  //else set the containedTile to the currently dragged tile
                
                //update matched bool
                currentTileView.matched = YES;
                
                //assign new tile to container
                containerView.containedTile = currentTileView;
                containerView.containedText = currentTileView.text;
            }
            
            //animate to center of container
            [self animateView:containerView.containedTile ToPosition:containerView.center];
        }
    }
}

- (BOOL)view1:(UIView *)view1 isCloseToView2:(UIView *)view2 {
    int xDiff = abs(view1.center.x - view2.center.x);
    int yDiff = abs(view1.center.y - view2.center.y);
    if ((xDiff < 50) && (yDiff < 70)) {
        return YES;
    }
    return NO;
}

- (void)animateView:(UIView *)view ToPosition:(CGPoint) position {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         view.center = position;
                     }
                     completion:^(BOOL finished) {}];
}

- (NSMutableArray *)getResult {
    NSMutableArray *result = [NSMutableArray array];
    for (TileContainerView *containerView in _containers) {
        [result addObject:containerView.containedText];
    }
    NSLog(@"result scene: %@", result);
    return result;
}

- (NSString *)getScrambledTileWordFromCharacters:(NSMutableArray *)characters {
    NSString *result = [[NSString alloc]init];
    for (NSString *character in characters) {
        result = [result stringByAppendingString:character];
    }
    return result;
}

@end
