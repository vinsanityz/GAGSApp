//
//  singleColor.m
//  CS_WeiTV
//
//  Created by wy on 15/9/23.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "SingleColor.h"

@implementation SingleColor

+(instancetype)sharedInstance
{
    static SingleColor *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

@end
