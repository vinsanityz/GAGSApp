//
//  CSReachability.m
//  CS_WeiTV
//
//  Created by Nina on 16/3/8.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "CSReachability.h"

@interface CSReachability ()

//@property (nonatomic, strong) Reachability *reachability;

@end

@implementation CSReachability

+ (instancetype)shareInstance {
    static CSReachability *reachability = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        reachability = [[CSReachability alloc] init];
    });
    return reachability;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化网路监测；检测手机是否能直接连上互联网
        self.reachability = [Reachability  reachabilityForInternetConnection];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChangeAction:) name:kReachabilityChangedNotification object:nil];
        [self.reachability startNotifier];//添加通知到Run Loop
        //将网络状态值传到其他控制器
         self.CSReachabilityStatus = [self.reachability currentReachabilityStatus];
        NSLog(@"状态：%ld",(long)self.CSReachabilityStatus);
    }
    return self;
}


- (void)handleNetworkChangeAction:(NSNotification *)sender
{
    Reachability *reach = [sender object];
    if ([reach isKindOfClass:[Reachability class]]) {
        NetworkStatus status = [reach currentReachabilityStatus];
        self.CSReachabilityStatus = status;//将网络状态值传到其他控制器
        NSLog(@"notify状态：%ld", (long)status);
        switch (status) {
            case NotReachable:
            {
                [HJSTKToastView addPopString:@"无网络连接"];
                break;
            }
            case ReachableViaWWAN:
            {
                [HJSTKToastView addPopString:@"正在使用蜂窝移动网"];
                break;
            }
            case ReachableViaWiFi:
            {
                [HJSTKToastView addPopString:@"正在使用Wi-Fi网络"];
                break;
            }
            default:
                break;
        }
        if (self.networkChangedBlock) {
            self.networkChangedBlock(status);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkChangedAction:)]) {
            [self.delegate netWorkChangedAction:status];
        }
    }
}


-(void)notifyNetWorkChanged
{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
