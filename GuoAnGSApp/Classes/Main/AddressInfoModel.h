//
//  AddressInfoModel.h
//  CS_WeiTV
//
//  Created by Nina on 16/10/9.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfoModel : NSObject

@property(nonatomic,copy) NSString *cAdderss;
@property(nonatomic,copy) NSString *ip;
@property(nonatomic,copy) NSString *port;

+(id)itemAddressInfoWithDictionary:(NSDictionary *)dict;

@end
