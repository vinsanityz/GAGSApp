//
//  tableViewHeaderView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/12/28.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "tableViewHeaderView.h"
#import "UIView+Frame.h"

@interface tableViewHeaderView()
@property(nonatomic,strong)UIView * lineView;

@end

@implementation tableViewHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width/4, 2)];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
}
- (IBAction)headerBtnClick:(UIButton *)sender {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
