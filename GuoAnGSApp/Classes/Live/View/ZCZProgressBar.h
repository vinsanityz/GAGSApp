//
//  ZCZProgressBar.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCZProgressBarDelegate <NSObject>

- (void)ZCZadjustProgressBarLayout:(CGFloat)buttonX;//协议方法
- (void)ZCZadjustProgressBarLayoutLast;
@end

@interface ZCZProgressBar : UIView

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (nonatomic,assign) CGFloat movieDurationTime;
@property (nonatomic, weak) id<ZCZProgressBarDelegate> delegate;

-(void)adjustProgressViewAndProgressBarButton:(CGFloat)TapPointX;
//-(void)adjustTimeLabel:(CGFloat)time;
-(void)adjustleftTimeLabelAndProgressView:(CGFloat)time;

@end


