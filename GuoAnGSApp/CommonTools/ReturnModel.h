//
//  ReturnModel.h
//  CS_WeiTV
//
//  Created by Nina on 16/9/6.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnModel : NSObject


@property(nonatomic,copy) NSNumber *returnCode;//返回代码
@property(nonatomic,copy) NSString *returnMsg;//错误信息


+(id)itemReturnModelWithDictionary:(NSDictionary *)dict;

@end
