//
//  sexVC.h
//  CS_WeiTV
//
//  Created by Nina on 15/9/17.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "CommonCtr.h"


typedef void(^genderPassBlock)(NSString *str);

@interface sexVC : CommonCtr

@property(nonatomic,copy) NSString *identifier;
@property(nonatomic,copy) genderPassBlock genderBlock;
@property(nonatomic,copy) NSString *gengderStr;

@end
