//
//  GCDViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/7/5.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *showImg;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//队列
-(void)test{
    //1. 创建队列
    /**
     // 第一个参数const char *label : C语言字符串，用来标识
     // 第二个参数dispatch_queue_attr_t attr : 队列的类型
     // 并发队列:DISPATCH_QUEUE_CONCURRENT
     // 串行队列:DISPATCH_QUEUE_SERIAL 或者 NULL
     dispatch_queue_t queue = dispatch_queue_create(const char *label, dispatch_queue_attr_t attr);
     */
    //1.1 并发队列
    //可以开启多个线程，任务并发执行
    dispatch_queue_t BFqueue = dispatch_queue_create("BFqueue", DISPATCH_QUEUE_CONCURRENT);
    //1.2 串行队列
    //任务一个接一个的执行,在一个线程中
    dispatch_queue_t CXqueue = dispatch_queue_create("CXqueue", DISPATCH_QUEUE_SERIAL);
    //1.3 系统默认提供全局并发队列，供使用
    /**
    系统默认全局队列 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     第一个参数：队列优先级
     #define DISPATCH_QUEUE_PRIORITY_HIGH 2 // 高
     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0 // 默认
     #define DISPATCH_QUEUE_PRIORITY_LOW (-2) // 低
     #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN // 后台
     第二个参数: 预留参数  0
     */
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //1.4 获得主队列
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
}

//任务
-(void)test2{
   //1. 同步任务：立刻开始执行
    /**
     第一个参数：队列
     第二个参数：要执行的操作，是个Block
     */
    dispatch_sync(dispatch_get_main_queue(), ^{
        //同步执行的任务
    });
    
    //2. 异步任务:等主线程执行完以后，开启子线程执行任务
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //异步执行的任务
    });
}

//任务和队列的组合
//1.同步任务+串行队列
- (IBAction)gcdTest1:(id)sender {
    
   // [self test1_1];
    /**
    总结：同步任务是不开启新的线程，把任务添加到当前线程中，当前线程是主线程，所以是添加到主线程中.串行队列是任务一个接一个的执行。这里有三个任务，也是先执行任务一，然后执行任务二，最后是任务三。
     打印结果：
     2020-09-29 15:03:58.965539+0800 多线程[3069:121374] 开始测试啦！
     2020-09-29 15:03:58.965869+0800 多线程[3069:121374] 1.同步任务+串行队列
     2020-09-29 15:03:58.966169+0800 多线程[3069:121374] 当前线程：<NSThread: 0x600000478980>{number = 1, name = main}
     2020-09-29 15:04:00.967371+0800 多线程[3069:121374] 同步任务二+串行，睡了2秒
     2020-09-29 15:04:00.967774+0800 多线程[3069:121374] 当前线程：<NSThread: 0x600000478980>{number = 1, name = main}
     2020-09-29 15:04:00.967987+0800 多线程[3069:121374] 同步任务三+串行
     2020-09-29 15:04:00.968206+0800 多线程[3069:121374] 当前线程：<NSThread: 0x600000478980>{number = 1, name = main}
     2020-09-29 15:04:00.968428+0800 多线程[3069:121374] 测试结束啦！
     */
    
    //我们自己创建个线程试试看
    [NSThread detachNewThreadWithBlock:^{
        [self test1_1];
    }];
    //结果与上次一样
    /**
     2020-09-29 15:30:53.381501+0800 多线程[3253:131992] 开始测试啦！
     2020-09-29 15:30:53.381831+0800 多线程[3253:131992] 1.同步任务+串行队列
     2020-09-29 15:30:53.382813+0800 多线程[3253:131992] 当前线程：<NSThread: 0x600003f53680>{number = 7, name = (null)}
     2020-09-29 15:30:55.386012+0800 多线程[3253:131992] 同步任务二+串行，睡了2秒
     2020-09-29 15:30:55.386528+0800 多线程[3253:131992] 当前线程：<NSThread: 0x600003f53680>{number = 7, name = (null)}
     2020-09-29 15:30:55.386772+0800 多线程[3253:131992] 同步任务三+串行
     2020-09-29 15:30:55.387163+0800 多线程[3253:131992] 当前线程：<NSThread: 0x600003f53680>{number = 7, name = (null)}
     2020-09-29 15:30:55.387616+0800 多线程[3253:131992] 测试结束啦！
     */
}

-(void)test1_1{
    NSLog(@"开始测试啦！");
    //1.同步任务+串行队列
    dispatch_queue_t cxQ1 = dispatch_queue_create("串行队列一", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(cxQ1, ^{
        NSLog(@"1.同步任务+串行队列");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    dispatch_sync(cxQ1, ^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"同步任务二+串行，睡了2秒");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    dispatch_sync(cxQ1, ^{
        NSLog(@"同步任务三+串行");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    NSLog(@"测试结束啦！");
}

//2.同步任务+并发队列
- (IBAction)gcdTest2:(id)sender {
    NSLog(@"开始测试啦，2.同步任务+并发队列");
    dispatch_queue_t bfQ = dispatch_queue_create("并发队列", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(bfQ, ^{
        NSLog(@"任务一");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    dispatch_sync(bfQ, ^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"任务二");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    dispatch_sync(bfQ, ^{
        NSLog(@"任务三");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    NSLog(@"测试结束啦");
    /**
     总结：同步任务，把任务添加到当前线程，当前在主线程，所以三个任务都添加到主线程中执行。
     */
}

//3.异步任务+串行队列
- (IBAction)gcdTest3:(id)sender {
    NSLog(@"开始测试，3.异步任务+串行队列");
    dispatch_queue_t cxq = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
    dispatch_async(cxq, ^{
        NSLog(@"任务一");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    dispatch_async(cxq, ^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    dispatch_async(cxq, ^{
        NSLog(@"任务三");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    NSLog(@"测试结束啦！");
}

//4.异步任务+并发队列
- (IBAction)gcdTest4:(id)sender {
    NSLog(@"测试开始，异步任务+并发队列");
    dispatch_queue_t bfq = dispatch_queue_create("并发队列", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(bfq, ^{
        NSLog(@"任务一");
        NSLog(@"1.当前线程：%@",[NSThread currentThread]);
    });
    dispatch_async(bfq, ^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二");
        NSLog(@"2.当前线程：%@",[NSThread currentThread]);
    });
    dispatch_async(bfq, ^{
        NSLog(@"任务三");
        NSLog(@"3.当前线程：%@",[NSThread currentThread]);
    });
    NSLog(@"测试结束了！");
}

//5.同步任务+主队列:死锁
- (IBAction)gcdTest5:(id)sender {
    NSLog(@"测试开始，同步任务+主队列");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"任务一");
        NSLog(@"1.线程：%@",[NSThread currentThread]);
    });
    NSLog(@"测试结束");
}

//6.异步任务+主队列
- (IBAction)gcdTest6:(id)sender {
    NSLog(@"测试开始，异步任务+主队列");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"任务一");
        NSLog(@"1.线程：%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二");
        NSLog(@"2.线程：%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"任务三");
        NSLog(@"3.线程：%@",[NSThread currentThread]);
    });
    NSLog(@"测试结束。");
}

//7.同步任务+全局队列（也是并发队列）
- (IBAction)gcdTest7:(id)sender {
    NSLog(@"开始，同步任务+全局队列（也是并发队列）");
    dispatch_queue_t global = dispatch_get_global_queue(0, 0);
    dispatch_sync(global, ^{
        NSLog(@"任务一");
        NSLog(@"1.线程：%@",[NSThread currentThread]);
    });
    dispatch_sync(global, ^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二");
        NSLog(@"2.线程：%@",[NSThread currentThread]);
    });
    dispatch_sync(global, ^{
        NSLog(@"任务三");
        NSLog(@"3.线程：%@",[NSThread currentThread]);
    });
    NSLog(@"测试结束了！");
}

//8.异步任务+全局队列（也是并发队列）
- (IBAction)gcdTest8:(id)sender {
    NSLog(@"开始，异步任务+全局队列");
    dispatch_queue_t global = dispatch_get_global_queue(0, 0);
    dispatch_async(global, ^{
        NSLog(@"任务一");
        NSLog(@"1.线程：%@",[NSThread currentThread]);
    });
    dispatch_async(global, ^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"任务二");
        NSLog(@"2.线程：%@",[NSThread currentThread]);
    });
    dispatch_async(global, ^{
        NSLog(@"任务三");
        NSLog(@"3.线程：%@",[NSThread currentThread]);
    });
    
    NSLog(@"测试结束了");
}

//案例：下载图片，并显示
- (IBAction)downLoad:(id)sender {
    NSString * url = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601469152745&di=b68e17d74c30d400e1df9473ded0eb1c&imgtype=0&src=http%3A%2F%2Fhbimg.huabanimg.com%2F959c8754d77244788f5a8f775ee36dec4a5d362e236d9-eP3CI9_fw658";
    dispatch_queue_t global = dispatch_get_global_queue(0, 0);
    dispatch_async(global, ^{
        NSURL * imgUrl = [NSURL URLWithString:url];
        NSData * data = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"下载图的线程：%@",[NSThread currentThread]);
        //回到主线程，给图片赋值
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showImg.image = image;
            NSLog(@"显示图的线程：%@",[NSThread currentThread]);
        });
    });
}

@end
