//
//  AddressViewController.h
//  CS_WeiTV
//
//  Created by Nina on 15/11/2.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "CommonCtr.h"

#import "AreaObject.h"


typedef void (^ReturnAddressBlock)(NSString *str);

@interface AddressViewController : CommonCtr

@property (nonatomic,strong) UITextField *cityTextField;    //省市
@property (nonatomic,strong) UITextField *countyTextField;  //区县
@property (nonatomic,strong) UITextField *streetTextField;  //街道
@property (nonatomic,strong) UITextField *detailTextField;  //详细地址
@property (nonatomic,copy) ReturnAddressBlock addressBlock;
@property (nonatomic,strong) NSString *cityStr;             //属性传值，最终的地址信息
@property (nonatomic,assign) NSUInteger pickedStateIndex;   //选中的地区编号
@property (nonatomic,assign) NSUInteger pickedCityIndex;    //选中的城市编号
@property(nonatomic,copy) NSString *str;                    //代表合并后的字符串
@property(nonatomic,copy) NSString *identifier;

@end
