//
//  TestBlockViewController.m
//  InterView
//
//  Created by heshenghui on 2019/12/3.
//  Copyright © 2019 Company. All rights reserved.
//

#import "TestBlockViewController.h"

@interface TestBlockViewController ()

@end

@implementation TestBlockViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.str = @"";
    self.view.backgroundColor = [UIColor blueColor];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if (_Block ){
        
        _Block(@"qwre");
    }
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)dealloc
{
    NSLog(@"TestBlockViewController delloc");
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
