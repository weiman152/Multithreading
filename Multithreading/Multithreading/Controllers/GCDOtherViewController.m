//
//  GCDOtherViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/2.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "GCDOtherViewController.h"
#import "GCDTest.h"

@interface GCDOtherViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *finalImage;
@property (nonatomic,strong)UIImage * image1;
@property (nonatomic,strong)UIImage * image2;

@end

@implementation GCDOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//栅栏函数
- (IBAction)zhalan:(id)sender {
    //栅栏函数，可以控制任务的执行顺序
    //1.创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("并发队列", DISPATCH_QUEUE_CONCURRENT);
    //2.创建任务,异步任务
    dispatch_async(queue, ^{
        NSLog(@"任务一");
        [self run:@"1"];
    });
    dispatch_async(queue, ^{
        NSLog(@"任务二");
        [self run:@"2"];
    });
    //栅栏函数
    dispatch_barrier_async(queue, ^{
        NSLog(@"###############我是个栅栏################");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"任务三");
        [self run:@"3"];
    });
    dispatch_async(queue, ^{
        NSLog(@"任务四");
        [self run:@"4"];
    });
    
}

-(void)run:(NSString *)mark {
    for (int i = 0; i<5; i++) {
        NSLog(@"任务：%@，i = %d, 线程：%@",mark,i,[NSThread currentThread]);
    }
}

//延迟执行
- (IBAction)yanchi:(id)sender {
    //在主线程中延迟2秒执行
    NSLog(@"开始啦！");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"哈哈哈哈哈，延迟了嘛");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    NSLog(@"结束啦");
    
    //子线程中延迟3秒执行
    NSLog(@"再次开始啦");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"哎呀呀，3秒哦");
        NSLog(@"当前线程：%@",[NSThread currentThread]);
    });
    NSLog(@"又一次结束啦！");
    
    //延迟执行的其他方法
    [self performSelector:@selector(YC) withObject:nil afterDelay:2.0];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(YC) userInfo:nil repeats:NO];
}

-(void)YC {
    NSLog(@"延迟执行哟，线程：%@",[NSThread currentThread]);
}

//一次性代码
- (IBAction)onceAction:(id)sender {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"此代码只会执行一次。");
    });
    
    //创建个单例试试
    GCDTest * test1 = [[GCDTest alloc] init];
    GCDTest * test2 = [GCDTest shareGCDTest];
    GCDTest * test3 = [test1 copy];
    GCDTest * test4 = [test1 mutableCopy];
    NSLog(@"test1:%@",test1);
    NSLog(@"test2:%@",test2);
    NSLog(@"test3:%@",test3);
    NSLog(@"test4:%@",test4);
}

//快速迭代
- (IBAction)kuaisu:(id)sender {
    NSLog(@"开始快速迭代");
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"index=%zd, 线程：%@",index, [NSThread currentThread]);
    });
    
}

//队列组
- (IBAction)duilie:(id)sender {
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    //创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("并发", DISPATCH_QUEUE_CONCURRENT);
    //执行队列组任务
    dispatch_group_async(group, queue, ^{
        NSLog(@"这是个队列组中的任务,编号1");
        NSLog(@"任务一：线程%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"这是个队列组中的任务,编号2,睡了1秒");
        NSLog(@"任务二：线程%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"这是个队列组中的任务,编号3");
        NSLog(@"任务三：线程%@",[NSThread currentThread]);
    });
    //队列组执行完之后执行的函数
    dispatch_group_notify(group, queue, ^{
        NSLog(@"队列组任务执行完成。");
    });
}

//队列组案例：合成图片
- (IBAction)groupDemo:(id)sender {
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("并发", DISPATCH_QUEUE_CONCURRENT);
    //3.下载图片一
    dispatch_group_async(group, queue, ^{
        NSString * str = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601638749466&di=92ace2ffa924fe6063e7a221729006b1&imgtype=0&src=http%3A%2F%2Fpic.autov.com.cn%2Fimages%2Fcms%2F20119%2F6%2F1315280805177.jpg";
        self.image1 = [self loadImage:str];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageOne.image = self.image1;
        });
        
    });
    //4.下载图片二
    dispatch_group_async(group, queue, ^{
        NSString * str = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601638873771&di=07129fd95c56096a4282d3b072594491&imgtype=0&src=http%3A%2F%2Fimg.51miz.com%2Fpreview%2Felement%2F00%2F01%2F12%2F49%2FE-1124994-5FFE5AC7.jpg";
        self.image2 = [self loadImage:str];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageTwo.image = self.image2;
        });
    });
    //5.合成图片
    dispatch_group_notify(group, queue, ^{
        //图形上下文开启
        UIGraphicsBeginImageContext(CGSizeMake(300, 200));
        
        //图形二
        [self.image2 drawInRect:CGRectMake(0, 0, 300, 200)];
        //图形一
        [self.image1 drawInRect:CGRectMake(100, 50, 100, 100)];
        //获取新的图片
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        //回到主线程，显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.finalImage.image = image;
            NSLog(@"完成图片的合成");
        });
    });
}
//下载图片
-(UIImage *)loadImage:(NSString *)strUrl {
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSURL * url = [NSURL URLWithString:strUrl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:data];
    return image;
}



@end
