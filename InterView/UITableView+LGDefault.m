//
//  UITableView+LGDefault.m
//  InterView
//
//  Created by heshenghui on 2019/12/6.
//  Copyright © 2019 Company. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "UITableView+LGDefault.h"

#import <objc/runtime.h>

UIView * const LGDefaultView = nil;

@implementation UITableView (LGDefault)

+ (void)load{
    

    Method originMethod = class_getInstanceMethod(self, @selector(reloadData));
    
    Method currendMethod = class_getInstanceMethod(self, @selector(lg_reloadData));
    
    method_exchangeImplementations(originMethod, currendMethod);
    
    
}

-(void)lg_reloadData{
    
    
    [self lg_reloadData];
    [self fillDefaultView];
    
}

-(void)fillDefaultView{
    
    
    id<UITableViewDataSource> dataSourse = self.dataSource;
    NSInteger section = ([dataSourse respondsToSelector:@selector(numberOfSectionsInTableView:)] ? [dataSourse numberOfSectionsInTableView:self] : 1);
    NSInteger rows = 0;
    for (int i=0; i<section; i++) {
        rows = [dataSourse tableView:self numberOfRowsInSection:i];
    }
    
    if (!rows) {
        self.lgDefaultView = [UIView new];
    }else{
        
        
    }
    
    
}

-(void)setLgDefaultView:(UIView *)lgDefaultView
{
    
    objc_setAssociatedObject(self, &LGDefaultView, lgDefaultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)lgDefaultView{
    
   return objc_getAssociatedObject(self, &LGDefaultView);
}

@end
