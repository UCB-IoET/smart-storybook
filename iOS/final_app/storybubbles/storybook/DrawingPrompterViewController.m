//
//  DrawingPrompterViewController.m
//  storybook
//
//  Created by Romi Phadte on 11/18/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "DrawingPageViewController.h"
#import "DrawingPrompterViewController.h"

@interface DrawingPrompterViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DrawingPrompterViewController

bool firstLoad = TRUE;
bool hintText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageView = [[UIImageView alloc] init];
    
    [self.imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.imageView.layer setBorderWidth: 2.0];
    
    
    
    self.imageView.frame = CGRectMake(530, 9, 400, 200);
    self.imageView.backgroundColor = [UIColor whiteColor];
    
    // TODO load any images the user has drawn for this before
    // Don't hint if drawn b4.
    UIFont *font = [UIFont fontWithName:@"Chalkduster" size:60.0];
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    CGRect rect = CGRectMake(50, 20, self.imageView.frame.size.width - 100, self.imageView.frame.size.height);
    [[UIColor blackColor] set];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [@"Tap here to draw!" drawInRect:CGRectIntegral(rect) withAttributes:@{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle}];
    hintText = true;
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = newImage;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptDrawing)];
    
    self.imageView.userInteractionEnabled = YES; // allow taps on image.
    [self.imageView addGestureRecognizer:singleTap];
    
    [self.view addSubview:self.imageView];
    firstLoad = TRUE;
}


- (void) viewDidAppear:(BOOL)animated {
    if (!firstLoad) {
        return;
    }
    firstLoad = FALSE;
    [super viewDidAppear:animated];
}

- (void)promptDrawing
{
    if(hintText) {
        hintText = FALSE;
        self.imageView.image = nil;
    }
    DrawingPageViewController *dpvc = [[DrawingPageViewController alloc] initWithImage:self.imageView.image];
    
    dpvc.presenter = self;
    
    [self presentViewController:dpvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCustomImage:(UIImage *)image {
    [self.imageView setImage:image];
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
