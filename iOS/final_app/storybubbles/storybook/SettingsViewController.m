//
//  SettingsViewController.m
//  storybubbles
//
//  Created by Romi Phadte on 5/7/15.
//  Copyright (c) 2015 ioet. All rights reserved.
//

#import "SettingsViewController.h"
#import "FirestormManager.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_textView setText:[[[FirestormManager sharedInstance] devices] description]];
    
    [[FirestormManager sharedInstance] write:@"low"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"Dismissed");
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
