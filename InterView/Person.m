//
//  Person.m
//  InterView
//
//  Created by heshenghui on 2019/12/6.
//  Copyright © 2019 Company. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "SpareWheel.h"

@implementation Person

void sendMessage(id self,SEL _cmd,NSString * msg){
    NSLog(@"----%@",msg);
    
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    //匹配方法名称
    NSString * methodString = NSStringFromSelector(sel);
    if ([methodString isEqualToString:@"sendMessage:"]) {
        return class_addMethod(self, sel, (IMP)sendMessage, "v@:@");
    }
    return NO;
}


- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    //匹配方法名称
       NSString * methodString = NSStringFromSelector(aSelector);
       if ([methodString isEqualToString:@"sendMessage:"]) {
           return [SpareWheel new];
       }
    return [super forwardingTargetForSelector:aSelector];
     
}


//1.方法签名
//2.消息转发
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
    //匹配方法名称
      NSString * methodString = NSStringFromSelector(aSelector);
      if ([methodString isEqualToString:@"sendMessage:"]) {
          return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
      }
    
    return [super methodSignatureForSelector:aSelector];
    
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = [anInvocation selector];
    SpareWheel * temObj = [SpareWheel new];
    if ([temObj respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:temObj];
    }else {
        [super forwardInvocation:anInvocation];
    }
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"not found");
    
}


@end
