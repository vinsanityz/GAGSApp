//
//  PlayExceptionTip.h
//  CS_WeiTV
//
//  Created by Nina on 16/12/26.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define ExceptionAppearWithDisappearTime 0.2
#define ExceptionShowTime 3.0


@interface PlayExceptionTip : NSObject

+(void)addPopString:(NSString *)str;
+(void)setbShowSidewards:(Boolean)bSetIn;


@end
