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
    
}

//初始化线程
-(void)newThread {
    NSThread * thread1 = [[NSThread alloc] initWithBlock:^{
        NSLog(@"使用Block初始化 thread1");
    }];
    
    
}
@end
