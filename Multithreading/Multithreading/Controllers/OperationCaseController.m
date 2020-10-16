//
//  OperationCaseController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/16.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "OperationCaseController.h"

@interface OperationCaseController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageVFinal;
@property(nonatomic,strong)UIImage * image1;
@property(nonatomic,strong)UIImage * image2;
@end

@implementation OperationCaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)startAction:(id)sender {
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    //下载图片一
    NSBlockOperation * op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSString * str = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601638749466&di=92ace2ffa924fe6063e7a221729006b1&imgtype=0&src=http%3A%2F%2Fpic.autov.com.cn%2Fimages%2Fcms%2F20119%2F6%2F1315280805177.jpg";
        UIImage * image = [self downLoadImage:str];
        self.image1 = image;
        //回到主线程，显示图片
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageV1.image = image;
        }];
    }];
    //下载图片二
    NSBlockOperation * op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSString * str = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1601638873771&di=07129fd95c56096a4282d3b072594491&imgtype=0&src=http%3A%2F%2Fimg.51miz.com%2Fpreview%2Felement%2F00%2F01%2F12%2F49%2FE-1124994-5FFE5AC7.jpg";
        UIImage * image = [self downLoadImage:str];
        self.image2 = image;
        //回到主线程，显示图片
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageV2.image = image;
        }];
    }];
    //合成图片
    NSBlockOperation * op3 = [NSBlockOperation blockOperationWithBlock:^{
        UIImage * image = [self makeImage:self.image1 image2:self.image2];
        //回到主线程，显示图片
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageVFinal.image = image;
        }];
    }];
    //由于合成图片要在图片一和图片二完成之后才能进行，所以需要添加依赖
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
}

-(UIImage *)downLoadImage:(NSString *)str {
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSURL * url = [NSURL URLWithString:str];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:data];
    return image;
}

-(UIImage *)makeImage:(UIImage *)image1 image2:(UIImage *)image2 {
    //图形上下文开启
    UIGraphicsBeginImageContext(CGSizeMake(300, 200));
    
    //图形二
    [image2 drawInRect:CGRectMake(0, 0, 300, 200)];
    //图形一
    [image1 drawInRect:CGRectMake(100, 50, 100, 100)];
    //获取新的图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

@end
