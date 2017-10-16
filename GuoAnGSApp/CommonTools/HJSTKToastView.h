//
//  popLabel.h
//  textLabel
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//0.1秒用来出现及消失，1.0秒用来显示；多条toast弹出则依照弹出顺序依次完整显示

#import <UIKit/UIKit.h>


#define SERVERWRONG  @"没有数据，请稍后重试"
#define NETWRONG @"连接超时，请稍后重试"
#define NONetWork @"网络不给力"
#define NOConnectNet @"网络未连接"
#define HeadImageUploadSuccess @"上传头像成功"
#define HeadImageFailure @"头像上传失败"
#define NoMessage @"没有数据了"
#define NoMoreMessage @"没有更多数据了"
#define messageIsNULL @"数据为空"
#define INFO_NULL @"播放数据有误"



@interface HJSTKToastView:NSObject

+(void)addPopString:(NSString *)str;
+(void)setbShowSidewards:(Boolean)bSetIn;


@end
