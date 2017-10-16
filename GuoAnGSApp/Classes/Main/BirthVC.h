//
//  BirthVC.h
//  CS_WeiTV
//
//  Created by Nina on 15/11/16.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "CommonCtr.h"

#import "ZHPickView.h"

typedef void(^returnTextBlock)(NSString *str);

@interface BirthVC : CommonCtr

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,copy) returnTextBlock returnText;
@property (nonatomic,copy) NSString *birthStr;//属性传值，生日
@property(nonatomic,copy) NSString *identifier;

@end
