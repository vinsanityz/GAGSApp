//
//  ZCZTipsView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/10.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "ZCZTipsView.h"
#import <Masonry.h>

@interface ZCZTipsView()
@property(nonatomic,strong)UIView * ZCZTipsViewBackgroundView;
@property(nonatomic,strong)UIView * tipsLabelBackgroundView;
@property(nonatomic,strong)UILabel * tipsLabel;
@property(nonatomic,strong)NSMutableArray * tipsStringArray;
@property(nonatomic,strong)NSCondition * condition;
@end

@implementation ZCZTipsView

static ZCZTipsView * shareInstance = nil;

+(instancetype)sharedZCZTipsView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.left.right.bottom.equalTo(window);
        }];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.ZCZTipsViewBackgroundView];
        [self.ZCZTipsViewBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.right.bottom.equalTo(self);
        }];
        [self.ZCZTipsViewBackgroundView addSubview:self.tipsLabelBackgroundView];
        [self.tipsLabelBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.ZCZTipsViewBackgroundView);
            make.width.equalTo(@(300));
            make.height.equalTo(@(60));
        }];
        [self.tipsLabelBackgroundView addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
make.top.left.right.bottom.equalTo(self.tipsLabelBackgroundView);
        }];
    }
    
    self.hidden = YES;
    return self;
}

-(void)showWithString:(NSString *)str
{
    [self.condition lock];
    
    //上一个文字展示没有结束,就延迟1.5s在显示当前文字
    if (self.hidden == NO) {
        [self performSelector:@selector(showWithString:) withObject:str afterDelay:1.5];
        [self.condition unlock];
        return;
    }
    
    if (str==nil) {
        str = @"数据为空";
    }

    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window bringSubviewToFront:self];
    
    self.tipsLabelBackgroundView.alpha=0;
    self.hidden=NO;
    self.tipsLabel.text=str;
//    CGSize labelSize=[lastStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(180, 300) lineBreakMode:NSLineBreakByCharWrapping];
    
    [UIView animateWithDuration:0.5 animations:^{
           self.tipsLabelBackgroundView.alpha=1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
         self.tipsLabelBackgroundView.alpha=0;
        }completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }];
    
    [self.condition unlock];
    
}
-(UIView *)ZCZTipsViewBackgroundView
{
    if (_ZCZTipsViewBackgroundView==nil){
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    CGRect frame=CGRectMake(0,0,window.frame.size.width,window.frame.size.height);
    _ZCZTipsViewBackgroundView=[[UIView alloc] initWithFrame:frame];
    _ZCZTipsViewBackgroundView.backgroundColor=[UIColor clearColor];
    }
    return _ZCZTipsViewBackgroundView;
}

-(UIView *)tipsLabelBackgroundView
{
    if (_tipsLabelBackgroundView==nil) {
        _tipsLabelBackgroundView =[[UIView alloc] init];
        _tipsLabelBackgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _tipsLabelBackgroundView.layer.cornerRadius=5;
//        _tipsLabelBackgroundView.frame = CGRectMake(0, 200, 300, 60);
    }
    return _tipsLabelBackgroundView;
}

-(UILabel *)tipsLabel{
    if (_tipsLabel==nil) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.textColor=[UIColor whiteColor];
        _tipsLabel.font=[UIFont systemFontOfSize:15];
        _tipsLabel.numberOfLines=0;
        _tipsLabel.lineBreakMode=NSLineBreakByCharWrapping;
        _tipsLabel.textAlignment=NSTextAlignmentCenter;
//        _tipsLabel.frame = CGRectMake(0, 0, 300, 50);
    }
    return _tipsLabel;
}

-(NSMutableArray *)tipsStringArray
{
    if (_tipsStringArray==nil) {
        _tipsStringArray = [NSMutableArray array];
    }
    return _tipsStringArray;
}
@end
