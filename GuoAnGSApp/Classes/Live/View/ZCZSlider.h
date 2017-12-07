//
//  ZCZSlider.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCZSliderDelegate <NSObject>
/** 持续拖拽滑块 */
- (void)ZCZSliderContinuousSliding:(CGFloat)buttonX;
/** 结束拖拽滑块 */
- (void)ZCZSliderEndSliding;
@end

@interface ZCZSlider : UIView
@property (nonatomic, weak) id<ZCZSliderDelegate> delegate;
@end
