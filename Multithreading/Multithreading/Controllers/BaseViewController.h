//
//  BaseViewController.h
//  Multithreading
//
//  Created by wenhuanhuan on 2020/7/5.
//  Copyright © 2020 weiman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

/// 从StoryBoard创建VC
+(instancetype)instance;

-(void)pushVC: (BaseViewController *)vc;

@end

NS_ASSUME_NONNULL_END
