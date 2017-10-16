//
//  NameVC.h
//  CS_WeiTV
//
//  Created by Nina on 15/8/26.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "CommonCtr.h"

typedef void(^PassingValueBlock)(UITextField *textField);

@interface NameVC : CommonCtr

@property (nonatomic,copy) PassingValueBlock passingValue;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,copy) NSString *nameStr;       //属性传值，昵称
@property (nonatomic,copy) NSString *identifier;    //标识

@end
