//
//  WMBXOperation.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/14.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "WMBXOperation.h"

@interface WMBXOperation()
{
    BOOL executing;
    BOOL finished;
}
@end

@implementation WMBXOperation

//重写init方法
-(instancetype)init{
    if (self = [super init]) {
        executing = NO;
        finished = NO;
    }
    return self;
}

//重写start方法
-(void)start{
    //如果任务被取消了
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    //使用NSThread开辟子线程执行main方法
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

//重写main方法
-(void)main {
    NSLog(@"main 开始");
    @try {
        // 必须为自定义的 operation 提供 autorelease pool，因为 operation 完成后需要销毁。
        @autoreleasepool {
            BOOL isfinish = NO;
            while (isfinish==NO&&self.isCancelled==NO) {
                NSLog(@"线程: %@", [NSThread currentThread]);
                isfinish = YES;
            }
            [self completeOperation];
        }
    } @catch (NSException *exception) {
        NSLog(@"异常：%@",exception);
    } @finally {
        NSLog(@"嘿嘿");
    }
    
    NSLog(@"main 结束");
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

-(BOOL)isAsynchronous{
    return YES;
}

-(BOOL)isExecuting{
    return executing;
}

-(BOOL)isFinished{
    return finished;
}

-(BOOL)wmStart:(NSOperation *)op{
    BOOL run = NO;
    if ([op isReady]&&![op isCancelled]) {
        if ([op isAsynchronous]==NO) {
            [op start];
        }else{
            [NSThread detachNewThreadSelector:@selector(start) toTarget:op withObject:nil];
        }
        run = YES;
    }else if ([op isCancelled]){
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        finished = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        run = YES;
    }
    
    return run;
}

@end
