//
//  PagesViewController.m
//  storybook
//
//  Created by Romi Phadte 05/01/15.
//  Copyright (c) 2015 IOET. All rights reserved.
//

#import "PagesViewController.h"
#import "BasePageViewController.h"
#import "VoicePageViewController.h"
#import "DrawingPageViewController.h"
#import "UnscramblePageViewController.h"
#import "DrawingPrompterViewController.h"
#import <BuiltIO/BuiltIO.h>
#import "F4Actuator.h"

@interface PagesViewController ()
@property (nonatomic, strong) NSMutableArray *vcs;
@property (nonatomic, strong) NSArray *pages;
@end

@implementation PagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    BuiltQuery *storyQuery = [BuiltQuery queryWithClassUID:@"story"];
    [storyQuery whereKey:@"title" equalTo:self.title];
    
    // Uncomment to print out assets for the story
//    [storyQuery exec:^(QueryResult *result, ResponseType type) {
//        NSLog(@"%@", [[[result getResult] objectAtIndex:0] objectForKey:@"assets"]);
//    } onError:^(NSError *error, ResponseType type) {
//        // query execution failed.
//        // error.userinfo contains more details regarding the same
//        NSLog(@"%@", error.userInfo);
//    }];
    
    BuiltQuery *pagesQuery = [BuiltQuery queryWithClassUID:@"page"];
    [pagesQuery inQuery:storyQuery forKey:@"story"];
    [pagesQuery orderByAscending:@"number"];
    
    self.vcs = [NSMutableArray array];
    
    NSString *serverAddress=[[Helper serverURL] stringByAppendingString:@"/stories/1/ipad_output"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString* bookData=[[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    NSDictionary *jsonBookData;
    jsonBookData= [NSJSONSerialization JSONObjectWithData: response1//[stringData dataUsingEncoding:NSUTF8StringEncoding]
                                                           options: NSJSONReadingMutableContainers
                                                             error: NULL];
    NSArray *book=jsonBookData[@"story"];
    
    //[pagesQuery exec:^(QueryResult *result, ResponseType type) {
        // the query has executed successfully.
        // [result getResult] will contain a list of objects that satisfy the conditions
        // here's the object we just created
        //_pages = [result getResult];
        if ([book count] == 0) {
            [[self navigationController] popViewControllerAnimated:YES];
            NSLog(@"Can't find that book");
            return;
        }
        NSString *stringData;
        NSDictionary *jsonPageData;
        BasePageViewController *tmpVC;
        
        for (NSDictionary *page in book) {
//            stringData = [page objectForKey:@"data"];
//            jsonPageData = [NSJSONSerialization JSONObjectWithData: [stringData dataUsingEncoding:NSUTF8StringEncoding]
//                                                           options: NSJSONReadingMutableContainers
//                                                             error: NULL];
            jsonPageData=page;
            NSArray *devices_data=jsonPageData[@"actuator_labels"];
            
            NSArray *textLabels = [jsonPageData objectForKey:@"text_labels"];
            NSArray *imageLabels = [jsonPageData objectForKey:@"image_labels"];
            
            NSString *className = [jsonPageData objectForKey:@"type"];
            NSString *word = [jsonPageData objectForKey:@"word"];
            NSArray *scenes = [jsonPageData objectForKey:@"scenes"];
            Class class = NSClassFromString(className);
            if (word != NULL){
                tmpVC = [[class alloc] initWithTextLabels:textLabels andImageViews:imageLabels andWord:word];
            } else if (scenes != NULL) {
                tmpVC = [[class alloc] initWithTextLabels:textLabels andImageViews:imageLabels andScenes:scenes];
            } else {
                tmpVC = [[class alloc] initWithTextLabels:textLabels andImageViews:imageLabels];
            }
           
            NSMutableArray *devices=[[NSMutableArray alloc] init];
            for (int i=0; i<[devices_data count]; i++){
                [devices addObject:[[F4Actuator alloc]initWithDict:devices_data[i]]];
            }
           
            [tmpVC setdevices:devices];
            
            [self.vcs addObject:tmpVC];
        }
        
        NSArray *viewControllers = [NSArray arrayWithObjects:[self.vcs objectAtIndex:0], nil];
        
        [self setViewControllers:viewControllers
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
        
        self.dataSource = self;
//    } onError:^(NSError *error, ResponseType type) {
//        // query execution failed.
//        // error.userinfo contains more details regarding the same
//        NSLog(@"%@", error.userInfo);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
        
    NSUInteger index = [_vcs indexOfObject:viewController];
    NSUInteger newIndex = index - 1;
    
    if (index == 0) {
        [[self navigationController] popViewControllerAnimated:YES];
        return nil;
    }
    
    
    BasePageViewController* newVC=[_vcs objectAtIndex:newIndex];
    [self actuateDevicesForPage:newVC andIndex:newIndex];
    
    return newVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [_vcs indexOfObject:viewController];
    
    NSUInteger newIndex = index + 1;
    
    if (newIndex == [_vcs count]) {
        // Clashes with summary page draggin.
        //[[self navigationController] popViewControllerAnimated:NO];
        return nil;
    }
   
    BasePageViewController* newVC=[_vcs objectAtIndex:newIndex];
    [self actuateDevicesForPage:newVC andIndex:newIndex];
    
    return newVC;
}

-(void) actuateDevicesForPage:(BasePageViewController *) newVC andIndex:(NSUInteger) index{
    
    
    NSString *serverAddress=[[Helper serverURL] stringByAppendingString:[NSString stringWithFormat:@"/smart_story/advance_story?story_id=1&page_number=%lu",index]];
    //NSString *serverAddress=[[Helper serverURL] stringByAppendingString:@"/smart_story/advance_story"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    //[request setValue:@"1" forHTTPHeaderField:@"story_id"];
    //[request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)index] forHTTPHeaderField:@"page_number"];
    
    
    
    NSMutableArray *UUIDs=[[NSMutableArray alloc]init];
    for(int i=0; i<[[newVC devices] count]; i++){
        [UUIDs addObject:((F4Actuator*)[newVC devices][i]).UUID];
    }
    
    NSMutableDictionary* uuid_dic=[NSMutableDictionary dictionaryWithObject:UUIDs forKey:@"UUID"];
    [uuid_dic setObject:@"1" forKey:@"story_id"];
    [uuid_dic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)index] forKey:@"page_number"];
    
    NSDictionary*data=[[NSDictionary alloc] initWithObjects:@[uuid_dic] forKeys:@[@"data"]];
    
    NSError *error;
    NSData *body=[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    //[request setHTTPBody: body];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    [NSURLConnection sendAsynchronousRequest:request queue:NSOperationQueuePriorityNormal completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString* responseString=[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
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
