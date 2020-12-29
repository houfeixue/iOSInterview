//
//  TestModelTest.m
//  InterViewTestMyCalss
//
//  Created by heshenghui on 2020/5/20.
//  Copyright © 2020 Company. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestModel.h"
@interface TestModelTest : XCTestCase

@end

@implementation TestModelTest
- (void)testInitializer {
    TestModel *album = [[TestModel alloc] init]; XCTAssert(album, @"Album alloc-init failed");
    [album log];
    
    [self measureBlock:^{

            // Put the code you want to measure the time of here.

            for (int i =0; i<1000; i++) {

                NSLog(@"this is a example");

            }

        }];

    
}
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
