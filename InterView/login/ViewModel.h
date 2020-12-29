//
//  ViewModel.h
//  InterView
//
//  Created by heshenghui on 2019/10/18.
//  Copyright © 2019 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end

NS_ASSUME_NONNULL_END
