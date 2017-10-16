//
//  ChooseAddressVC.h
//  CS_WeiTV
//
//  Created by Nina on 16/4/20.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "CommonCtr.h"


@protocol BtnAddressInfoDelegate <NSObject>

-(void)btnAddressInfoIP:(NSString *)IP port:(NSString *)port;

@end


@interface ChooseAddressVC : CommonCtr

@property(nonatomic,copy)NSString *btnTitle;

@end
