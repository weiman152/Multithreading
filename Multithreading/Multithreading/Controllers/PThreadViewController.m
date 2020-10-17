//
//  PThreadViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/9/20.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "PThreadViewController.h"
#import <pthread.h>

@interface PThreadViewController ()

@end

@implementation PThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//新线程调用方法，内容为要执行的任务
void * run(void * param){
    NSLog(@"任务执行，线程：%@", [NSThread currentThread]);
    return NULL;
}

- (IBAction)test1:(id)sender {
    //1. 创建线程，定义一个pthread_t类型的变量
    pthread_t thread;
    //2. 开启线程，执行任务
    pthread_create(&thread, NULL, run, NULL);
    //3. 设置子线程的状态设置为 detached，该线程运行结束后会自动释放所有资源
    pthread_detach(thread);
}

- (IBAction)test2:(id)sender {
    
}

- (IBAction)test3:(id)sender {
    
}


@end
