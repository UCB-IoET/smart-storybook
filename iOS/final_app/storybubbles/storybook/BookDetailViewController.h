//
//  BookDetailViewController.h
//  storybook
//
//  Created by Gavin Chu on 12/1/14.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (strong, nonatomic) IBOutlet UILabel *bookIllustrator;
@property (weak, nonatomic) IBOutlet UITextView *bookDescription;
@property (weak, nonatomic) IBOutlet UIButton *readButton;

@end
