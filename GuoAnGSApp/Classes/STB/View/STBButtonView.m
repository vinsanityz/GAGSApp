//
//  STBButtonView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/24.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "STBButtonView.h"

@implementation STBButtonView
+(instancetype)show{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"STBButtonView" owner:nil options:nil] lastObject] ;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
