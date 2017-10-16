//
//  LoadReturnModel.h
//  CS_WeiTV
//
//  Created by Nina on 16/9/9.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadReturnModel : NSObject

@property(nonatomic,copy) NSString *appUserId;//用户Id
@property(nonatomic,copy) NSString *appUserName;//用户名
@property(nonatomic,copy) NSString *phoneNo;//手机号
@property(nonatomic,copy) NSString *address;//地址
@property(nonatomic,copy) NSString *cAdderss;//地区
@property(nonatomic,copy) NSString *headPortraitUrl;//头像路径
@property(nonatomic,copy) NSString *sex;//性别
@property(nonatomic,copy) NSString *lastName;//昵称
@property(nonatomic,copy) NSString *birthday;//生日yyyy-MM-dd
@property(nonatomic,copy) NSString *ip;//ip地址
@property(nonatomic,copy) NSString *port;//端口号
@property(nonatomic,strong) NSNumber *returnCode;
@property(nonatomic,copy) NSString *returnMsg;

+(id)itemLoadReturnModelWithDictionary:(NSDictionary *)dict;


@end
