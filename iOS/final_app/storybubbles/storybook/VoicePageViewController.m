//
//  VoicePageViewController.m
//  storybook
//
//  Created by Alice J. Liu on 2014-11-17.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "VoicePageViewController.h"
@import AVFoundation;

@interface VoicePageViewController ()

@end

@implementation VoicePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_recordButton addTarget:self
               action:@selector(recordAudio:)
     forControlEvents:UIControlEventTouchUpInside];
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    _recordButton.frame = CGRectMake(80.0, 310.0, 160.0, 40.0);
    [self.view addSubview:_recordButton];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_playButton addTarget:self
                      action:@selector(playAudio:)
            forControlEvents:UIControlEventTouchUpInside];
    [_playButton setTitle:@"Play" forState:UIControlStateNormal];
    _playButton.frame = CGRectMake(80.0, 410.0, 160.0, 40.0);
    [self.view addSubview:_playButton];
    
    _playButton.hidden = YES;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }
}

- (IBAction)recordAudio:(id)sender {
    if (!_audioRecorder.recording)
    {
        [_audioRecorder record];
        [_recordButton setTitle:@"stop" forState:UIControlStateNormal];
    } else {
        [_audioRecorder stop];
        [_recordButton setTitle:@"record" forState:UIControlStateNormal];
         _playButton.hidden = NO;
    }
}

- (IBAction)playAudio:(id)sender {
    if (!_audioRecorder.recording)
    {
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:_audioRecorder.url
                        error:&error];
        _audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else {
            [_audioPlayer play];
            _playButton.enabled = NO;
        }
    }
}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _playButton.enabled = YES;
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

