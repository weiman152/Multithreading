//
//  ThreadViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/7/5.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "ThreadViewController.h"
#import "WMThread.h"

@interface ThreadViewController ()

@property(nonatomic, strong)NSThread * thread1;
@property(nonatomic, strong)WMThread * wmThread;
//总票数
@property(nonatomic, assign)int totalTickets;

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
}

-(void)test1{
    NSLog(@"000  %d", [NSThread isMultiThreaded]);
    NSLog(@"isMainThread: %d", [NSThread isMainThread]);
    NSLog(@"currentThread: %@", [NSThread currentThread]);
    NSLog(@"mainThread: %@", [NSThread mainThread]);
}

//类方法创建线程
- (IBAction)createThreadC:(id)sender {
    NSLog(@"------------detachNewThreadWithBlock-------");
    //block创建,并在子线程进行想要的操作
   [NSThread detachNewThreadWithBlock:^{
       NSLog(@"--block--%@",[NSThread currentThread]);
       NSLog(@"子线程1, isMainThread： %d", [NSThread isMainThread]);
       NSLog(@"子线程1： mainThread: %@", [NSThread mainThread]);
    }];
    NSLog(@"------------detachNewThreadSelector-------");
    //在子线程中执行某方法
    [NSThread detachNewThreadSelector:@selector(printHi) toTarget:self withObject:nil];
    
    NSLog(@"1111  %d", [NSThread isMultiThreaded]);
}

- (IBAction)createThreadO:(id)sender {
    NSLog(@"新建多线程");
    //对象方法创建多线程 一
    self.thread1 = [[NSThread alloc] initWithBlock:^{
        NSLog(@"thread1： %@",[NSThread currentThread]);
        for (int i=0; i<10000; i++) {
            NSLog(@"%@，i= %d", [NSThread currentThread].name,i);
        }
    }];
    self.thread1.name = @"线程一";
    
    //对象方法创建多线程 二
    NSThread * thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(hello:) object:@"小明"];
    thread2.name = @"线程二";
    [thread2 start];
}

- (IBAction)threadStart:(id)sender {
    NSLog(@"thread1开始");
    [self.thread1 start];
}

//NSThread的线程调用cancel并不会停止，只是把isCancelled属性设置为YES
- (IBAction)threadCancel:(id)sender {
    NSLog(@"thread1 取消");
    [self printState:self.thread1];
    [self.thread1 cancel];
    NSLog(@"cancel 后：");
    [self printState:self.thread1];
    if([self.thread1 isCancelled]==YES){
        NSLog(@"thread1 被取消了，开始销毁它");
        NSLog(@"当前线程：%@", [NSThread currentThread]);
        self.thread1 = nil;
    }
}

- (IBAction)wmThreadCreate:(id)sender {
    NSLog(@"WMThread创建线程");
    self.wmThread = [[WMThread alloc] initWithBlock:^{
        NSLog(@"wmThread： %@",[NSThread currentThread]);
        for (int i=0; i<10000; i++) {
            NSLog(@"wm, i= %d", i);
        }
    }];
    self.wmThread.name = @"wmThread";
}

- (IBAction)wmThreadStart:(id)sender {
    NSLog(@"wmThread 开始");
    [self.wmThread start];
}

- (IBAction)wmThreadCancel:(id)sender {
    NSLog(@"wmThread 取消");
    [self.wmThread cancel];
}

- (IBAction)sleepAction:(id)sender {
    NSThread * threadA = [[NSThread alloc] initWithBlock:^{
        //threadA 阻塞2秒后执行
        [NSThread sleepForTimeInterval:2.0];
        for (int i=0; i<10; i++) {
            NSLog(@"%@, i = %d", [NSThread currentThread].name, i);
        }
        NSLog(@"threadA 结束了");
    }];
    threadA.name = @"线程A";
    [threadA start];
    
    NSThread * threadB = [[NSThread alloc] initWithBlock:^{
        for (int i=0; i<10; i++) {
            NSLog(@"%@, i = %d", [NSThread currentThread].name, i);
        }
        NSLog(@"threadB 结束了");
    }];
    threadB.name = @"线程B";
    [threadB start];
    
    //让这个线程等到某个日期的时候在执行
    [NSThread detachNewThreadWithBlock:^{
        NSDate * date = [NSDate dateWithTimeIntervalSinceNow:2];
        [NSThread sleepUntilDate:date];
        NSLog(@"终于等到这一天啦！我执行啦！");
    }];
    
}

//再次测试取消线程
- (IBAction)cancelThreadAgain:(id)sender {
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}

//售票
- (IBAction)sellTickets:(id)sender {
    self.totalTickets = 100;
    
    NSThread * t1 = [[NSThread alloc] initWithTarget:self selector:@selector(sell) object:nil];
    t1.name = @"售票员：王美美";
    [t1 start];
    
    NSThread * t2 = [[NSThread alloc] initWithTarget:self selector:@selector(sell) object:nil];
    t2.name = @"售票员：李帅帅";
    [t2 start];
    
    NSThread * t3 = [[NSThread alloc] initWithTarget:self selector:@selector(sell) object:nil];
    t3.name = @"售票员：张靓靓";
    [t3 start];
}

-(void)printState:(NSThread *)thread{
    NSLog(@"状态,isCancelled： %d",[thread isCancelled]);
    NSLog(@"状态,isFinished： %d",[thread isFinished]);
    NSLog(@"状态,isExecuting： %d",[thread isExecuting]);
}

-(void)printHi {
    NSLog(@"---printHi---");
    NSLog(@"Hi, 我要在子线程中执行");
    NSLog(@"--Sel--%@",[NSThread currentThread]);

    NSLog(@"2222  %d", [NSThread isMultiThreaded]);
    NSLog(@"子线程2, isMainThread： %d", [NSThread isMainThread]);
    NSLog(@"子线程2： mainThread: %@", [NSThread mainThread]);
}

-(void)hello:(NSString *)name {
    NSLog(@"你好！%@",name);
    NSLog(@"当前线程是： %@",[NSThread currentThread]);
}

- (void)run {
    NSLog(@"当前线程%@", [NSThread currentThread]);
    //sleep不会影响线程的取消
    [NSThread sleepForTimeInterval:1.0];
    
    for (int i = 0 ; i < 100; i++) {
        NSLog(@"i = %d", i);
        if (i == 20) {
            //取消线程
            [[NSThread currentThread] cancel];
            NSLog(@"取消线程%@", [NSThread currentThread]);
        }

        if ([[NSThread currentThread] isCancelled]) {
            NSLog(@"结束线程%@", [NSThread currentThread]);
            //结束线程
            [NSThread exit];
            NSLog(@"这行代码不会打印的");
        }

    }
}

- (void)sell{
    NSLog(@"开始售票，当前余票：%d", self.totalTickets);
    while (self.totalTickets > 0) {
        [NSThread sleepForTimeInterval:1.0];
        self.totalTickets--;
        NSLog(@"%@ 卖出一张，余票：%d", [NSThread currentThread].name, self.totalTickets);
    }
}
@end
