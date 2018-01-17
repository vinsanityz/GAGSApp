//
//  ZCZPickView.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/8.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCZPickView;
@class SingleColor;

@protocol ZCZPickViewDelegate <NSObject>
@optional
-(void)headerBarDoneBtnCilck:(ZCZPickView *)pickView WithFinalString:(NSString * )resultString;
-(void)headerBarCancelBtnClick;
@end

@interface ZCZPickView : UIView

@property(nonatomic,weak) id<ZCZPickViewDelegate> delegate;
//颜色单例
@property(nonatomic,strong)SingleColor * singleColor;
//地区的pickView
-(instancetype)initForAreaPickView;
//日期的datepickView
- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode;
//单列的pickview
-(instancetype)initSinglePickerWithArray:(NSArray * )array;
@end
