//
//  singleColor.h
//  CS_WeiTV
//
//  Created by wy on 15/9/23.
//  Copyright © 2015年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleColor : NSObject

@property(nonatomic,strong) NSDictionary *colorDic;
@property(nonatomic,assign) int fontSize;
@property(nonatomic,strong) NSString *colorEdition;
@property(nonatomic,strong) NSDictionary *fontDic;
//字体大小:大 小 正常
@property(nonatomic,strong) NSString *fontEdition;

+(instancetype)sharedInstance;

@end
