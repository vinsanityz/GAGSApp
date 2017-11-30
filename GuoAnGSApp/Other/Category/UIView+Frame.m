//
//  UIView+Frame.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/30.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setZcz_height:(CGFloat)zcz_height
{
    CGRect rect = self.frame;
    rect.size.height = zcz_height;
    self.frame = rect;
}

- (CGFloat)zcz_height
{
    return self.frame.size.height;
}

- (CGFloat)zcz_width
{
    return self.frame.size.width;
}
- (void)setZcz_width:(CGFloat)zcz_width
{
    CGRect rect = self.frame;
    rect.size.width = zcz_width;
    self.frame = rect;
}

- (CGFloat)zcz_x
{
    return self.frame.origin.x;
    
}

- (void)setZcz_x:(CGFloat)zcz_x
{
    CGRect rect = self.frame;
    rect.origin.x = zcz_x;
    self.frame = rect;
}

- (void)setZcz_y:(CGFloat)zcz_y
{
    CGRect rect = self.frame;
    rect.origin.y = zcz_y;
    self.frame = rect;
}

- (CGFloat)zcz_y
{
    
    return self.frame.origin.y;
}

@end
