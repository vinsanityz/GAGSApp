//
//  ZCZPickView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/8.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "ZCZPickView.h"
#import <Masonry.h>
#import "SingleColor.h"
#import "ParamFile.h"

@interface ZCZPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
//是否datepickView
@property(nonatomic,assign)BOOL isDatePicker;
//是否是单列pickView
@property(nonatomic,assign)BOOL isSinglePicker;
//单列pickView的数据数组
@property(nonatomic,strong)NSArray *singlePickerArray;
//最初的地区字典数组
@property(nonatomic,strong)NSArray * areaArray;
//省份数组
@property(nonatomic,strong)NSMutableArray * provinceArray;
//城市数组
@property(nonatomic,strong)NSMutableArray * citiesArray;
//每个城市的区域数组
@property(nonatomic,strong)NSMutableArray * citiesAreaArray;
//当前选中省份所对应的城市数组
@property(nonatomic,strong)NSMutableArray * cur_citiesArray;
//当前选中城市所对应的地区数组
@property(nonatomic,strong)NSMutableArray * cur_citiesAreaArray;
//当前选中的省份序号
@property(nonatomic,assign)NSInteger provinceIndex;
//当前选中的城市序号
@property(nonatomic,assign)NSInteger citiesIndex;
//装着确定取消按钮的view
@property(nonatomic,strong)UIView * headerBar;
//传入的date
@property(nonatomic,strong)NSDate * defaulDate;
@property(nonatomic,strong)UIPickerView * pickerView;
@property(nonatomic,strong)UIDatePicker * datePicker;

@end

@implementation ZCZPickView

-(instancetype)initForAreaPickView
{
    if (self = [super init]) {
        [self setupColorAndFont];
        [self setUpdataSource];
        [self setUpheaderBar];
        [self setUpPickView];
    }
    return self;
}

-(instancetype)initSinglePickerWithArray:(NSArray * )array
{
    if (self = [super init]) {
        self.isSinglePicker = YES;
        self.singlePickerArray = array;
        [self setupColorAndFont];
        [self setUpheaderBar];
        [self setUpPickView];
    }
    return self;
}

- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode {
    self=[super init];
    if (self) {
        self.isDatePicker = YES;
        [self setupColorAndFont];
        [self setUpheaderBar];
        self.defaulDate = defaulDate;
        self.datePicker = [[UIDatePicker alloc] init];
        //设置显示格式为中文。默认根据本地设置显示为中文还是其他语言
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.datePickerMode = datePickerMode;
        _datePicker.maximumDate = defaulDate;
        NSDate *minDate = [[NSDate alloc]initWithTimeInterval:-50 *365*24*3600 sinceDate:defaulDate];
        NSLog(@"minDate:%@",minDate);
        _datePicker.minimumDate = minDate;
        
        if (_defaulDate) {
            [self.datePicker setDate:_defaulDate animated:YES];
        }
        NSLog(@"dataPickerheight:%f",_datePicker.frame.size.height);
        _datePicker.frame=CGRectMake(0, 30  , 375, self.datePicker.frame.size.height);
        //更改datePicker字体颜色
        [_datePicker setValue:[self.singleColor.colorDic objectForKey:FONT_MAIN_COLOR] forKey:@"textColor"];
        [self addSubview:_datePicker];
    }
    return self;
}

#pragma mark - <懒加载>
-(NSMutableArray *)provinceArray
{
    if (_provinceArray==nil) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

-(NSMutableArray *)citiesArray
{
    if (_citiesArray==nil) {
        _citiesArray = [NSMutableArray array];
    }
    return _citiesArray;
}

-(NSMutableArray *)citiesAreaArray
{
    if (_citiesAreaArray==nil) {
        _citiesAreaArray = [NSMutableArray array];
    }
    return _citiesAreaArray;
}

-(NSMutableArray *)cur_citiesAreaArray
{
    if (_cur_citiesAreaArray==nil) {
        _cur_citiesAreaArray = [NSMutableArray array];
    }
    return _cur_citiesAreaArray;
}

-(NSMutableArray *)cur_citiesArray
{
    if (_cur_citiesArray==nil) {
        _cur_citiesArray = [NSMutableArray array];
    }
    return _cur_citiesArray;
}

#pragma mark - <创建子控件>
//设置singleColor与背景色
-(void)setupColorAndFont
{
    self.singleColor = [SingleColor sharedInstance];
    //背景颜色
    self.backgroundColor = [self.singleColor.colorDic objectForKey:BACK_CONTROL_COLOR];
}

//解析地区的字典数组
-(void)setUpdataSource
{
    //地名的字典数组
     self.areaArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    //第一个遍历 拿出省(包含直辖市)
    for (NSDictionary * dict in self.areaArray) {
        NSString * provinceName =  dict[@"state"];
        //省份,直辖市的名字
        [self.provinceArray addObject:provinceName];
        
        NSMutableArray * tempCityArr = [NSMutableArray array];
        NSMutableArray * tempCityAreaArr = [NSMutableArray array];
        NSArray * citiesArray = dict[@"cities"];
        //第二个遍历拿出省里的所有城市
        for (NSDictionary * cityDict in citiesArray) {
            NSString * cityName = cityDict[@"city"];
            [tempCityArr addObject:cityName];
            NSArray * areaNameArray = cityDict[@"areas"];
            [tempCityAreaArr addObject:areaNameArray];
        }
        [self.citiesArray addObject:tempCityArr];
        [self.citiesAreaArray addObject:tempCityAreaArr];
    }
    self.cur_citiesArray = self.citiesArray[0];
    self.cur_citiesAreaArray = self.citiesAreaArray[0][0];
}

-(void)setUpheaderBar
{
    self.headerBar = [[UIView alloc] init];
    self.headerBar.backgroundColor = [UIColor clearColor];
    [self addSubview:self.headerBar];
    [self.headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(30));
    }];

    //取消按钮
    UIButton * leftBtn = [self setButtonWithTitle:@"取消"];
    [leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerBar addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerBar.mas_left).offset(10);
        make.top.equalTo(_headerBar.mas_top).offset(4);
        make.bottom.equalTo(_headerBar.mas_bottom).offset(-4);
        make.width.equalTo(@(60));
    }];
  
    //确定按钮
    UIButton * rightBtn = [self setButtonWithTitle:@"确定"];
    [rightBtn addTarget:self action:@selector(doneClick)   forControlEvents:UIControlEventTouchUpInside];
    [self.headerBar addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headerBar.mas_right).offset(-10);
        make.top.equalTo(_headerBar.mas_top).offset(4);
        make.bottom.equalTo(_headerBar.mas_bottom).offset(-4);
        make.width.equalTo(@(60));
    }];
}

- (void)setUpPickView
{
    UIPickerView *pickView=[[UIPickerView alloc] init];
    _pickerView=pickView;
    pickView.backgroundColor=[UIColor clearColor];
    pickView.delegate=self;
    pickView.dataSource=self;
    [self addSubview:pickView];
//    NSLog(@"--pickView.frame.size.height--%f",pickView.frame.size.height);
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.headerBar.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [_pickerView setValue:[self.singleColor.colorDic objectForKey:FONT_MAIN_COLOR] forKey:@"textColor"];
}

//根据title返回按钮
-(UIButton *)setButtonWithTitle:(NSString *)titleStr
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:titleStr forState:UIControlStateNormal];
    
    //设置按钮的颜色
    UIColor *btnColor = [self.singleColor.colorDic objectForKey:FONT_MAIN_COLOR];
    [btn setTitleColor:btnColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:[[self.singleColor.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    btn.layer.cornerRadius = 7;
    [btn.titleLabel sizeToFit];
    return btn;
}

#pragma mark - <取消按钮点击与确认按钮点击>
- (void)cancelClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerBarCancelBtnClick)]) {
        [self.delegate headerBarCancelBtnClick];
    }
    [self removeFromSuperview];
}

- (void)doneClick
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(headerBarDoneBtnCilck:WithFinalString:)]) {
        if (self.isSinglePicker==YES) {
          NSInteger i = [self.pickerView selectedRowInComponent:0];
            NSString * str =self.singlePickerArray[i];
            [self.delegate headerBarDoneBtnCilck:self WithFinalString:str];
            [self removeFromSuperview];
            return;
        }
        NSString * str;
        if (self.isDatePicker==NO) {
        NSInteger lastNumber = [self.pickerView selectedRowInComponent:2];
        NSString * provinceName = self.provinceArray[self.provinceIndex];
        NSString * cityName = self.citiesArray[self.provinceIndex][self.citiesIndex];
        NSString * areaName = self.citiesAreaArray[self.provinceIndex][self.citiesIndex][lastNumber];
            str = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,areaName];
        }else{
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                str = [dateFormatter stringFromDate:_datePicker.date];
        }
        [self.delegate headerBarDoneBtnCilck:self WithFinalString:str];
    }
    [self removeFromSuperview];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    if (self.isSinglePicker==YES) {
        return 1;
    }else{
    return 3;
    }
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isSinglePicker==YES) {
        return self.singlePickerArray.count;
    }
    switch (component) {
        case 0:
            return self.provinceArray.count;
            break;
        case 1:
            return self.cur_citiesArray.count;
            break;
        case 2:
            return self.cur_citiesAreaArray.count;;
            break;
        default:
            return 0;
            break;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isSinglePicker==YES) {
        return self.singlePickerArray[row];
    }
    
    switch (component) {
        case 0:
            return self.provinceArray[row];
            break;
        case 1:
            return self.cur_citiesArray[row];
            break;
        case 2:
            return self.cur_citiesAreaArray[row];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.isSinglePicker==YES) {
        return;
    }
    switch (component) {
        case 0:
            self.provinceIndex = row;
            self.cur_citiesArray = self.citiesArray[row];
            self.cur_citiesAreaArray = self.citiesAreaArray[row][0];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
        case 1:
            self.citiesIndex = row;
            
            self.cur_citiesAreaArray = self.citiesAreaArray[self.provinceIndex][row];
            
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];            break;
        default:
            break;
    }
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [self.singleColor.colorDic objectForKey:LINECOLOR];
        }
    }
    UILabel *label = [UILabel new];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [self.singleColor.colorDic objectForKey:FONT_MAIN_COLOR];
    label.font = [UIFont systemFontOfSize:[[self.singleColor.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}
@end
