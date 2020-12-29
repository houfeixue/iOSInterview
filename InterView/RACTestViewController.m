//
//  RACTestViewController.m
//  InterView
//
//  Created by heshenghui on 2019/10/17.
//  Copyright © 2019 Company. All rights reserved.
//

#import "RACTestViewController.h"
#import "TestBlockViewController.h"

@interface RACTestViewController ()
{
    UIImageView *imageV;
    UIImageView *image1;
    NSString * _str;
}
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) UILabel *someLablel;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *picsignal;
@property (nonatomic, assign) int time;
@property (nonatomic, strong) RACDisposable *disposable;
@property (nonatomic, strong) NSString *str ;

@end

@implementation RACTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
//    //热冷信号
//    [self signalOrSubject];
//    //热信号
//    [self subject];
    //singnal被订阅
//    [self testSubjectMul];
    
    //冷信号 转热信号
//    [self testAutoConnect];
    //testReplay
//    [self testReplay];
    //信号合并
//    [self testRacFunc];
    //textField
//    [self testField];
    
//    [self loadPic];
//    [self GCDLoadPic];
//    [self GCDser];
//    [self MulticastConnection];
//      [self racflattenMap];
//    [self then];
//    [self throttle];
//    [self testCommand];

//    [self Gcd];
//    [self syncSerial];
//    [self syncConcurrent];
    [self groupEnterAndLeave];
//    [self retry];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)retry{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        static int a = 1;

        [subscriber sendNext:@(a)];
        
        NSError * error = [[NSError alloc]init];
        [subscriber sendError:error];
        a ++;
        [subscriber sendNext:@(a)];
    


        return nil;

    }];
    
    
    [[signal retry:1] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@" ____________ %@",x);
        
    }];
    
    
    
    
}

//热冷信号
-(void)signalOrSubject{
    _someLablel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_someLablel];
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api"]];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    @weakify(self)
    RACSignal * fetchData = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        NSURLSessionDataTask * task = [self.sessionManager GET:@"getdata" parameters:@{@"someParameter": @"someValue"} progress:^(NSProgress * _Nonnull downloadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }];
        
    }];
    
    RACSignal * title = [fetchData flattenMap:^__kindof RACSignal * (NSDictionary * value) {
        if ([value[@"t"] isKindOfClass:[NSString class]]) {
            return [RACSignal return:value[@"t"]];
        }else{
            return [RACSignal error:[NSError errorWithDomain:@"error" code:400 userInfo:@{@"e":@"2"}]];
        }
    }];
    
    RACSignal * desc = [fetchData flattenMap:^__kindof RACSignal * (NSDictionary  * value) {
        if([value[@"d"] isKindOfClass:[NSString class]]){
            return [RACSignal return:value[@"d"]];
        }else{
            return [RACSignal error:[NSError errorWithDomain:@"error" code:400 userInfo:@{@"e":@"2"}]];
        }
    }];
    
     RAC(self.someLablel,text) = [[desc catchTo: [RACSignal return: @"error"]] startWith:@"loading"];

}
//热信号
-(void)subject{
    
    RACSubject * subject = [RACSubject subject];
    RACSubject * replaySubject = [RACReplaySubject subject];
    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
        
        NSLog(@"time : 0.1");

        [subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"Subscriber 1 get a next value: %@ from subject", x);

        }];
        
        [replaySubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"Subscriber 1 get a next value: %@ from replay subject", x);
            
        }];
        
        [subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"Subscriber 2 get a next value: %@ from subject", x);

        }];
        
        [replaySubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"Subscriber 2 get a next value: %@ from replay subject", x);

        }];
        
        NSLog(@"time--- : 0.1");

    }];
    [[RACScheduler mainThreadScheduler]afterDelay:1 schedule:^{
        NSLog(@"time: 1");

        [subject sendNext:@"send package 1"];
        [replaySubject sendNext:@"send package 1"];
        
        NSLog(@"time--- : 1");
    }];
    
    
    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
        // Subscriber 3
        
        NSLog(@"time: 1.1");

        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 3 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 3 get a next value: %@ from replay subject", x);
        }];
        
        // Subscriber 4
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 4 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 4 get a next value: %@ from replay subject", x);
        }];
        
        NSLog(@"time ----: 1.1");

    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        
        NSLog(@"time: 2");

        [subject sendNext:@"send package 2"];
        [replaySubject sendNext:@"send package 2"];
        
        NSLog(@"time ----: 2");

    }];
    
}

-(void)testSubjectMul{
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"源信号被订阅了");
        [subscriber sendNext:@"假设这是网络"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSubject * subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);

        NSLog(@"订阅者1订阅了");
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);

        NSLog(@"订阅者2订阅了");
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);

        NSLog(@"订阅者3订阅了");
    }];
    [signal subscribe:subject];
    
}
-(void)testAutoConnect{
    
    RACSignal * signal = [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"源信号被订阅了");
        [subscriber sendNext:@"假设这是网络"];
        [subscriber sendCompleted];
        return nil;
    }]publish]autoconnect];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1订阅了");
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2订阅了");
    }];
    
}
-(void)testReplay{
    
    RACSignal * signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"1");
        NSLog(@"源信号被订阅了");
        [subscriber sendNext:@"假设这是网络"];
        [subscriber sendNext:@"假设这是另一个网络"];
        [subscriber sendCompleted];
        return nil;
    }]replayLazily];
    
     NSLog(@"2");
    [signal subscribeNext:^(id x) {
         NSLog(@"3");
        NSLog(@"订阅者1订阅了--%@",x);
    }];
    
}

-(void)testRacFunc{
    
    //concat
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"concat :  1");
        [subscriber sendNext:@"A"];
        NSLog(@"concat :  2");

        [subscriber sendCompleted];
        NSLog(@"concat :  3");

        return nil;
    }];
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"concat :  4");

        [subscriber sendNext:@"B"];
        NSLog(@"concat :  5");
        [subscriber sendNext:@"C"];

        [subscriber sendCompleted];
        NSLog(@"concat :  6");

        return nil;
    }];
    
    [[signalA concat:signalB]subscribeNext:^(id  _Nullable x) {
        NSLog(@"concat :  %@",x);
    }];
    
    NSLog(@"-------------------------------");
    
    
    [[signalA zipWith:signalB] subscribeNext:^(RACTuple * x) {
        RACTupleUnpack(NSString * stringA,NSString * stringB) = x;
        NSLog(@"zipWith : %@",x);
        
    }];
    
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        return nil;
    }]take:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"only 1 and 2 will be print: %@", x);

    }];

}

-(void)testField{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 600, 100, 50)];
    
    UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(50, 650, 100, 50)];
    
      UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 50)];
    
    textField.placeholder = @"输入框";
    
    textField2.placeholder = @"输入框2";
    /*flattenMap*/
    [[textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        // 监测输入框变化
        
        // 返回信号
        
        // 开发中，如果信号发出的值是信号，映射一般使用FlatternMap
        return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"----%@",x);
        
    }];
    
    
    [[textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        // 开发中，如果信号发出的值不是信号，映射一般使用Map
        return [NSString stringWithFormat:@"信号内容: %@",value];
        
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"+++++%@",x);
        
    }];
    [[textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length  > 5;
    }]subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"~~~~~~%@", x);
        
    }];
    [self.view addSubview:textField];
    [self.view addSubview:textField2];
    [self.view addSubview:btn];
    
    
    RAC(btn,enabled) = [RACSignal combineLatest:@[textField.rac_textSignal,textField2.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * passw){
        return @(username.length && passw.length);
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@ 键盘弹起", x); // x 是通知对象
    }];
    

}

-(void)loadPic{
   imageV = [[UIImageView alloc]init];
    _picsignal=[NSMutableArray new];
    _picArray = [[NSMutableArray alloc]initWithCapacity:3];
    for (int i=0; i<3; i++) {
        UIImageView * imageVimage = [[UIImageView alloc]init];
        [_picArray addObject:imageVimage];
        
        
        if (i==0) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [imageVimage sd_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/Docs/Diagrams/SDWebImageHighLevelDiagram.jpeg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [subscriber sendNext:image];
                }];
                return nil;
            }];
            [_picsignal addObject:signal];

        }else if(i == 1){
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:@"image"];

                return nil;
            }];

            [_picsignal addObject:signal];
        }else{
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [imageVimage sd_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/Docs/Diagrams/SDWebImageHighLevelDiagram1.jpeg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [imageVimage sd_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/Docs/Diagrams/SDWebImageHighLevelDiagram.jpeg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [subscriber sendNext:image];
                    }];
                }];
                return nil;
            }];
            [_picsignal addObject:signal];
            
        }
    }

    
    [[RACSignal combineLatest:_picsignal]subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@",x);
    }];

}
- (void)GCDLoadPic{
    
    _picArray = [[NSMutableArray alloc]initWithCapacity:3];
    _picsignal = [[NSMutableArray alloc]init];
    imageV =[[UIImageView alloc]init];

    dispatch_queue_t queque = dispatch_queue_create("miximixi", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    dispatch_async(queque, ^{
        
        for(int i=0;i<3;i++){

            if (i==0) {
                [self->imageV sd_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/Docs/Diagrams/SDWebImageHighLevelDiagram.jpeg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    sleep(10);
                    NSLog(@"1_____");
                    [self->_picsignal addObject:@"1"];
                    dispatch_semaphore_signal(semaphore);
                    
                }];
            }else if(i==1){
                [self->_picsignal addObject:@"image"];
                NSLog(@"2_____");

                dispatch_semaphore_signal(semaphore);


            }else{
                [self->imageV sd_setImageWithURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/SDWebImage/SDWebImage/master/Docs/Diagrams/SDWebImageHighLevelDiagram.jpeg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    NSLog(@"3_____");

                    [self->_picsignal addObject:@"2"];
                    dispatch_semaphore_signal(semaphore);
                    
                }];
                
            }
           
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        }
        NSLog(@"_picsignal : %@",self->_picsignal);
    });
    
}


-(void)updateTitle:(id)titles,...{
    
    va_list params;//定义一个指向个数可变的参数列表指针
    va_start(params, titles);//va_start 得到第一个可变参数地址
    NSString *arg;
    if (titles) {
        //将第一个参数添加到array
        //va_arg 指向下一个参数地址
        while ((arg = va_arg(params, NSString *))) {
            if (arg) {
                NSLog(@"%@",arg);
            }
        }
        //置空
        va_end(params);
    }
    
}
- (void)updateUIWithOneData:(id)oneData TwoData:(id)twoData  ThreeData:(id)threeData{
    NSLog(@"%@",[NSThread currentThread]);
    //拿到数据更新UI
    NSLog(@"UI!!%@%@%@",oneData,twoData,threeData);
}


-(void)GCDser{
    
    dispatch_queue_t mySerialQueue = dispatch_queue_create("com.gcd.queueCreate.mySerialQueue", NULL);
    
    dispatch_sync(mySerialQueue, ^{
//        sleep(1);
        NSLog(@"4");
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"1");
    dispatch_sync(mySerialQueue, ^{
//        sleep(1);
        NSLog(@"5");
        NSLog(@"%@",[NSThread currentThread]);

    });
    NSLog(@"2");
    dispatch_sync(mySerialQueue, ^{
//        sleep(1);
        NSLog(@"6");
        NSLog(@"%@",[NSThread currentThread]);

    });
    NSLog(@"3");

    NSLog(@"----------------");
 
    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("com.gcd.queueCreate.myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(myConcurrentQueue, ^{
//        sleep(1);
        NSLog(@"4");
    });
     NSLog(@"1");
    dispatch_async(myConcurrentQueue, ^{
//        sleep(1);
        NSLog(@"5");
    });
    NSLog(@"2");
    dispatch_async(myConcurrentQueue, ^{
//        sleep(1);
        NSLog(@"6");
    });
    NSLog(@"3");
}

-(void)baseKvo{
    
    UIView * redView = [[UIView alloc]init];
    [self.view addSubview:redView];

//    [redView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
//         NSLog(@"方法一 %@",value);
//    }];
   
    [[redView rac_valuesForKeyPath:@"frame" observer:nil]subscribeNext:^(id  _Nullable x) {
        NSLog(@"方法二 %@",x);
    }];
    
    [RACObserve(redView, frame) subscribeNext:^(id  _Nullable x) {
        NSLog(@"方法三%@",x);
    }];
    
    UITextField * textFild = [[UITextField alloc]init];
    [[textFild rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"tap");
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postData" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    self.time = 10;
    @weakify(self)
    self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        @strongify(self)
        self.time--;
        self.someLablel.text = @"123";
        if (self.time == 0) {
            [self.disposable dispose];
        }
    }];
    
    
    
}

-(void)MulticastConnection{
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"123"];
        return nil;
    }];
    
    RACMulticastConnection * mu = [signal publish];
    [mu.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [mu.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [mu connect];
    
    
    RACSubject * subsignal = [RACSubject subject];
    [[subsignal bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(id value,BOOL * stop){
            NSLog(@"%@",value);
            NSString * v = [NSString stringWithFormat:@"处理过的数据%@",value];
            return [RACReturnSignal return:v];
        };
        
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subsignal sendNext:@"123"];
    
}

-(void)racflattenMap{
    RACSubject * signalA = [RACSubject subject];
    [[signalA flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSString * v = [NSString stringWithFormat:@"处理过的数据%@",value];
        return [RACReturnSignal return:v];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [signalA sendNext:@"123"];
    
    
    RACSubject * subject = [RACSubject subject];
    [[subject ignore:@"a"]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"a"];
    [subject sendNext:@"b"];
    [subject sendNext:@"x"];
    RACSubject * subject1 = [RACSubject subject];

    [[subject1 distinctUntilChanged]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject1 sendNext:@"1"];
    [subject1 sendNext:@"1"];
    [subject1 sendNext:@"1"];
    [subject1 sendNext:@"2"];
    [subject1 sendNext:@"2"];
    [subject1 sendNext:@"1"];
    [subject1 sendNext:@"1"];
    [subject1 sendNext:@"1"];

}

-(void)unpack
{
    NSArray * numbers = @[@"1",@"2",@"3"];
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"遍历后的数组%@",x);
    }];
    
    NSDictionary * dict = @{@"name":@"x",@"age":@"1"};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString * key,NSString * value) = x;
        NSLog(@"%@---%@",key,value);
    }];
    
    
    
}


-(void)then{
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"fasongA");
        //发送 数据
        [subscriber sendNext:@"shujuA"];
        //A结束了
        [subscriber sendCompleted];
        return  nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"fasongB");
        //发送 数据
        [subscriber sendNext:@"shujuB"];
        [subscriber sendCompleted];
        return  nil;
    }];
    
    //then A发送完毕 忽略前面A这个信号  只接收B的数据（A发送完毕 B在回来）
    RACSignal *thenSignal = [signalA then:^RACSignal * _Nonnull{
        return signalB;
    }];
    
    //订阅信号
    [thenSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"thenSignal:%@",x);
    }];
}

-(void)throttle
{
    UITextField * tf_search = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    tf_search.placeholder = @"123";
    [self.view addSubview:tf_search];
    [[[[[[tf_search.rac_textSignal throttle:0.3]distinctUntilChanged]ignore:@""]map:^id _Nullable(NSString * _Nullable value) {
        //这里使用的是信号中的信号这个概念
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           
            
            [subscriber sendNext:value];
            
            
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                //cancel dispose
                NSLog(@"cancel.");
            }];
        }];
    }]switchToLatest]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

-(void)sendBlock{
    
    
    
}


-(void)testCommand{
    
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行%@",x);
        }
    }];
    
  
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"************%@",x);
    }];
    [command execute:@1];
}


-(void)Gcd {
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    

    dispatch_async(queue, ^{
        
//       dispatch_queue_t queue12 = dispatch_queue_create("test.queue12", DISPATCH_QUEUE_SERIAL);

        // 异步执行 + 串行队列
        dispatch_sync(queue, ^{  // 同步执行 + 当前串行队列
            // 追加任务 1
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    
}

- (void)syncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncConcurrent---end");
}
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncSerial---end");
}


- (void)groupEnterAndLeave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程

        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    
        NSLog(@"group---end");
    });
}
@end
