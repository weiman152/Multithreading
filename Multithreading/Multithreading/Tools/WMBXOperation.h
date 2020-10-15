//
//  WMBXOperation.h
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/14.
//  Copyright © 2020 weiman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
自定义并行操作，NSOperation的子类
 
 自定义并行的 NSOperation 则要复杂一点，首先必须重写以下几个方法：

 start: 所有并行的 Operations 都必须重写这个方法，然后在你想要执行的线程中手动调用这个方法。注意：任何时候都不能调用父类的start方法。
 main: 在start方法中调用，但是注意要定义独立的自动释放池与别的线程区分开。
 isExecuting: 是否执行中，需要实现KVO通知机制。
 isFinished: 是否已完成，需要实现KVO通知机制。
 isConcurrent: 该方法现在已经由isAsynchronous方法代替，并且 NSOperationQueue 也已经忽略这个方法的值。
 isAsynchronous: 该方法默认返回 NO ，表示非并发执行。并发执行需要自定义并且返回 YES。后面会根据这个返回值来决定是否并发。
 与非并发操作不同的是，需要另外自定义一个方法来执行操作而不是直接调用start方法.
*/
@interface WMBXOperation : NSOperation

//自定义方法,启动操作
-(BOOL)wmStart:(NSOperation *)op;

@end

NS_ASSUME_NONNULL_END
