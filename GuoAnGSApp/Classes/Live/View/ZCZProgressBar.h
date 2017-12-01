//
//  ZCZProgressBar.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCZProgressBarDelegate <NSObject>
/**当拖动滑块时调用*/
- (void)ZCZadjustProgressBarLayout:(CGFloat)buttonX;//协议方法
/**当停止拖动滑块时调用*/
- (void)ZCZadjustProgressBarLayoutLast;
/**当播放暂停按钮点击时调用*/
- (void)ZCZProgressBarPlayOrPauseBtnClick:(UIButton *)btn;
@end

@interface ZCZProgressBar : UIView

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic,assign) CGFloat movieDurationTime;
@property (nonatomic, weak) id<ZCZProgressBarDelegate> delegate;

-(CGFloat)adjustProgressViewAndProgressBarButton:(CGFloat)TapPointX;
//-(void)adjustTimeLabel:(CGFloat)time;
-(void)adjustleftTimeLabelAndProgressView:(CGFloat)time;
-(void)changeProgressViewWidthAndSliderCenterByTimer:(CGFloat)currentTime;
@end


