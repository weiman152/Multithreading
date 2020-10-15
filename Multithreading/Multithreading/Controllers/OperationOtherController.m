//
//  OperationOtherController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/15.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "OperationOtherController.h"

@interface OperationOtherController ()

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

- (IBAction)test2:(id)sender {
    
}

- (IBAction)test3:(id)sender {
    
}

- (IBAction)test4:(id)sender {
    
}

- (IBAction)test5:(id)sender {
    
}

@end
