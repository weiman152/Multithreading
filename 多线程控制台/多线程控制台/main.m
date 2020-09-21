//
//  main.m
//  多线程控制台
//
//  Created by wenhuanhuan on 2020/9/21.
//  Copyright © 2020 weiman. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSLog(@"000  %d", [NSThread isMultiThreaded]);
        NSLog(@"isMainThread: %d", [NSThread isMainThread]);
        NSLog(@"currentThread: %@", [NSThread currentThread]);
    }
    return 0;
}
