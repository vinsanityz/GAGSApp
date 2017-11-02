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
- (IBAction)subBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickSTBButtonViewBtn:)]&&self.delegate!=nil) {
        
        [self.delegate didClickSTBButtonViewBtn:btn];
    }
    
}


@end
