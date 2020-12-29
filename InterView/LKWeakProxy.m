//
//  LKWeakProxy.m
//  InterView
//
//  Created by heshenghui on 2020/5/12.
//  Copyright © 2020 Company. All rights reserved.
//

#import "LKWeakProxy.h"

@implementation LKWeakProxy

-(instancetype) initWithTarget:(id)target
{
    _target = target;
    return self;
}

+(instancetype) proxyWithTarget:(id)target
{
    return [[LKWeakProxy alloc]initWithTarget:target];
}

// 上图可见当找不到对应SEL的时候执行此方法，手动返回self，开始执行方法
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

// 对所有的不能处理的都传递给_target了,理论上是不需要写下面两个方法的，但是因为target 是weak引用的，所以还是写了下面两个方法，防止crash。

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}


@end
