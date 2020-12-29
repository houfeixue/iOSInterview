//
//  Net.m
//  InterView
//
//  Created by heshenghui on 2019/10/18.
//  Copyright © 2019 Company. All rights reserved.
//

#import "Net.h"

@implementation Net

+ (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:[NSString stringWithFormat:@"User %@, password %@, login!",name, password]];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

@end
