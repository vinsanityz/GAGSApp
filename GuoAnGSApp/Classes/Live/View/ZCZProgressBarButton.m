//
//  ZCZProgressBarButton.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZProgressBarButton.h"

@implementation ZCZProgressBarButton

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    //当前的point
//    CGPoint currentP = [touch locationInView:self];
//    //以前的point
//    CGPoint preP = [touch previousLocationInView:self];
//    //x轴偏移的量
//    CGFloat offsetX = currentP.x - preP.x;
//
//    self.transform = CGAffineTransformTranslate(self.transform, offsetX, 0);
    
    
    
    CGPoint p = [[touches anyObject] locationInView:self.superview];
    if (p.x>240+66) {
        p.x = 306;
    }
    if (p.x<66) {
        p.x = 66;
    }
    NSLog(@"%f",p.x);
    CGRect frame =self.frame;
    frame.origin.x = p.x-frame.size.width/2;
    self.frame = frame;
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZProgressBarButtonMoved:)]) {
        [self.delegate ZCZProgressBarButtonMoved:p.x];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZProgressBarButtonMoved:)]) {
        [self.delegate ZCZProgressBarButtonMovedEnd];
    }
}
@end
