//
//  LoadReturnModel.m
//  CS_WeiTV
//
//  Created by Nina on 16/9/9.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "LoadReturnModel.h"

@implementation LoadReturnModel


+(id)itemLoadReturnModelWithDictionary:(NSDictionary *)dict
{
    LoadReturnModel *model = [[LoadReturnModel alloc]init];
    model.appUserId = dict[@"appUserId"];
    model.appUserName = dict[@"appUserName"];
    model.phoneNo = dict[@"phoneNo"];
    model.address = dict[@"address"];
    model.cAdderss = dict[@"cAdderss"];
    model.headPortraitUrl = dict[@"headPortraitUrl"];
    model.sex= dict[@"sex"];
    model.lastName= dict[@"lastName"];
    model.birthday = dict[@"birthday"];
    model.returnCode = dict[@"returnCode"];
    model.returnMsg = dict[@"returnMsg"];
    model.ip = dict[@"ip"];
    model.port = dict[@"port"];
    return model;
}

@end
