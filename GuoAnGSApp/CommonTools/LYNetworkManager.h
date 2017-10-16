//
//  LYNetworkManager.h
//  Created by Nina on 16/7/29.
//  Copyright © 2016年 Nina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>


/**请求类型*/
typedef NS_ENUM(NSInteger, LYNetworkRequestType) {
    LYNetworkRequestTypeGet,
    LYNetworkRequestTypePost
};

//请求成功回调
typedef void (^requestSuccessBlock)(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject);
//请求失败回调
typedef void (^requestFailureBlock)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error);
typedef void (^downloadProgressBlock)(NSProgress * _Nullable downloadProgress);
typedef void (^uploadProgressBlock)(NSProgress * _Nullable uploadProgressBlock);


@interface LYNetworkManager : NSObject

+ (instancetype _Nullable)sharedManager;
//新增方法
+ (void)cancelAllRequest;
- (void)cancel;
-(void)setUpTaskArray;

/**除了返回地址列表页，及登录，其他get及post请求，均可调用一下这两个方法*/
//GET请求方法
+ (void)GET:(NSString * _Nonnull)url
parameters:(NSDictionary * _Nullable)params
successBlock:(requestSuccessBlock _Nonnull)success
failureBlock:(requestFailureBlock _Nonnull)failure;

//post请求方法
+ (void)POST:(NSString * _Nonnull)url
  parameters:(NSDictionary * _Nonnull)params
successBlock:(requestSuccessBlock _Nonnull)success
failureBlock:(requestFailureBlock _Nonnull)failure;

// 所有方法的根方法
+ (void)requestNetworkWithType:(LYNetworkRequestType)type
                           url:(NSString * _Nonnull)url
                    parameters:(NSDictionary * _Nonnull)params
              downloadProgress:(downloadProgressBlock _Nullable)downloadProgress
                updateProgress:(uploadProgressBlock _Nullable)uploadProgress
                  successBlock:(requestSuccessBlock _Nonnull)success
                  failureBlock:(requestFailureBlock _Nonnull)failure;

@end
