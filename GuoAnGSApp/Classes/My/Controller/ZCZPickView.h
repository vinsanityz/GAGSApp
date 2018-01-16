//
//  ZCZPickView.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/8.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCZPickView;

@protocol ZCZPickViewDelegate <NSObject>
@optional

-(void)headerBarDoneBtnCilck:(ZCZPickView *)pickView WithFinalString:(NSString * )resultString;
-(void)headerBarCancelBtnClick;
@end


@interface ZCZPickView : UIView
@property(nonatomic,weak) id<ZCZPickViewDelegate> delegate;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *btn;

-(instancetype)initForAreaPickView;

- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode;

-(instancetype)initSinglePickerWithArray:(NSArray * )array;
@end
