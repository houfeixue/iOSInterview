//
//  ModelJson.m
//  InterView
//
//  Created by heshenghui on 2019/12/6.
//  Copyright © 2019 Company. All rights reserved.
//

#import "ModelJson.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation ModelJson


-(instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    
    if (self) {
        for (NSString * key in dic.allKeys) {
            
            //objc_msgSend(void /* id self, SEL op, .value. */ )
            id value = dic[key];
            NSString * methodName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
            
            SEL sel = NSSelectorFromString(methodName);
            
            if (sel) {
               ((void(*)(id,SEL,id))objc_msgSend)(self,sel,value);
            }
        
        }
    }
    
    return self;
    
}

-(NSDictionary *)convertModelToDic{
    
//    unsigned int count = 0;
//    objc_property_t properties = class_copyPropertyList(self, &count);
//    
//    if (count != 0) {
//        NSMutableDictionary * tempDic = [@{} mutableCopy];
//        
//        for (int i=0 ; i<count; i++) {
//            const void *propertyName = property_getName(properties[i]);
//            
//            NSString * name = [NSString stringWithUTF8String:propertyName];
//            
//            SEL sel = NSSelectorFromString(name);
//            
//            if (sel) {
//                id value = ((id(*)(id,SEL))objc_msgSend)(self,sel);
//                
//                if (value) {
//                    [tempDic setValue:value forKey:name];
//                }else{
//                    tempDic[name] = @"";
//                }
//                
//                
//                
//                
//            }
//            
//            
//        }
//        
//        free(properties);
//        return tempDic;
//        
//    }
//    free(properties);

    return nil;
}

@end
