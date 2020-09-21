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
        for (int i=0; i<100; i++) {
            NSLog(@"i= %d", i);
            [NSThread sleepForTimeInterval:1];
        }
    }];
    self.thread1.name = @"线程一";
    //对象方法创建多线程 二
    NSThread * thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(hello:) object:@"小明"];
    thread2.name = @"线程二";
    [thread2 start];
}

- (IBAction)threadNameTest:(id)sender {
    
}

- (IBAction)threadStart:(id)sender {
    NSLog(@"thread1开始");
    [self.thread1 start];
}

- (IBAction)threadCancel:(id)sender {
    NSLog(@"thread1 取消");
    [self.thread1 cancel];
    NSLog(@"状态,isCancelled： %d",[self.thread1 isCancelled]);
    NSLog(@"状态,isFinished： %d",[self.thread1 isFinished]);
    NSLog(@"状态,isExecuting： %d",[self.thread1 isExecuting]);
//    if (self.thread1.isCancelled) {
//        [NSThread exit];
//    }
}

- (IBAction)wmThreadCreate:(id)sender {
    self.wmThread = [[WMThread alloc] initWithBlock:^{
        NSLog(@"wmThread： %@",[NSThread currentThread]);
        for (int i=0; i<100; i++) {
            NSLog(@"wm, i= %d", i);
            [NSThread sleepForTimeInterval:1];
        }
    }];
    self.wmThread.name = @"wmThread";
}
- (IBAction)wmThreadStart:(id)sender {
    [self.wmThread start];
}

- (IBAction)wmThreadCancel:(id)sender {
    [self.wmThread cancel];
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


@end
