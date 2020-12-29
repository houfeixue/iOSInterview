//
//  TestCopyViewController.m
//  InterView
//
//  Created by heshenghui on 2019/12/9.
//  Copyright © 2019 Company. All rights reserved.
//

#import "TestCopyViewController.h"
#import "TestModel.h"

@interface TestCopyViewController ()




@end

@implementation TestCopyViewController


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    NSLog(@"didMoveToParentViewController");
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     NSLog(@"viewDidDisappear");
}

-(void)dealloc
{
    NSLog(@"dealloc");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self testMutableArray];
//    NSMutableArray * data = [[NSMutableArray alloc]initWithObjects:@"1",@"3",@"5",@"7",@"9",@"2",@"4",@"6",@"8", nil];
//    NSInteger key = data.count % 2 == 0 ? 0 : 1;
//
//    [self quickSortArray:data leftIndex:0 rightIndex:data.count -1];
//    [self testMutableArray];
     [self testCopy];
    
}

//冒泡排序
- (void)bubbleSortWithArray:(NSMutableArray *)array {
    
    for (int i=0; i < array.count - 1; i++) {
        for (int j=0; array.count -1 -i; j++) {
            if ([array[j] integerValue] < [array[j+1] integerValue]) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}
//快速排序代码示例
- (void)quickSortArray:(NSMutableArray *)arr
 leftIndex:(NSInteger)left
            rightIndex:(NSInteger)right{
    
    NSLog(@"%@",arr);
    /* 如果数组长度为0或者已经遍历完（即left=right）时返回  **/
    if (left >= right) {
        return;
    }
    /* 记录比较基准数 **/
    int key = [arr[left] intValue];
    NSLog(@"比较基准数 : %d",key);
    int i = left;
    int j = right;
    
    while (i<j) {
        /* 首先从右边j开始查找比基准数小的值 **/
        while (i<j && [arr[j] intValue] >= key) {/// 如果比基准数大，继续查找
            j--;
        }
        /* 如果比基准数小，则将查找到的小值调换到i的位置 **/
        arr[i] = arr[j];
        /* 当在右边查找到一个比基准数小的值时，就从i开始往后找比及基准数大的值 **/
        while (i<j && [arr[i] intValue] <= key) { ///如果比基准数小，继续查找
            i++;
        }
        /* 如果比基准数大，则将查找到的大值调换到j的位置 **/
        arr[j] = arr[i];
    }
    /* 将基准数放到正确位置 **/
    arr[i] = [NSString stringWithFormat:@"%d",key];
    /* 递归排序 **/
    /* 排序基准数左边的 **/
    [self quickSortArray:arr leftIndex:left rightIndex:i-1];
    /* 排序基准数右边的 **/
    [self quickSortArray:arr leftIndex:i+1 rightIndex:right];
    
}

//选择排序算法
- (void)selectSortWithArray:(NSMutableArray *)array {
    
    for (int i=0; i<array.count; i++) {
        for (int j = i + 1; j < array.count; j++) {
            if (array[i] > array[j]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }

}

//插入排序(insert sort)

- (void)insertSortWithArray:(NSMutableArray *)array {
    
     NSInteger j;
    for (NSInteger i = 1; i < array.count; i++) {
        
         //取出每一个待插入的数据，从array[1]开始查找
        NSInteger temp = [array[i] integerValue];
        for (j = i - 1; j >= 0 && temp < [array[j] integerValue]; j--) {
                   //如果之前的数比temp大，就将这个数往后移动一个位置，留出空来让temp插入，和整理扑克牌类似
                   array[j + 1] = array[j] ;
                   array[j] = [NSNumber numberWithInteger:temp];
               }
        
    }

}

-(void)testMutableArray{
    
    NSString * str1 = @"1";
    NSLog(@"str1  :  %p--->%@",str1,str1);

    NSString * str2 = @"2";
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithObjects:str1,str2 ,nil];
    NSLog(@"array  : %p  -> %@  [0] : %p--->%@",array,array,array[0],array[0]);

    NSArray * copyArray = [array copy];
    NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@",copyArray,copyArray,copyArray[0],copyArray[0]);
    NSMutableArray * mutableCopyArray = [array mutableCopy];
    NSLog(@"mutableCopyArray  : %p  -> %@  [0] : %p--->%@" ,mutableCopyArray,mutableCopyArray,mutableCopyArray[0],mutableCopyArray[0]);
    
    NSLog(@"___________________修改值____________________");
    
    str1 = @"3";
    
     NSLog(@"array  : %p  -> %@  [0] : %p--->%@",array,array,array[0],array[0]);
    
     NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@",copyArray,copyArray,copyArray[0],copyArray[0]);
    
     NSLog(@"mutableCopyArray  : %p  -> %@  [0] : %p--->%@" ,mutableCopyArray,mutableCopyArray,mutableCopyArray[0],mutableCopyArray[0]);

    
}
-(void)testArrayModel{
    TestModel * model1 = [[TestModel alloc]init];
    model1.name = @"1";
    
    NSLog(@"model1  :  %p--->%@  %p  ---> %@",model1,model1,model1.name,model1.name);

    TestModel * model2 = [[TestModel alloc]init];
    model2.name = @"2";

    NSArray * array = @[model1,model2];
    NSLog(@"array  : %p  -> %@  [0] : %p--->%@",array,array,array[0],array[0]);
    NSArray * copyArray = [array copy];
    NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@",copyArray,copyArray,copyArray[0],copyArray[0]);
    NSMutableArray * mutableCopyArray = [array mutableCopy];
    NSLog(@"mutableCopyArray  : %p  -> %@  [0] : %p--->%@" ,mutableCopyArray,mutableCopyArray,mutableCopyArray[0],mutableCopyArray[0]);
    NSLog(@"___________________修改值____________________");
    model1.name = @"4";
    NSLog(@"model1  :  %p--->%@  %p  ---> %@",model1,model1,model1.name,model1.name);
    NSLog(@"array  : %p  -> %@  [0] : %p--->%@",array,array,array[0],array[0]);
    NSLog(@"mutableCopyArray  : %p  -> %@  [0] : %p--->%@",copyArray,copyArray,copyArray[0],copyArray[0]);
    NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@" ,mutableCopyArray,mutableCopyArray,mutableCopyArray[0],mutableCopyArray[0]);



}

-(void)testArray{
    
    NSString * str1 = @"1";
    NSLog(@"str1  :  %p--->%@",str1,str1);
    NSString * str2 = @"2";

    NSArray * array = @[str1,str2];
    NSLog(@"array  : %p  -> %@  [0] : %p--->%@",array,array,array[0],array[0]);
    NSArray * copyArray = [array copy];
    NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@",copyArray,copyArray,copyArray[0],copyArray[0]);
    NSMutableArray * mutableCopyArray = [array mutableCopy];
    NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@" ,mutableCopyArray,mutableCopyArray,mutableCopyArray[0],mutableCopyArray[0]);
    
    NSLog(@"___________________修改值____________________");
//    str1 = @"4";
    mutableCopyArray[0] = @"3";
      NSLog(@"array  : %p  -> %@  [0] : %p--->%@",array,array,array[0],array[0]);
    NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@",copyArray,copyArray,copyArray[0],copyArray[0]);
    NSLog(@"copyArray  : %p  -> %@  [0] : %p--->%@" ,mutableCopyArray,mutableCopyArray,mutableCopyArray[0],mutableCopyArray[0]);
}

-(void)testMutableCopyToCopy{
    
    NSMutableString * testStr = [[NSMutableString alloc]initWithString:@"123"];
    
    NSLog(@"testStr  : %p  -> %@",testStr,testStr);
    
    NSString * testCopyStr = [testStr copy];
    
    NSLog(@"testCopyStr  : %p  -> %@",testCopyStr,testCopyStr);

       NSMutableString * testMutableCopyStr = [testStr mutableCopy];
    NSLog(@"testMutableCopyStr  : %p  -> %@",testMutableCopyStr,testMutableCopyStr);

    NSLog(@"___________________修改值____________________");
    [testStr appendFormat:@"4"];
    NSLog(@"testStr  : %p  -> %@",testStr,testStr);
    NSLog(@"testCopyStr  : %p  -> %@",testCopyStr,testCopyStr);
    NSLog(@"testMutableCopyStr  : %p  -> %@",testMutableCopyStr,testMutableCopyStr);



    
}

-(void)testCopyToMutableCopy{
    
    NSString * testStr = @"123";
    
    NSLog(@"testStr  : %p  -> %@",testStr,testStr);
    
    NSMutableString * testMutableCopyStr = [testStr mutableCopy];
    
    NSLog(@"testMutableCopyStr  : %p  -> %@",testMutableCopyStr,testMutableCopyStr);

    
    NSString * testCopyStr = [testStr copy];
    
    NSLog(@"testCopyStr  : %p  -> %@",testCopyStr,testCopyStr);
    
    
    
    
    NSLog(@"___________________修改值____________________");
    testStr = @"1234";
    NSLog(@"testStr  : %p  -> %@",testStr,testStr);
    NSLog(@"testMutableCopyStr  : %p  -> %@",testMutableCopyStr,testMutableCopyStr);
    NSLog(@"testCopyStr  : %p  -> %@",testCopyStr,testCopyStr);
    
    [testMutableCopyStr appendFormat:@"5"];
    NSLog(@"testMutableCopyStr  : %p  -> %@",testMutableCopyStr,testMutableCopyStr);



    
}



-(void)testCopy{
    
    NSMutableString *string = [NSMutableString stringWithString:@"copy test"];
    NSString *origin = [NSString stringWithString:string];
    NSString *copy = [origin copy];
    NSMutableString *mut = [origin mutableCopy];
    
    NSLog(@"原始地址 %p,    %@",origin,origin);
    NSLog(@"copy地址 %p,    %@",copy,copy);
    NSLog(@"mut copy 地址 %p,    %@",mut,mut);
    [string appendString:@"aaa"];
    [mut appendString:@"ffff"];
    
    NSLog(@"原始地址 %p,    %@",origin,origin);
    NSLog(@"copy地址 %p,    %@",copy,copy);
    NSLog(@"mut copy 地址 %p,    %@",mut,mut);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
