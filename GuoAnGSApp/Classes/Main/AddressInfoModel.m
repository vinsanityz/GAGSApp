
//
//  AddressInfoModel.m
//  CS_WeiTV
//
//  Created by Nina on 16/10/9.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "AddressInfoModel.h"

@implementation AddressInfoModel
+(id)itemAddressInfoWithDictionary:(NSDictionary *)dict
{
    AddressInfoModel *model = [[AddressInfoModel alloc]init];
    model.cAdderss = dict[@"cAdderss"];
    model.ip = dict[@"ip"];
    model.port = dict[@"port"];
    return model;
}

@end
