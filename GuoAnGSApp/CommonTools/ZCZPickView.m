//
//  ZCZPickView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/8.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "ZCZPickView.h"
#import <Masonry.h>
@interface ZCZPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSArray * areaArray;
@property(nonatomic,strong)NSMutableArray * provinceArray;
@property(nonatomic,strong)NSMutableArray * citiesArray;
@property(nonatomic,strong)NSMutableArray * citiesAreaArray;
@property(nonatomic,strong)NSMutableArray * cur_provinceArray;
@property(nonatomic,strong)NSMutableArray * cur_citiesArray;
@property(nonatomic,strong)NSMutableArray * cur_citiesAreaArray;
@property(nonatomic,assign)NSInteger provinceIndex;
@property(nonatomic,assign)NSInteger citiesIndex;
@property(nonatomic,strong)UIPickerView * pickerView;
@property(nonatomic,strong)UIView * headerBar;
@end


@implementation ZCZPickView

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
-(NSMutableArray *)cur_provinceArray
{
    if (_cur_provinceArray==nil) {
        _cur_provinceArray = [NSMutableArray array];
    }
    return _cur_provinceArray;
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
-(instancetype)initForAreaPickView
{
    if (self = [super init]) {
        [self setUpdataSource];
        [self setUpheaderBar];
        [self setUpPickView];
        
        
        
    }
    return self;
}

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


-(void)setUpheaderBar{
    
    self.headerBar = [[UIView alloc] init];
    [self addSubview:self.headerBar];
    [self.headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(30));
    }];
    //取消按钮
    self.leftBtn = [self setButtonWithTitle:@"取消"];
    [_leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerBar addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerBar.mas_left).offset(10);
        make.top.equalTo(_headerBar.mas_top).offset(4);
        make.bottom.equalTo(_headerBar.mas_bottom).offset(-4);
        make.width.equalTo(@(60));
    }];
    //确定按钮
    self.rightBtn = [self setButtonWithTitle:@"确定"];
    [_rightBtn addTarget:self action:@selector(doneClick)   forControlEvents:UIControlEventTouchUpInside];
    [self.headerBar addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headerBar.mas_right).offset(-10);
        make.top.equalTo(_headerBar.mas_top).offset(4);
        make.bottom.equalTo(_headerBar.mas_bottom).offset(-4);
        make.width.equalTo(@(60));
    }];
}

- (void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    _pickerView=pickView;
    pickView.backgroundColor=[UIColor clearColor];
    pickView.delegate=self;
    pickView.dataSource=self;
    [self addSubview:pickView];
    
    NSLog(@"--pickView.frame.size.height--%f",pickView.frame.size.height);
    
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.headerBar.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
-(UIButton *)setButtonWithTitle:(NSString *)titleStr {
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:titleStr forState:UIControlStateNormal];
    //设置按钮的颜色
//    UIColor *btnColor = [colorData.colorDic objectForKey:FONT_MAIN_COLOR];
    UIColor *btnColor  = [UIColor redColor];
    [_btn setTitleColor:btnColor forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    _btn.titleLabel.font = [UIFont systemFontOfSize:10];
    _btn.layer.cornerRadius = 7;
    [_btn.titleLabel sizeToFit];
    return _btn;
}

#pragma mark - 取消点击
- (void)cancelClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerBarCancelBtnClick)]) {
        [self.delegate headerBarCancelBtnClick];
    }
    [self removeFromSuperview];
}

- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - 确认点击
- (void)doneClick
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(headerBarDoneBtnCilck:WithFinalString:)]) {
        NSInteger lastNumber = [self.pickerView selectedRowInComponent:2];
        NSString * provinceName = self.provinceArray[self.provinceIndex];
        NSString * cityName = self.citiesArray[self.provinceIndex][self.citiesIndex];
        NSString * areaName = self.citiesAreaArray[self.provinceIndex][self.citiesIndex][lastNumber];
        NSString * str = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,areaName];
        [self.delegate headerBarDoneBtnCilck:self WithFinalString:str];
    }
    [self removeFromSuperview];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
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


@end
