//
//  VoicePageViewController.h
//  storybook
//
//  Created by Alice J. Liu on 2014-11-17.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BasePageViewController.h"

@interface VoicePageViewController : BasePageViewController
<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) UIButton *recordButton;
@property (weak, nonatomic) UIButton *playButton;

- (IBAction)recordAudio:(id)sender;
- (IBAction)playAudio:(id)sender;

@end
