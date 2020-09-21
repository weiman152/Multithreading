//
//  ThreadViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/7/5.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
}

- (IBAction)threadNameTest:(id)sender {
    
}

-(void)printHi {
    NSLog(@"---printHi---");
    NSLog(@"Hi, 我要在子线程中执行");
    NSLog(@"--Sel--%@",[NSThread currentThread]);

    NSLog(@"2222  %d", [NSThread isMultiThreaded]);
    NSLog(@"子线程2, isMainThread： %d", [NSThread isMainThread]);
    NSLog(@"子线程2： mainThread: %@", [NSThread mainThread]);
}

@end
