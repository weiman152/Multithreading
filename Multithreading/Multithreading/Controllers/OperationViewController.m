//
//  OperationViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/7/5.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "OperationViewController.h"
#import "WMOperation.h"
#import "WMCXOperation.h"
#import "WMBXOperation.h"

@interface OperationViewController ()

@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//----------1. 创建操作--------------
- (IBAction)test1:(id)sender {
    //1.NSInvocationOperation
    NSInvocationOperation * invocationOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(runWithName:) object:@"NSInvocationOperation"];
    //启动
    [invocationOp start];
}

- (IBAction)test2:(id)sender {
    //2.NSBlockOperation(最常使用)
    NSBlockOperation * blockOp = [NSBlockOperation blockOperationWithBlock:^{
        //要执行的操作，目前是主线程
        NSLog(@"NSBlockOperation 创建，线程：%@",[NSThread currentThread]);
    }];
    //2.1 追加任务，在子线程中执行
    [blockOp addExecutionBlock:^{
        NSLog(@"追加任务一");
        [self runWithName:@"NSBlockOperation 追加"];
    }];
    [blockOp addExecutionBlock:^{
        NSLog(@"追加任务二, %@",[NSThread currentThread]);
    }];
    [blockOp start];
}

- (IBAction)test3:(id)sender {
    WMOperation * wmOp = [[WMOperation alloc] init];
    [wmOp start];
    
    //自定义串行
    WMCXOperation * cxOp = [[WMCXOperation alloc] init];
    NSLog(@"任务开始");
    [cxOp start];
    NSLog(@"任务结束");
    
    //自定义并行
    WMBXOperation * bxOp = [[WMBXOperation alloc] init];
    NSLog(@"并行任务开始");
    [bxOp wmStart:bxOp];
    NSLog(@"并行任务结束");
}

//----------2. 创建队列--------------
//主队列
- (IBAction)mainQ:(id)sender {
    NSOperationQueue * q1 = [NSOperationQueue mainQueue];
}

//非主队列
- (IBAction)otherQ:(id)sender {
    NSOperationQueue * q2 = [[NSOperationQueue alloc] init];
}

//----------3. 任务+队列--------------
//block+主队列
- (IBAction)blockAndMain:(id)sender {
    //1.创建主队列
    NSOperationQueue * q1 = [NSOperationQueue mainQueue];
    //2.创建任务
    NSBlockOperation * p1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一，当前线程：%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务一结束");
    }];
    [p1 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务二，线程：%@",[NSThread currentThread]);
    }];
    [p1 addExecutionBlock:^{
        NSLog(@"任务三，线程：%@",[NSThread currentThread]);
    }];
    //3.把任务添加到队列
    [q1 addOperation:p1];
    
    //也可以直接添加操作到队列中
    [q1 addOperationWithBlock:^{
        NSLog(@"直接添加操作，%@",[NSThread currentThread]);
    }];
}

//block+非主队列
- (IBAction)blockAndOther:(id)sender {
    //创建非主队列
    NSOperationQueue * q1 = [[NSOperationQueue alloc] init];
    NSBlockOperation * b1 = [[NSBlockOperation alloc] init];
    [b1 addExecutionBlock:^{
        NSLog(@"任务一，线程：%@",[NSThread currentThread]);
    }];
    [b1 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二，线程：%@",[NSThread currentThread]);
    }];
    [b1 addExecutionBlock:^{
        NSLog(@"任务三，线程：%@",[NSThread currentThread]);
    }];
    //把任务添加到队列
    [q1 addOperation:b1];
    
    //只使用NSBlockOperation
    NSLog(@"-------只使用NSBlockOperation实现------------");
    NSBlockOperation * b2 = [[NSBlockOperation alloc] init];
    [b2 addExecutionBlock:^{
        NSLog(@"1，线程：%@",[NSThread currentThread]);
    }];
    [b2 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"2，线程：%@",[NSThread currentThread]);
    }];
    [b2 addExecutionBlock:^{
        NSLog(@"3，线程：%@",[NSThread currentThread]);
    }];
    [b2 start];
}

- (IBAction)InvoAndMain:(id)sender {
    NSOperationQueue * mainQ = [NSOperationQueue mainQueue];
    NSInvocationOperation * p1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    NSInvocationOperation * p2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    NSInvocationOperation * p3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3) object:nil];
    [mainQ addOperation:p1];
    [mainQ addOperation:p2];
    [mainQ addOperation:p3];
}

- (IBAction)invoAndOther:(id)sender {
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation * p1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    NSInvocationOperation * p2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    NSInvocationOperation * p3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3) object:nil];
    [queue addOperation:p1];
    [queue addOperation:p2];
    [queue addOperation:p3];
}

-(void)task1 {
    NSLog(@"任务一， %@",[NSThread currentThread]);
}

-(void)task2 {
    [NSThread sleepForTimeInterval:2.0];
    NSLog(@"任务二， %@",[NSThread currentThread]);
}

-(void)task3 {
    NSLog(@"任务三， %@",[NSThread currentThread]);
}


-(void)runWithName:(NSString *)name{
    NSLog(@"-------%@-------",name);
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"哈哈哈哈，我是个任务，要执行2秒哦");
    [NSThread sleepForTimeInterval:2.0];
    NSLog(@"任务结束啦");
}

@end
