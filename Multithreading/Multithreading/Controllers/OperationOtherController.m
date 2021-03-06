//
//  OperationOtherController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/15.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "OperationOtherController.h"
#import "OperationCaseController.h"

@interface OperationOtherController ()

@property(nonatomic, strong)NSOperationQueue * myQueue;

@end

@implementation OperationOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//任务依赖
- (IBAction)test1:(id)sender {
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSBlockOperation * op1 = [[NSBlockOperation alloc] init];
    [op1 addExecutionBlock:^{
        NSLog(@"任务一, %@",[NSThread currentThread]);
    }];
    [op1 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二,%@",[NSThread currentThread]);
    }];
    NSBlockOperation * op2 = [[NSBlockOperation alloc] init];
    [op2 addExecutionBlock:^{
        NSLog(@"op2哦，%@",[NSThread currentThread]);
    }];
    //设置op2依赖于任务op1
    [op2 addDependency:op1];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

//NSOperation执行完成
- (IBAction)test2:(id)sender {
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSBlockOperation * op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一，%@",[NSThread currentThread]);
    }];
    [op1 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二，%@",[NSThread currentThread]);
    }];
    [op1 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务三，%@",[NSThread currentThread]);
    }];
    [op1 addExecutionBlock:^{
        NSLog(@"任务四，%@",[NSThread currentThread]);
    }];
    op1.completionBlock = ^{
        NSLog(@"任务都执行完成啦");
    };
    [queue addOperation:op1];
}
//maxConcurrentOperationCount 最大并发数
- (IBAction)test3:(id)sender {
    //1. 串行
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    NSBlockOperation * op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一，%@",[NSThread currentThread]);
    }];
    NSBlockOperation * op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二，%@",[NSThread currentThread]);
    }];
    NSBlockOperation * op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务三，%@",[NSThread currentThread]);
    }];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    //2. 一个操作的多个任务，设置最大并发数为1是没有效果的
//    NSOperationQueue * queue2 = [[NSOperationQueue alloc] init];
//    queue2.maxConcurrentOperationCount = 1;
//    NSBlockOperation * op4 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"1，%@",[NSThread currentThread]);
//    }];
//    [op4 addExecutionBlock:^{
//        [NSThread sleepForTimeInterval:2.0];
//        NSLog(@"2，%@",[NSThread currentThread]);
//    }];
//    [op4 addExecutionBlock:^{
//        NSLog(@"3，%@",[NSThread currentThread]);
//    }];
//    [queue2 addOperation:op4];
}

//队列暂停，suspended
- (IBAction)test4:(id)sender {
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSBlockOperation * op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一，%@",[NSThread currentThread]);
    }];
    [op1 addExecutionBlock:^{
        NSLog(@"任务二开始，%@",[NSThread currentThread]);
        for (int i=0; i<10; i++) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"2: i=%d",i);
        }
        NSLog(@"任务二结束");
    }];
    [queue addOperation:op1];
    NSBlockOperation * op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"哈哈哈，%@",[NSThread currentThread]);
    }];
    queue.suspended = YES;
    [queue addOperation:op2];
}

//取消所有任务
- (IBAction)test5:(id)sender {
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSBlockOperation * op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"操作一：1，%@",[NSThread currentThread]);
    }];
    [op1 addExecutionBlock:^{
        NSLog(@"操作一：2，%@",[NSThread currentThread]);
    }];
    NSBlockOperation * op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"操作二：1，%@",[NSThread currentThread]);
    }];
    NSBlockOperation * op3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"操作三：1，%@",[NSThread currentThread]);
        for (int i=0; i<10; i++) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"2: i=%d",i);
        }
    }];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    self.myQueue = queue;
}

- (IBAction)cancelTest5:(id)sender {
    [self.myQueue cancelAllOperations];
}

- (IBAction)test6:(id)sender {
    NSLog(@"打印所有操作");
    
    NSLog(@"%@",self.myQueue.operations);
}

//案例，下载两张图片并合成一张图
- (IBAction)downLoadImg:(id)sender {
    OperationCaseController * vc = [OperationCaseController instance];
    [self pushVC:vc];
}

@end
