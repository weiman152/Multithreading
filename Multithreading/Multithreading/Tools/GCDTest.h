//
//  GCDTest.h
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/2.
//  Copyright © 2020 weiman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTest : NSObject<NSCopying,NSMutableCopying>

+(instancetype)shareGCDTest;

@end

NS_ASSUME_NONNULL_END
