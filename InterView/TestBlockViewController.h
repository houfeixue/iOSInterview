//
//  TestBlockViewController.h
//  InterView
//
//  Created by heshenghui on 2019/12/3.
//  Copyright © 2019 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestBlockViewController : UIViewController

@property(nonatomic,copy) void(^Block)(NSString * str) ;
@property(nonatomic,copy) NSString * str  ;


@end

NS_ASSUME_NONNULL_END
