//
//  TimersViewController.m
//  InterView
//
//  Created by heshenghui on 2020/5/12.
//  Copyright © 2020 Company. All rights reserved.
//

#import "TimersViewController.h"
#import "LKWeakProxy.h"
@interface TimersViewController ()

@property(nonatomic,strong)LKWeakProxy * targrt;

@end

@implementation TimersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _targrt = [LKWeakProxy alloc];
    _targrt.target = self;
    
   NSTimer  * timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:_targrt selector:@selector(testTimer) userInfo:nil repeats:YES];
}
-(void)testTimer
{
    NSLog(@"123");
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
