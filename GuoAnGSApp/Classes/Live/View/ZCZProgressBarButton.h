//
//  ZCZProgressBarButton.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCZProgressBarButtonDelegate <NSObject>
/** 拖拽滑块持续调用此方法 */
- (void)ZCZProgressBarButtonMoved:(CGFloat)buttonX;
/** 结束拖拽滑块调用此方法 */
- (void)ZCZProgressBarButtonMovedEnd;
@end

@interface ZCZProgressBarButton : UIView
@property (nonatomic, weak) id<ZCZProgressBarButtonDelegate> delegate;
@end
