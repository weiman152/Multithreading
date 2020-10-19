//
//  OtherViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/17.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)run {
    NSLog(@"开始任务，%@",[NSThread currentThread]);
}

//后台开启多线程
- (IBAction)test1:(id)sender {
    [self performSelectorInBackground:@selector(run) withObject:nil];
}

- (IBAction)test2:(id)sender {
    NSThread * t1 = [[NSThread alloc] initWithBlock:^{
        NSLog(@"哈哈哈，%@",[NSThread currentThread]);
        [[NSRunLoop currentRunLoop] run];
    }];
    t1.name = @"线程一";
    [t1 start];
    [self performSelector:@selector(run) onThread:t1 withObject:nil waitUntilDone:NO];
    
    NSThread * t2 = [[NSThread alloc] initWithBlock:^{
        NSLog(@"呵呵呵，%@",[NSThread currentThread]);
        [self performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:NO];
    }];
    t2.name = @"线程二";
    [t2 start];
}

- (IBAction)test3:(id)sender {
    
}

- (IBAction)test4:(id)sender {
    
}

@end
