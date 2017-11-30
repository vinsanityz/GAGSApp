//
//  ZCZProgressBar.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZProgressBar.h"

#import "UIView+Frame.h"
#import "ZCZProgressBarButton.h"

@interface ZCZProgressBar()<ZCZProgressBarButtonDelegate>
//背景条
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//缓冲条
@property (weak, nonatomic) IBOutlet UIView *bufferView;
//滑块
@property (weak, nonatomic) IBOutlet ZCZProgressBarButton *progressBarButton;
//总时长
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
//已播放时长
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;

@end

@implementation ZCZProgressBar

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.progressBarButton.delegate = self;
    
}

-(void)ZCZProgressBarButtonMoved:(CGFloat)buttonX
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZadjustProgressBarLayout:)]) {
        [self.delegate ZCZadjustProgressBarLayout:buttonX];
    }
    
}

-(void)ZCZProgressBarButtonMovedEnd
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(ZCZadjustProgressBarLayout:)]) {
        [self.delegate ZCZadjustProgressBarLayoutLast];
    }
    
}

-(void)setMovieDurationTime:(CGFloat)movieDurationTime
{
    _movieDurationTime = movieDurationTime;
    self.rightTimeLabel.text = [self adjustTimeFormat:movieDurationTime];
    
}

-(void)adjustleftTimeLabelAndProgressView:(CGFloat)buttonX
{
    CGRect frame = self.progressView.frame;
    frame.size.width = buttonX-frame.origin.x;
    self.progressView.frame = frame;
    CGFloat Lefttime = frame.size.width/240*self.movieDurationTime;
    self.leftTimeLabel.text = [self adjustTimeFormat:Lefttime];
}

#pragma mark - <根据点击手势所在点的X值，来重新确定进度条与滑块的位置>
-(void)adjustProgressViewAndProgressBarButton:(CGFloat)TapPointX
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
    self.progressBarButton.center = CGPointMake(TapPointX, self.progressBarButton.center.y);
    //修改进度条的位置
    self.progressView.zcz_width = TapPointX-minX;
    //修改已经播放的时间
    CGFloat Lefttime = self.progressView.zcz_width/self.backgroundView.zcz_width*self.movieDurationTime;
    self.leftTimeLabel.text = [self adjustTimeFormat:Lefttime];
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
