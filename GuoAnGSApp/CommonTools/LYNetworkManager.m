//
//  LYNetworkManager.m
//
//  Created by Nina on 16/7/29.
//  Copyright © 2016年 Nina. All rights reserved.
//

#import "LYNetworkManager.h"
#import "ParamFile.h"
#import "HJSTKToastView.h"

@implementation LYNetworkManager
{
    NSMutableArray *taskArray;
}

+ (instancetype)sharedManager {
    static LYNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LYNetworkManager alloc] init];
    });
    return manager;
}


- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}


-(void)setUpTaskArray{
    taskArray = [[NSMutableArray alloc]init];
}

+ (void)cancelAllRequest {
    [[LYNetworkManager sharedManager] cancel];
}

- (void)cancel {
    for (NSURLSessionDataTask *dataTask in taskArray) {
        NSLog(@"任务取消");
        [dataTask cancel];
    }
}


//get请求
+ (void)GET:(NSString * _Nonnull)url
 parameters:(NSDictionary * _Nullable)params
successBlock:(requestSuccessBlock _Nonnull)success
failureBlock:(requestFailureBlock _Nonnull)failure {
    //登录返回后url的拼接路径
    NSString *urlStr;
    if (kPermanent_GET_OBJECT(KGetIP) != nil && kPermanent_GET_OBJECT(KGetPort) != nil) {
        urlStr = [NSString stringWithFormat:PreHttpCommon,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),url];
        NSLog(@"urlStr:%@",urlStr);
        [self requestNetworkWithType:LYNetworkRequestTypeGet url:urlStr parameters:params downloadProgress:nil updateProgress:nil successBlock:success failureBlock:failure];
    }

}

//post请求
+ (void)POST:(NSString * _Nonnull)url
  parameters:(NSDictionary * _Nonnull)params
successBlock:(requestSuccessBlock _Nonnull)success
failureBlock:(requestFailureBlock _Nonnull)failure {
    //登录返回后url的拼接路径
    NSLog(@"%@,%@",kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort));

    NSString *urlStr;
    if (kPermanent_GET_OBJECT(KGetIP) != nil && kPermanent_GET_OBJECT(KGetPort) != nil) {
       urlStr  = [NSString stringWithFormat:PreHttpCommon,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),url];
        NSLog(@"urlStr:%@",urlStr);
        [self requestNetworkWithType:LYNetworkRequestTypePost url:urlStr parameters:params downloadProgress:nil updateProgress:nil successBlock:success failureBlock:failure];
    }
}

//总方法，可以在这个方法上做很多拓展。（这里上传，下载，进度，都可以设置）
+ (void)requestNetworkWithType:(LYNetworkRequestType)type
                           url:(NSString * _Nonnull)url
                    parameters:(NSDictionary * _Nonnull)params
              downloadProgress:(downloadProgressBlock _Nullable)downloadProgress
                updateProgress:(uploadProgressBlock _Nullable)uploadProgress
                  successBlock:(requestSuccessBlock _Nonnull)success
                  failureBlock:(requestFailureBlock _Nonnull)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //默认提交请求的数据是二进制的，返回的格式是JSON
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
    //https ssl验证
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    
    switch (type) {
            
        case LYNetworkRequestTypeGet:
            [[self sharedManager] requestToGetWithManager:manager url:url parameters:params downloadProgress:downloadProgress sucessBlock:success failureBlock:failure];
            break;
        case LYNetworkRequestTypePost:
            [[self sharedManager] requestToPostWithManager:manager url:url parameters:params uploadProgress:uploadProgress successBlock:success failureBlock:failure];
        default:
            break;
    }
}


+ (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    
    return securityPolicy;
}


//对get请求的操作
- (void)requestToGetWithManager:(id)manager url:(NSString *)url parameters:(NSDictionary *)params downloadProgress:(downloadProgressBlock)downProgress sucessBlock:(requestSuccessBlock)success failureBlock:(requestFailureBlock)failure {
    NSURLSessionDataTask *dataTask =  [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downProgress) {
            downProgress(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     [taskArray removeObject:task];
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [taskArray removeObject:task];
        if (error.code == NSURLErrorCancelled) {
            return ;
        }
        if (failure) {
            failure(task, error);
        }
        [HJSTKToastView addPopString:error.localizedDescription];//错误提醒
    }];
    [taskArray addObject:dataTask];
}

//对post请求的操作
- (void)requestToPostWithManager:(id)manager url:(NSString *)url parameters:(NSDictionary *)params uploadProgress:(uploadProgressBlock)upProgress successBlock:(requestSuccessBlock)success failureBlock:
(requestFailureBlock)failure {
   
    NSURLSessionDataTask *dataTask = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (upProgress) {
            upProgress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //在进行下一个请求之前，移除之前请求数据，保证数组中存放当前数据
        [taskArray removeObject:task];//移除任务
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [taskArray removeObject:task]; //移除任务
        if (error.code == NSURLErrorCancelled) {
            return ;
        }
        if (failure) {
            failure(task, error);
        }
//        if (error.code == NSURLErrorTimedOut) {
//            [HJSTKToastView addPopString:NETWRONG];
//        }
        [HJSTKToastView addPopString:error.localizedDescription];//错误提醒
    }];
    [taskArray addObject:dataTask];//添加任务

}


@end
