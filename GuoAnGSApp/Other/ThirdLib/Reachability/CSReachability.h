//
//  CSReachability.h
//  CS_WeiTV
//
//  Created by Nina on 16/3/8.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


//未使用
typedef void(^reachabilityBlock)(NetworkStatus status);

@protocol CSReachabilityDelegate <NSObject>
@optional
/*网络状态发生变化 调用此代理方法*/
-(void)netWorkChangedAction:(NetworkStatus)status;
@end


@interface CSReachability : NSObject

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign) NetworkStatus CSReachabilityStatus;
@property(nonatomic,weak) id <CSReachabilityDelegate> delegate ;

/*网络状态发生变化 调用此block*/
@property (nonatomic,copy) reachabilityBlock networkChangedBlock;

+ (instancetype)shareInstance;
//-(void)notifyNetWorkChanged;

@end
