//
//  ZCZProgressBarButton.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCZProgressBarButtonDelegate <NSObject>

- (void)ZCZProgressBarButtonMoved:(CGFloat)buttonX;//协议方法
- (void)ZCZProgressBarButtonMovedEnd;
@end


@interface ZCZProgressBarButton : UIView
@property (nonatomic, weak) id<ZCZProgressBarButtonDelegate> delegate;
@end
