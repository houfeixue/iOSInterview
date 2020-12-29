//
//  LKWeakProxy.h
//  InterView
//
//  Created by heshenghui on 2020/5/12.
//  Copyright © 2020 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKWeakProxy : NSProxy
@property(nonatomic,weak)id target;
-(instancetype) initWithTarget:(id)target;
+(instancetype) proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
