//
//  ZCZProgressBar.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCZProgressBarDelegate <NSObject>
/**持续拖动滑块*/
- (void)ZCZProgressBarSliderContinuousSliding:(CGFloat)buttonX;
/**停止拖动滑块*/
- (void)ZCZProgressBarSliderEndSliding;
/**播放暂停按钮点击*/
- (void)ZCZProgressBarPlayOrPauseBtnClick:(UIButton *)btn;

-(void)resetProcessBarHiddenTime;
@end

@interface ZCZProgressBar : UIView

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic,assign) CGFloat movieDurationTime;
@property (nonatomic, weak) id<ZCZProgressBarDelegate> delegate;

-(CGFloat)adjustProgressViewAndprogressBarSlider:(CGFloat)TapPointX;
//-(void)adjustTimeLabel:(CGFloat)time;
//-(void)adjustleftTimeLabelAndProgressView:(CGFloat)time;
-(void)changeProgressViewWidthAndSliderCenterByTimer:(CGFloat)currentTime;
-(void)setBackgroundViewWidth:(CGFloat)width;
-(void)updateBufferViewWidth:(CGFloat)bufferValue;
@end


