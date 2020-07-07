//
//  MainViewController.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/7/5.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "MainViewController.h"
#import "ThreadViewController.h"
#import "GCDViewController.h"
#import "OperationViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)NSThreadTest:(id)sender {
    ThreadViewController * vc = [ThreadViewController instance];
    [self pushVC:vc];
}

- (IBAction)GCDTest:(id)sender {
    GCDViewController * vc = [GCDViewController instance];
    [self pushVC:vc];
}


- (IBAction)NSOperationTest:(id)sender {
    OperationViewController * vc = [OperationViewController instance];
    [self pushVC:vc];
}


@end
