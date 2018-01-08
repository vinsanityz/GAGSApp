//
//  CSReachability.h
//  CS_WeiTV
//
//  Created by Nina on 16/3/8.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "HJSTKToastView.h"

typedef void(^reachabilityBlock)(NetworkStatus status);

@protocol CSReachabilityDelegate <NSObject>
@optional
/**监测到有网络的时候，重新进行网络请求**/
-(void)netWorkChangedAction:(NetworkStatus)status;
@end


@interface CSReachability : NSObject

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign) NetworkStatus CSReachabilityStatus;
@property (nonatomic,copy) reachabilityBlock networkChangedBlock;
@property(nonatomic,weak) id <CSReachabilityDelegate> delegate ;

+ (instancetype)shareInstance;
-(void)notifyNetWorkChanged;

@end
