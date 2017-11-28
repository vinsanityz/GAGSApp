//
//  STBTopView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/24.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "STBTopView.h"

@implementation STBTopView
+(instancetype)show{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"STBTopView" owner:nil options:nil] lastObject] ;
    
}


@end
