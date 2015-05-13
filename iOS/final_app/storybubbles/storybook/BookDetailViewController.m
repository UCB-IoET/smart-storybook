//
//  BookDetailViewController.m
//  storybook
//
//  Created by Gavin Chu on 12/1/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "BookDetailViewController.h"
#import "PagesViewController.h"

@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openBook:(UIButton *)sender {
    [self performSegueWithIdentifier:@"story" sender:self.parentViewController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"story"]) {
        PagesViewController *controller = (PagesViewController *)segue.destinationViewController;
        controller.title = _bookTitle.text;
    }
}

@end
