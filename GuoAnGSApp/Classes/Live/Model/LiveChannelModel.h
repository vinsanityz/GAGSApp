//
//  LiveChannelModel.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/18.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveChannelModel : NSObject

@property(nonatomic,copy) NSString *channelTitleId; //频道id
@property(nonatomic,copy) NSString *channelTitle;//频道名称
@property(nonatomic,copy) NSString *channelPostUrl;//频道海报图片地址url
@end
