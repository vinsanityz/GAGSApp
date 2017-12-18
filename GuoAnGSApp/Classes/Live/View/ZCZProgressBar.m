//
//  ZCZProgressBar.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZProgressBar.h"
#import "UIView+Frame.h"
#import "ZCZSlider.h"

@interface ZCZProgressBar()<ZCZSliderDelegate>

//播放暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
//背景条
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//缓冲条
@property (weak, nonatomic) IBOutlet UIView *bufferView;
//滑块
@property (weak, nonatomic) IBOutlet ZCZSlider *progressBarSlider;
//总时长
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
//已播放时长
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;

@end

@implementation ZCZProgressBar

//自己与自己的子控件如果被点击则初始化进度条隐藏时间
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"width%f---height%f",self.zcz_width,self.zcz_height);
    UIView *fitView = [super hitTest:point withEvent:event];
    
    if (self.zcz_width>self.zcz_height) {
        return fitView;
    }
    if ([[fitView superview] isKindOfClass:[self class]]||[fitView isKindOfClass:[self class]] ) {
        [self.delegate resetProcessBarHiddenTime];
//        NSLog(@"%@--%@",[fitView class],[fitView.superview class]);
    }
    return fitView;
}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"%d",[super pointInside:point withEvent:event]);
//    return [super pointInside:point withEvent:event];
//
//}

-(void)setBackgroundViewWidth:(CGFloat)width
{
    self.backgroundView.zcz_width = width;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.progressBarSlider.delegate = self;
}

//更新缓冲条的宽度
-(void)updateBufferViewWidth:(CGFloat)bufferValue
{
    self.bufferView.zcz_width = self.backgroundView.zcz_width*bufferValue;
    if (bufferValue>1) {
        self.bufferView.zcz_width = self.backgroundView.zcz_width;
    }
}


#pragma mark - <ZCZSliderDelegate>
//持续拖动滑块
-(void)ZCZSliderContinuousSliding:(CGFloat)pointX
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZProgressBarSliderContinuousSliding:)]) {
        [self.delegate ZCZProgressBarSliderContinuousSliding:pointX];
    }
}

//停止拖动滑块
-(void)ZCZSliderEndSliding
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZProgressBarSliderEndSliding)]) {
        [self.delegate ZCZProgressBarSliderEndSliding];
    }
}

//播放停止按钮被点击
- (IBAction)playOrPauseBtnClick:(UIButton *)sender {
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZProgressBarPlayOrPauseBtnClick: )]) {
        [self.delegate ZCZProgressBarPlayOrPauseBtnClick:sender];
    }
}

//片源总时间的set方法
-(void)setMovieDurationTime:(CGFloat)movieDurationTime
{
    _movieDurationTime = movieDurationTime;
    self.rightTimeLabel.text = [self adjustTimeFormat:movieDurationTime];
}

//-(void)adjustleftTimeLabelAndProgressView:(CGFloat)buttonX
//{
//    CGRect frame = self.progressView.frame;
//    frame.size.width = buttonX-frame.origin.x;
//    self.progressView.frame = frame;
//    CGFloat Lefttime = frame.size.width/240*self.movieDurationTime;
//    self.leftTimeLabel.text = [self adjustTimeFormat:Lefttime];
//}

//定时器重复调用此方法来修改滑块与进度条的UI
-(void)changeProgressViewWidthAndSliderCenterByTimer:(CGFloat)currentTime
{
    CGFloat pointX = currentTime/self.movieDurationTime*self.backgroundView.zcz_width+self.backgroundView.zcz_x;
    
//    NSLog(@"%f-----timer",pointX);
    [self adjustProgressViewAndprogressBarSlider:pointX];
    
}

#pragma mark - <根据点击手势所在点的X值，来重新确定进度条与滑块的位置>
-(CGFloat)adjustProgressViewAndprogressBarSlider:(CGFloat)TapPointX
{
    CGFloat maxX = CGRectGetMaxX(self.backgroundView.frame);
    CGFloat minX = CGRectGetMinX(self.backgroundView.frame);
    
    if (TapPointX>maxX) {
        TapPointX = maxX;
    }
    if (TapPointX<minX) {
        TapPointX = minX;
    }
    //修改滑块的位置
    self.progressBarSlider.center = CGPointMake(TapPointX, self.progressBarSlider.center.y);
    //修改进度条的宽度
    self.progressView.zcz_width = TapPointX-minX;
    
//    CGFloat Lefttime = (self.progressBarSlider.center.x-self.backgroundView.zcz_x)
    //修改已经播放的时间
    CGFloat Lefttime = self.progressView.zcz_width/self.backgroundView.zcz_width*self.movieDurationTime;
    self.leftTimeLabel.text = [self adjustTimeFormat:Lefttime];
//    NSLog(@"%f--%f--%f",Lefttime,self.progressView.zcz_width,self.movieDurationTime);
    return Lefttime;
}

#pragma mark - <把时间从CGFloat格式转换成00：00：00格式>
-(NSString *)adjustTimeFormat:(CGFloat)timeValue
{
    NSInteger hour =timeValue/3600;
    NSInteger minute = (timeValue-3600*hour)/60;
    NSInteger second = timeValue-3600*hour-60*minute;
    NSString * timeStr  = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    return timeStr;
}

@end
