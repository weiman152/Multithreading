//
//  BaseViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/7/5.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+(instancetype)instance {
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseViewController * vc = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)pushVC:(BaseViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc {
    NSLog(@"%@ 销毁了", NSStringFromClass([self class]));
}

@end
