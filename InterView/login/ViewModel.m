//
//  ViewModel.m
//  InterView
//
//  Created by heshenghui on 2019/10/18.
//  Copyright © 2019 Company. All rights reserved.
//

#import "ViewModel.h"
#import "Net.h"
@implementation ViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        RACSignal * userNameLengthSig = [RACObserve(self, name)map:^id(NSString * value) {
            if (value.length > 6) {
                return @(YES);
            }
            return @(NO);
        }];
        RACSignal * passwordLengthSig = [RACObserve(self, password)map:^id(NSString * value) {
            if (value.length > 6) {
                return @(YES);
            }
            return @(NO);
        }];
        
        RACSignal * loginBtnEnable = [RACSignal combineLatest:@[userNameLengthSig,passwordLengthSig] reduce:^id (NSNumber *userName, NSNumber *password){
            return @([userName boolValue] && [password boolValue]);
        }];
        
        _loginCommand = [[RACCommand alloc]initWithEnabled:loginBtnEnable signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [Net loginWithUserName:self.name password:self.password];
        }];
    }
    return self;
}


@end
