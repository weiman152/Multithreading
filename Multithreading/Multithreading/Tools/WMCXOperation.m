//
//  WMCXOperation.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/14.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "WMCXOperation.h"

@implementation WMCXOperation

- (void)main {
    NSLog(@"main 开始啦");
    @try {
        //任务是否结束标识
        BOOL isFinish = NO;
        //只有当没有执行完成和没有被取消，才执行自定义的相应操作
        while (isFinish==NO&&(self.isCancelled==NO)) {
            //睡眠1秒，模拟耗时
            sleep(1);
            NSLog(@"线程：%@",[NSThread currentThread]);
            isFinish = YES;
        }
    } @catch (NSException *exception) {
        NSLog(@"出现异常：%@",exception);
    } @finally {
        NSLog(@"哈哈哈");
    }
    NSLog(@"main 结束啦");
}

@end
