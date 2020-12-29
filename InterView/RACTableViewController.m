//
//  RACTableViewController.m
//  InterView
//
//  Created by heshenghui on 2019/10/17.
//  Copyright © 2019 Company. All rights reserved.
//

#import "RACTableViewController.h"
#import "RACTestViewController.h"
#import "TestCopyViewController.h"
#import "TestBlockViewController.h"
#import "InterView-Swift.h"
#import "TimersViewController.h"

@interface RACTableViewController ()

@end

@implementation RACTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor redColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
  
//    [imageV sd_setImageWithURL:[NSURL URLWithString:@"https://desk-fd.zol-img.com.cn/g5/M00/08/00/ChMkJlexsJmIIe8dAAghrgQhdMQAAUdNAJInfYACCHG699.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            NSLog(@"%@",imageURL.absoluteURL);
//        
////         NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:@"https://desk-fd.zol-img.com.cn/g5/M00/08/00/ChMkJlexsJmIIe8dAAghrgQhdMQAAUdNAJInfYACCHG699.jpg"]];
////        //    UIImage *  image = [self scaledImageForKey:key image:image];
//                
//            SDWebImageManager *manager = [SDWebImageManager sharedManager];
//            NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:@"https://desk-fd.zol-img.com.cn/g5/M00/08/00/ChMkJlexsJmIIe8dAAghrgQhdMQAAUdNAJInfYACCHG699.jpg"]];
//            SDImageCache* cache = [SDImageCache sharedImageCache];
//            //此方法会先从memory中取。
//            UIImage * image123 = [cache imageFromDiskCacheForKey:key];
//        NSLog(@"image : %@",image123);
//
//        }];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:@"https://desk-fd.zol-img.com.cn/g5/M00/08/00/ChMkJlexsJmIIe8dAAghrgQhdMQAAUdNAJInfYACCHG699.jpg"]];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        UIImage * image123 = [cache imageFromDiskCacheForKey:key];
    imageV.image = image123;
    NSLog(@"image : %@",image123);
    

    [self.view addSubview:imageV];
    
    
         
   
    
    //线程锁
//    [self nsconditionlock];
//    [self nsCondition];
}

- (void)nsCondition {
    NSCondition * cjcondition = [NSCondition new];
    /*
     在加上锁之后，调用条件对象的 wait 或 waitUntilDate: 方法来阻塞线程，直到条件对象发出唤醒信号或者超时之后，再进行之后的操作。
     */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [cjcondition lock];
        NSLog(@"线程1线程加锁----NSTreat：%@",[NSThread currentThread]);
        [cjcondition wait];
        NSLog(@"线程1线程唤醒");
        [cjcondition unlock];
        NSLog(@"线程1线程解锁");
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [cjcondition lock];
        NSLog(@"线程2线程加锁----NSTreat：%@",[NSThread currentThread]);
        if ([cjcondition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]]) {
            NSLog(@"线程2线程唤醒");
            [cjcondition unlock];
            NSLog(@"线程2线程解锁");
        }
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        /*
1、休眠时间如果超过了线程中条件锁等待的时间，那么所有的线程都不会被唤醒。不管是哪一个线程中设置的时间，都不能超时，否则就会返回NO，全部不执行！切记切记！
2、一次只能唤醒一个线程，要调用多次才可以唤醒多个线程，如下调用两次，将休眠的两个线程解锁。
3、唤醒的顺序为线程添加的顺序。
*/
        
        [cjcondition signal];
        [cjcondition signal];

        //一次性全部唤醒
        //[cjcondition broadcast];
    });
}
- (void)nsconditionlock {
    
    /*
    在线程 1 解锁成功之后，线程 2 并没有加锁成功，而是继续等了 1 秒之后线程 3 加锁成功，这是因为线程 2 的加锁条件不满足，初始化时候的 condition 参数为 0，而线程 2
    加锁条件是 condition 为 1，所以线程 2 加锁失败。
    lockWhenCondition 与 lock 方法类似，加锁失败会阻塞线程，所以线程 2 会被阻塞着。
    tryLockWhenCondition: 方法就算条件不满足，也会返回 NO，不会阻塞当前线程。
    lockWhenCondition:beforeDate:方法会在约定的时间内一直等待 condition 变为 2，并阻塞当前线程，直到超时后返回 NO。
    */
    
    NSConditionLock * cjlock = [[NSConditionLock alloc] initWithCondition:0];
    
    //1、线程 1 解锁成功
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cjlock lock];
        NSLog(@"线程1加锁成功");
        sleep(5);//线程休眠一秒
        [cjlock unlock];
        NSLog(@"线程1解锁成功");
    });
    
    //2、初始化时候的 condition 参数为0，所以此处加锁失败，返回NO，此处线程阻塞。全部现成执行完毕后执行此处锁
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);//线程休眠一秒
        [cjlock lockWhenCondition:1];
        NSLog(@"线程2加锁成功");
        [cjlock unlock];
        NSLog(@"线程2解锁成功");
    });
    
    //3、tryLockWhenCondition尝试加锁  初始化时候的 condition 参数为0，所以此处加锁成功。方法就算条件不满足，也会返回 NO，不会阻塞当前线程。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        
        if ([cjlock tryLockWhenCondition:0]) {
            NSLog(@"线程3加锁成功");
            sleep(2);
            /*
             A：成功案例
             这里会先解锁当前的锁，之后修改condition的值为100.在下一个condition为100的线程中会加解锁成功，如果下个锁中的condition等待的值不是100，那么就会导致加锁失败。
             */
            [cjlock unlockWithCondition:100];
            NSLog(@"线程3解锁成功");
            
            /*
             B：失败案例
             [cjlock unlockWithCondition:4];
             NSLog(@"线程3仍然会解锁成功，之后修改condition的值为4");
             */
            
        } else {
            NSLog(@"线程3尝试加锁失败");
        }
    });
    
    //4、lockWhenCondition:beforeDate:方法会在约定的时间内一直等待 condition 变为 2，并阻塞当前线程，直到超时后返回 NO。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([cjlock lockWhenCondition:100 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]) {
            NSLog(@"线程100加锁成功");
            [cjlock unlockWithCondition:1];
            NSLog(@"线程100解锁成功");
        } else {
            NSLog(@"线程100尝试加锁失败");
        }
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (indexPath.row ==0) {
         cell.textLabel.text = @"RAC";
    }else if(indexPath.row ==1){
        cell.textLabel.text = @"Copy";
    }else if(indexPath.row ==2){
        cell.textLabel.text = @"block";
    }else if(indexPath.row ==3){
        cell.textLabel.text = @"RunLoop";
    }else if(indexPath.row ==4){
        cell.textLabel.text = @"timer";
    }else if(indexPath.row ==5){
        cell.textLabel.text = @"GCD";
    }
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0) {
            RACTestViewController * vc = [[RACTestViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
       }else if(indexPath.row ==1){
          TestCopyViewController * vc = [[TestCopyViewController alloc]init];
           [self.navigationController pushViewController:vc animated:YES];
       }else if(indexPath.row ==2){
          TestBlockViewController * vc =[[TestBlockViewController alloc]init];
           [self presentViewController:vc animated:true completion:^{
               
               sleep(5);
               self.str = vc.str;
           }];
           
//          vc.Block = ^(NSString * _Nonnull str) {
//              self.str = str;
//          };
//          [self.navigationController pushViewController:vc animated:YES];
       }else if(indexPath.row ==3){
          RunLoopViewController * vc =[[RunLoopViewController alloc]init];
          [self.navigationController pushViewController:vc animated:YES];
       }else if(indexPath.row ==4){
           TimersViewController * vc =[[TimersViewController alloc]init];
           [self.navigationController pushViewController:vc animated:YES];
       }else if(indexPath.row ==5){
           GCDViewController * vc =[[GCDViewController alloc]init];
           [self.navigationController pushViewController:vc animated:YES];
       }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
