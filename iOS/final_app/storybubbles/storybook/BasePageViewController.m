//
//  SampleViewController.m
//  storybook
//
//  Created by Romi Phadte 05/01/15.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "BasePageViewController.h"
@import AVFoundation;

@interface BasePageViewController ()  <AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (strong, nonatomic) NSMutableArray *textLabels;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSMutableArray *utterances;
@property (nonatomic, assign) NSUInteger nextSpeechIndex;

@end

@implementation BasePageViewController
CGRect screenRect;

- (id)init {
    self = [super init];
    
    if (self != nil)
    {
        // Further initialization if needed
    }
    return self;
}

- (id)initWithTextLabels:(NSArray *)textLabels andImageViews:(NSArray *) imageViews {
    self = [super init];

    if (self != nil)
    {
        screenRect = [[UIScreen mainScreen] bounds];
        
        [self createImageViews:imageViews];
        [self createTextLabels:textLabels];
        
        self.nextSpeechIndex = 0;
    }
    
    return self;
}

- (void)createImageViews:(NSArray *)imageViews {
    _imageViews = [[NSMutableArray alloc] init];
    CGFloat SCREEN_WIDTH = screenRect.size.width;
    CGFloat SCREEN_HEIGHT = screenRect.size.height;
    
    for (int i = 0; i < [imageViews count]; i++) {
        NSDictionary *imageDict = [imageViews objectAtIndex:i];
        
        NSString *imageName = [imageDict objectForKey:kImageName];
        UIImageView *imageView;
        
        if (imageName != NULL) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageDict objectForKey:kImageName]]];
        } else {
            imageView = [[UIImageView alloc] init];
        }
        
        NSString *imageURL = [imageDict objectForKey:kImageURL];
        imageURL=[[Helper serverURL] stringByAppendingString:imageURL];
        if (imageURL != NULL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                
                //set your image on main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView setImage:[UIImage imageWithData:data]];
                });
            });
        }
        NSArray *centerValue = [imageDict objectForKey:kCenter];
        NSArray *imageSize = [imageDict objectForKey:kImageSize];
        
        if (imageSize) {
            imageView.frame = CGRectMake(0, 0, [imageSize[0] floatValue] * SCREEN_WIDTH, [imageSize[1] floatValue] * SCREEN_HEIGHT);
        } else {
            imageView.frame = CGRectMake(0, 0, 200, 200);
        }
        
        if (centerValue) {
            // Center is set after the frame is ready.
            CGFloat x = [centerValue[0] floatValue] * SCREEN_WIDTH;
            CGFloat y = [centerValue[1] floatValue] * SCREEN_HEIGHT;
            imageView.center = CGPointMake(x, y);
        }
        
        [_imageViews addObject:imageView];
    }
}

- (void)createTextLabels:(NSArray *)textLabels {
    _textLabels = [[NSMutableArray alloc] init];
    _utterances = [[NSMutableArray alloc] init];
    CGFloat SCREEN_WIDTH = screenRect.size.width;
    CGFloat SCREEN_HEIGHT = screenRect.size.height;

    for (int i = 0; i < [textLabels count]; i++) {
        NSDictionary *textDict = [textLabels objectAtIndex:i];
        
        NSString *fontName = [textDict objectForKey:kFontName];
        NSNumber *fontSize = [textDict objectForKey:kFontSize];
        NSNumber *textAlignment = [textDict objectForKey:kTextAlignment];
        UIColor *textBackgroundColor = [textDict objectForKey:kTextBackgroundColor];
        NSString *textBackgroundHex = [textDict objectForKey:kTextBackgroundHex];
        NSNumber *textBackgroundAlpha = [textDict objectForKey:kTextBackgroundAlpha];
        UIColor *textColor = [textDict objectForKey:kTextColor];
        NSNumber *border = [textDict objectForKey:kBorder];
        NSArray *centerValue = [textDict objectForKey:kCenter];
        
        UIBorderLabel *textLabel = [[UIBorderLabel alloc] init];
        textLabel.text = [textDict objectForKey:kText];
        
        if (fontName && fontSize) {
            textLabel.font = [UIFont fontWithName:fontName size:[fontSize floatValue]];
        } else if (fontName) {
            textLabel.font = [UIFont fontWithName:fontName size:16.0f];
        } else if (fontSize) {
            textLabel.font = [UIFont fontWithName:@"Gill Sans" size:[fontSize floatValue]];
        }
        
        [Helper reassignFrameSizeToMinimumEnclosingSize:textLabel];
        
        if (centerValue) {
            // Center is set after the frame is ready.
            CGFloat x = [centerValue[0] floatValue] * SCREEN_WIDTH;
            CGFloat y = [centerValue[1] floatValue] * SCREEN_HEIGHT;
            textLabel.center = CGPointMake(x, y);
        }
        
        if (textAlignment != NULL) {
            textLabel.textAlignment = [textAlignment intValue];
        } else {
            textLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        if (textColor != NULL) {
            textLabel.textColor = textColor;
        }
        
        if (border) {
            float borderValue = [border floatValue];
            textLabel.frame = CGRectInset(textLabel.frame, -borderValue, -borderValue);
            textLabel.leftInset = borderValue;
        }
        
        if (textBackgroundColor != NULL) {
            textLabel.backgroundColor = textBackgroundColor;
        }
        
        if(textBackgroundHex != NULL) {
            if (textBackgroundAlpha != NULL) {
                textLabel.backgroundColor = [Helper colorWithHexString:textBackgroundHex andAlpha:[textBackgroundAlpha floatValue]];
            } else {
                textLabel.backgroundColor = [Helper colorWithHexString:textBackgroundHex];
            }
        }
        
        textLabel.numberOfLines = 0; // infinite potential lines
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [textLabel addGestureRecognizer:tapGestureRecognizer];
        textLabel.userInteractionEnabled = YES;
        [_textLabels addObject:textLabel];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:textLabel.text];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        //[utterance setValuesForKeysWithDictionary:utteranceProperties];
        [_utterances addObject:utterance];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    for (int i = 0; i < [_imageViews count]; i++) {
        [self.view addSubview:[_imageViews objectAtIndex:i]];
    }
    
    for (int i = 0; i < [_textLabels count]; i++) {
        [self.view addSubview:[_textLabels objectAtIndex:i]];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.nextSpeechIndex = 0;
    [self startSpeaking];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)labelTapped:(UIGestureRecognizer *) gestureRecognizer {
     UILabel *tappedLabel = (UILabel*) [gestureRecognizer.view hitTest:[gestureRecognizer locationInView:gestureRecognizer.view] withEvent:nil];
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:[tappedLabel text]];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = (AVSpeechUtteranceMinimumSpeechRate + AVSpeechUtteranceDefaultSpeechRate)*0.4;
    
    AVSpeechSynthesizer *speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    speechSynthesizer.delegate = self;
    [speechSynthesizer speakUtterance:utterance];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Speech Management

- (void)speakNextUtterance
{
    if (self.nextSpeechIndex < [_utterances count]) {
        AVSpeechUtterance *utterance = [_utterances objectAtIndex:self.nextSpeechIndex];
        utterance.rate = (AVSpeechUtteranceMinimumSpeechRate + AVSpeechUtteranceDefaultSpeechRate)*0.4;
        self.nextSpeechIndex += 1;
        
        [self.synthesizer speakUtterance:utterance];
    }
}


- (void)startSpeaking
{
    if (!self.synthesizer) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.synthesizer.delegate = self;
    }
    
    [self speakNextUtterance];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSString *s = utterance.speechString;
    
    [self expandTextFor:s];
}

- (void)expandTextFor:(NSString *)s
{
    UILabel *l = [self labelForString:s];
    
    POPSpringAnimation *scaleUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleUp.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleUp.toValue = [NSValue valueWithCGSize:CGSizeMake(1.1f, 1.1f)];
    scaleUp.springBounciness = 1.0f;
    scaleUp.springSpeed = 20.0f;
    
    [l.layer pop_addAnimation:scaleUp forKey:@"first"];
}

- (void)unexpandTextFor:(NSString *)s
{
    UILabel *l = [self labelForString:s];
    
    POPSpringAnimation *scaleUp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleUp.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.1f, 1.1f)];
    scaleUp.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleUp.springBounciness = 1.0f;
    scaleUp.springSpeed = 20.0f;
    
    [l.layer pop_addAnimation:scaleUp forKey:@"second"];
}

- (UILabel *)labelForString:(NSString *)s
{
    for (int i = 0; i < [_textLabels count]; i++) {
        UILabel *l = [_textLabels objectAtIndex:i];
        if (l.text == s) {
            return l;
        }
    }
    return nil;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance
{
    NSUInteger indexOfUtterance = [_utterances indexOfObject:utterance];
    [self unexpandTextFor:utterance.speechString];
    if (indexOfUtterance == NSNotFound) {
        return;
    }
    
    [self speakNextUtterance];
}

@end
