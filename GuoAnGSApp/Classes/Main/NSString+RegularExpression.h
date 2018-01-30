//
//  NSString+RegularExpression.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/23.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)
- (BOOL)isUserName;
- (BOOL)isPassword;
- (BOOL)isPhoneNumber;
@end
