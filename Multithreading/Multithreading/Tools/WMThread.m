//
//  WMThread.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/9/21.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "WMThread.h"

@implementation WMThread

-(void)main{
    [super main];
    while (1) {
        if ([self isCancelled]) {
            [NSThread exit];
        }
        NSLog(@"thread name: %@",[NSThread currentThread]);
    }
}

-(void)cancel{
    [super cancel];
    if ([self isCancelled]) {
        [NSThread exit];
    }
    NSLog(@"thread name: %@",[NSThread currentThread]);
}

@end
