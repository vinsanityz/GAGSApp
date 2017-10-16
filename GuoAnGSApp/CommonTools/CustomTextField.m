//
//  CustomTextField.m
//  CS_WeiTV
//
//  Created by Nina on 17/2/27.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField


//重写来重置编辑区域，控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
