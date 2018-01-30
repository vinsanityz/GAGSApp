//
//  NSString+RegularExpression.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/23.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)


//用户名格式是否正确
- (BOOL)isUserName
{
    /**
     * "\w" 匹配包括下划线的任何单词字符    等价于   "[A-Za-z0-9_]"
     **/
    NSLog(@"判断用户名");
    //包括数字字符下划线，4-18位
    NSString * phoneRegex = @"^[A-Za-z0-9_]{4,18}$";
    NSPredicate *phoneP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSLog(@"%u",[phoneP evaluateWithObject:self]);
    
    return [phoneP evaluateWithObject:self];
}
//密码格式是否正确
- (BOOL)isPassword
{
    NSLog(@"判断密码");
    //不包含空格，6-18位
    NSString *phoneRegex = @"^[^\\s]{6,18}$";
    NSPredicate *phoneP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSLog(@"%u",[phoneP evaluateWithObject:self]);
    return [phoneP evaluateWithObject:self];
}
//手机号码格式是否正确
- (BOOL)isPhoneNumber
{
    //^1[3|4|5|7|8][0-9]\\d{8}$
    //.手机号：11位数字。其他内容属于非法内容，提示用户输入有误。
    NSLog(@"判断手机号");
    //手机号位数为11，且均为数字
    NSString *phoneRegex = @"^[0-9]{11}$";
    NSPredicate *phoneP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSLog(@"%u",[phoneP evaluateWithObject:self]);
    
    return [phoneP evaluateWithObject:self];
}

@end
