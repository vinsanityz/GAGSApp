//
//  ZCZTipsView.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/10.
//  Copyright © 2018年 zcz. All rights reserved.
//
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

#import <UIKit/UIKit.h>

@interface ZCZTipsView : UIView
+(instancetype)sharedZCZTipsView;
-(void)showWithString:(NSString *)str;
@end
