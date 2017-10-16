//
//  ReturnModel.m
//  CS_WeiTV
//
//  Created by Nina on 16/9/6.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "ReturnModel.h"

@implementation ReturnModel


+(id)itemReturnModelWithDictionary:(NSDictionary *)dict
{
    ReturnModel *model = [[ReturnModel alloc]init];
    model.returnCode = dict[@"returnCode"];
    model.returnMsg = dict[@"returnMsg"];
    
    return model;
}




@end
