//
//  GCDTest.m
//  Multithreading
//
//  Created by wenhuanhuan on 2020/10/2.
//  Copyright © 2020 weiman. All rights reserved.
//

#import "GCDTest.h"

@implementation GCDTest

+(instancetype)shareGCDTest{
    return [[self alloc] init];
}

static GCDTest * instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance==nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

-(id)copyWithZone:(NSZone *)zone{
    return instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return instance;
}
@end
