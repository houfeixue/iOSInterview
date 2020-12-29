//
//  LoginViewController.m
//  InterView
//
//  Created by heshenghui on 2019/10/18.
//  Copyright © 2019 Company. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewModel.h"
@interface LoginViewController ()
@property (nonatomic, strong) ViewModel *viewModel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextField * t1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    t1.placeholder = @"qwe";
    [self.view addSubview:t1];
    
     UITextField * t2 = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, 100, 100)];
    t2.placeholder = @"qwe";
    [self.view addSubview:t2];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(0, 200, 100, 100);
    [self.view addSubview:btn];
    
    RAC(self.viewModel,name) = t1.rac_textSignal;
    RAC(self.viewModel,password) = t2.rac_textSignal;
    @weakify(self)
    
    [[self.viewModel.loginCommand executionSignals]subscribeNext:^(RACSignal * x) {
                 @strongify(self)
                 [x subscribeNext:^(NSString *x) {
                     NSLog(@"%@",x);
                 }];
             }];
}

-(ViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[ViewModel alloc]init];
    }
    return _viewModel;
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
