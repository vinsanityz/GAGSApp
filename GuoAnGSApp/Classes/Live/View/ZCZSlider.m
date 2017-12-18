//
//  ZCZSlider.m
//  GuoAnGSApp


#import "ZCZSlider.h"
#import "UIView+Frame.h"

@implementation ZCZSlider

//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    NSLog(@"%@",NSStringFromCGRect(self.bounds));
//    UIImageView * view = [[UIImageView alloc]init];
//    view.image = [UIImage imageNamed:@"屏幕快照 2017-10-17 下午2.15.50"];
//    view.frame = self.bounds;
//    [self addSubview:view];
//    
//}


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
//    if (p.x>240+66) {
//        p.x = 306;
//    }
//    if (p.x<66) {
//        p.x = 66;
//    }
    NSLog(@"ZCZSliderX%f----ZCZSliderY%f",p.x,p.y);
//    CGRect frame =self.frame;
//    frame.origin.x = p.x-frame.size.width/2;
//    self.frame = frame;
//    self.zcz_x =p.x-self.zcz_width/2;
    
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZSliderContinuousSliding:)]) {
        [self.delegate ZCZSliderContinuousSliding:p.x];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZSliderEndSliding)]) {
        [self.delegate ZCZSliderEndSliding];
    }
}
@end
