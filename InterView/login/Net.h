//
//  Net.h
//  InterView
//
//  Created by heshenghui on 2019/10/18.
//  Copyright © 2019 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Net : NSObject
+ (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
