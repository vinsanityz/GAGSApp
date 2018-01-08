//
//  ZHPickView.h
//  ZHpickView
//
//  Created by Nina on 15-11-12.
//  Copyright (c) 2015年 wy All rights reserved.


#import <UIKit/UIKit.h>
#import "ParamFile.h"

@class AddressViewController;
@class ZHPickView;


@protocol ZHPickViewDelegate <NSObject>
@optional
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString;
-(void)headerBarCancelBtnClick;
@end


@interface ZHPickView : UIView {
    SingleColor *colorData;
}

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *btn;
@property(nonatomic,weak) id<ZHPickViewDelegate> delegate;


// 用于显示生日选择器：
-(instancetype)initPickviewWithPlistName:(NSString *)plistName isAreaPickerView:(BOOL) b;
// 用于显示地区、字体、颜色选择器：
-(instancetype)initPickviewWithArray:(NSArray *)array isAreaPickerView:(BOOL) b;
//用于显示生日
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode ;


- (instancetype)initPickerViewWithDataArray:(NSArray *)dataArray key:(id)key;


@property(nonatomic,strong)NSArray *statesArray;
@property(nonatomic,strong)NSArray *countiesArray;

@property (nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,weak) AddressViewController *addressVC;

@property(nonatomic,assign)NSInteger newStateIndex;
@property(nonatomic,assign)NSInteger newCityIndex;
@property(nonatomic,assign)NSInteger newCountyIndex;

@property(nonatomic,assign)NSInteger oldStateIndex;
@property(nonatomic,assign)NSInteger oldCityIndex;
@property(nonatomic,assign)NSInteger oldCountyIndex;

//显示本控件
-(void)show;


@end
