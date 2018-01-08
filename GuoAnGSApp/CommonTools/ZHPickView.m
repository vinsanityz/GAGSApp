//
//  ZHPickView.m
//  ZHpickView
//
//  Created by liudianling on 15-11-12.
//  Copyright (c) 2015年 wy. All rights reserved.
//
#define ZHToobarHeight 30
#import "ZHPickView.h"
#import "AddressViewController.h"

@interface ZHPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString *_dataStr;
}

@property(nonatomic,copy) NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIView *headerBar;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;

/* 原始值(用于取消操作)  */
@property(nonatomic,strong)NSString *stateName_Old;
@property(nonatomic,strong)NSString *cityName_Old;
/* 更新值(用于确定操作)  */
@property(nonatomic,strong)NSString *stateName_New;
@property(nonatomic,strong)NSString *cityName_New;

@property(nonatomic,assign)Boolean isAreaPickerView;


//new
@property (nonatomic, strong) NSArray *dataArray_new;

@end

@implementation ZHPickView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{
    
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        colorData = [SingleColor sharedInstance];
        [self setUpheaderBar];
        
        self.backgroundColor = [colorData.colorDic objectForKey:BACK_CONTROL_COLOR];
    }
    return self;
}


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isAreaPickerView:(BOOL) b{
    
    // 生日选择器数据源数组初始化：
    self=[super init];
    if (self) {
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        _isAreaPickerView=b;
        
        // 设置数据源：
        [self setUpOriginalDataModel];
        [self setUpPickView];
    }
    return self;
}

- (instancetype)initPickerViewWithDataArray:(NSArray *)dataArray key:(id)key {
    self = [super init];
    if (self) {
        self.dataArray_new = dataArray;
        [self setUpPickView];
    }
    return self;
}

- (NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    
    return array;
}



- (instancetype)initPickviewWithArray:(NSArray *)array isAreaPickerView:(BOOL) b{
    
    // 地区选择器数据源数组初始化：
    self= [super init];
    if (self) {
        self.plistArray=array;
        _isAreaPickerView=b;
        // 设置初始数据源：
        [self setUpOriginalDataModel];
        [self setUpPickView];
    }
    return self;
}


- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode {
    self=[super init];
    if (self) {
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
        _datePicker.frame=CGRectMake(0, ZHToobarHeight, ScreenSizeWidth, _datePicker.frame.size.height);
        //更改datePicker字体颜色
        [_datePicker setValue:[colorData.colorDic objectForKey:FONT_MAIN_COLOR] forKey:@"textColor"];
        [self addSubview:_datePicker];
    }
    return self;
}



- (void)setAreaArrayClass:(NSArray *)array{
    
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelString=NO;
            _isLevelArray=YES;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
        }
    }
}

- (void)setArrayClass:(NSArray *)array{
    
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            //将字典中所有键值赋值给可变数组_dickeyArray
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}


//创建pickView的frame
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


-(void)setUpheaderBar{
    
    self.headerBar = [[UIView alloc] init];
    [self addSubview:self.headerBar];
    [self.headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(ZHToobarHeight));
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

-(UIButton *)setButtonWithTitle:(NSString *)titleStr {
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:titleStr forState:UIControlStateNormal];
    //设置按钮的颜色
    UIColor *btnColor = [colorData.colorDic objectForKey:FONT_MAIN_COLOR];
    [_btn setTitleColor:btnColor forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    _btn.titleLabel.font = [UIFont systemFontOfSize:[[colorData.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    _btn.layer.cornerRadius = 7;
    [_btn.titleLabel sizeToFit];
    return _btn;
}


#pragma mark - 设置初始数据源:setArrayClass
- (void)setUpOriginalDataModel
{
    if (!_isAreaPickerView) {
        [self setArrayClass:_plistArray];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"stateIndex"];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"cityIndex"];
        
        [self setAreaArrayClass:_plistArray];
        
        // － － － picker view 初始数据源配置 － － －
        if (_isLevelString) {
            self.oldCountyIndex=0;
            self.newCountyIndex=0;
        }else if (_isLevelArray)
        {
            self.oldCityIndex=0;
            self.cityName_Old=@"北京";
            self.oldStateIndex=0;
            self.stateName_Old=@"北京";
            self.newCityIndex=0;
            self.cityName_New=@"北京";
            self.newStateIndex=0;
            self.stateName_New=@"北京";
        }
    }
}

#pragma mark < PickerView DataSource >
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
   // return 1;
    
    NSInteger component=0;
    
    switch (_isAreaPickerView) {
        case YES:
        {
            NSLog(@"is area picker view");
            // 地区选择器数据源：
            if (_isLevelArray) {
                component=2;
            }else if (_isLevelString){
                component=1;
            }
        }
            break;
            
        case NO:
        {
            // 生日选择器数据源：
            NSLog(@"is not area picker view");
            if (_isLevelArray) {
                component=_plistArray.count;
            } else if (_isLevelString){
                component=1;
            }else if(_isLevelDic){
                component=[_levelTwoDic allKeys].count * 2;//???
            }
        }
            break;
    }
    
    return component;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //return self.dataArray_new.count;
    /* 添加注释 */
    switch (_isAreaPickerView) {
        case YES:
        {
            // 地区选择器数据源：
            NSInteger count = 0;
            if (_isLevelArray) {
                switch (component) {
                    case 0:
                        count=_statesArray.count;
                        break;
                    case 1:
                        count=[[_plistArray objectAtIndex:[pickerView selectedRowInComponent:0]] count];
                        break;
                }
            }else if (_isLevelString){
                
                NSNumber *stateIndex=[[NSUserDefaults standardUserDefaults] objectForKey:@"stateIndex"];
                _newStateIndex=stateIndex.integerValue;
                NSNumber *cityIndex=[[NSUserDefaults standardUserDefaults] objectForKey:@"cityIndex"];
                _newCityIndex=cityIndex.integerValue;
                NSLog(@"%zd %zd",(long)_newStateIndex,_newCityIndex);
                
                _plistArray=_countiesArray[self.newStateIndex][self.newCityIndex];
                count=_plistArray.count;
            }
            return count;
        }
            break;
            
        case NO:
        {
            // 生日选择器数据源：
            NSLog(@"number of birthday picker view rows:");
            NSLog(@"picker view tag:%li",(long)self.tag);
            NSArray *rowArray=[[NSArray alloc] init];
            if (_isLevelArray) {
                rowArray=_plistArray[component];
            }else if (_isLevelString){
                rowArray=_plistArray;
            }else if (_isLevelDic){
                NSInteger pIndex = [pickerView selectedRowInComponent:0];
                NSDictionary *dic=_plistArray[pIndex];
                for (id dicValue in [dic allValues]) {
                    if ([dicValue isKindOfClass:[NSArray class]]) {
                        if (component%2==1) {
                            rowArray=dicValue;
                        }else{
                            rowArray=_plistArray;
                        }
                    }
                }
            }
            return rowArray.count;
        }
            break;
    }
    
    return 0;
}

#pragma mark < PickerView Delegate >

//每列返回的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 90;
}

//每行返回的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [colorData.colorDic objectForKey:LINECOLOR];
        }
    }

    UILabel *label = [UILabel new];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [colorData.colorDic objectForKey:FONT_MAIN_COLOR];
    label.font = [UIFont systemFontOfSize:[[colorData.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    NSString *rowTitle=nil;
    
    //rowTitle = self.dataArray_new[row];
    
   // return rowTitle;

    /* 添加注释 */
    switch (_isAreaPickerView) {
        case YES:
        {
            // 地区选择器数据源：
            if (_isLevelArray) {
                switch (component) {
                    case 0:
                    {
                        rowTitle=_statesArray[row];
                    }
                        break;
                    case 1:
                    {
                        NSInteger stateRow=[pickerView selectedRowInComponent:0];
                        NSLog(@"%li",(long)stateRow);
                        rowTitle=_plistArray[stateRow][row];
                    }
                        break;
                }
                
            }else if (_isLevelString){
                
                NSNumber *stateIndex=[[NSUserDefaults standardUserDefaults] objectForKey:@"stateIndex"];
                _newStateIndex = stateIndex.integerValue;
                NSNumber *cityIndex=[[NSUserDefaults standardUserDefaults] objectForKey:@"cityIndex"];
                _newCityIndex= cityIndex.integerValue;
                
                NSLog(@"selected 区：%zd %zd",(long)self.oldStateIndex,self.oldCityIndex);
                NSLog(@"select 区：%zd %zd",(long)self.newStateIndex,self.newCityIndex);
                _plistArray=_countiesArray[_newStateIndex][_newCityIndex];
                
                // safety check:
                if (_plistArray.count<=row) {
                    rowTitle=nil;
                }else{
                    rowTitle=_plistArray[row];
                }
                
            }
        }
            break;
            
        case NO:
        {
            // 生日选择器数据源：
            NSLog(@"birthday picker view row title");
            if (_isLevelArray) {
                rowTitle=_plistArray[component][row];
            }else if (_isLevelString){
                rowTitle=_plistArray[row];
            }else if (_isLevelDic){
                NSInteger pIndex = [pickerView selectedRowInComponent:0];
                NSDictionary *dic=_plistArray[pIndex];
                if(component%2==0)
                {
                    rowTitle=_dicKeyArray[row][component];
                }
                for (id aa in [dic allValues]) {
                    if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                        NSArray *bb=aa;
                        if (bb.count>row) {
                            rowTitle=aa[row];
                        }
                        
                    }
                }
            }
        }
            break;
    }
    
    return rowTitle;
}

//获取选中的文字
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    /* 添加注释 */
    switch (_isAreaPickerView)
    {
        case YES:
        {
            if (_isLevelString) {
                
                _oldCountyIndex=_newCountyIndex;
                _newCountyIndex=row;
                
                // safety check:
                if (_plistArray.count<=row) {
                    _resultString=nil;
                }else{
                    _resultString=_plistArray[row];
                }
                
            }else if (_isLevelArray){
                
                _cityName_Old=_cityName_New;
                _oldCityIndex=_newCityIndex;
                
                switch (component)
                {
                    case 0:
                    {
                        [pickerView reloadComponent:1];
                        [pickerView selectRow:0 inComponent:1 animated:YES];
                        
                        _stateName_Old=_stateName_New;
                        _oldStateIndex=_newStateIndex;
                        
                        _newStateIndex=row;
                        _stateName_New=_statesArray[row];
                        
                        _cityName_New=_plistArray[row][0];
                        _newCityIndex=0;
                        
                        NSLog(@"selected 省：%zd %zd",(long)self.oldStateIndex,(long)self.oldCityIndex);
                        NSLog(@"select 省：%zd %zd",(long)self.newStateIndex,self.newCityIndex);
                        
                    }
                        break;
                    case 1:
                    {
                        NSLog(@"selected 市：%zd %zd",(long)self.oldStateIndex,self.oldCityIndex);
                        NSLog(@"select 市：%zd %zd",(long)self.newStateIndex,self.newCityIndex);
                        
                        _newCityIndex=row;
                        _cityName_New=_plistArray[_newStateIndex][_newCityIndex];
                    }
                        break;
                }
                
                //拼凑省市字符串：
                NSLog(@"%@ ; %@",self.stateName_Old,self.cityName_Old);
                NSLog(@"%@ ; %@",self.stateName_New,self.cityName_New);
                _resultString=[NSString stringWithFormat:@"%@ ; %@",_stateName_New,_cityName_New];
                
                //将区县字段置空；
                _addressVC.countyTextField.text=@"";
            }
            break;
            
        case NO:
            {
                if (_isLevelDic&&component%2==0) {
                    [pickerView reloadComponent:1];
                    [pickerView selectRow:0 inComponent:1 animated:YES];
                }
                
                if (_isLevelString) {
                    _resultString=_plistArray[row];
                    
                }else if (_isLevelArray){
                    
                    _resultString=@"";
                    
                    for (int i=0; i<_plistArray.count;i++) {
                        
                        NSLog(@"column:%d row:%ld",i,(long)[pickerView selectedRowInComponent:i]);
                        
                        NSInteger cIndex = [pickerView selectedRowInComponent:i];
                        _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
                    }
                }else if (_isLevelDic){
                    if (component==0) {
                        _state =_dicKeyArray[row][0];
                    }else{
                        NSInteger cIndex = [pickerView selectedRowInComponent:0];
                        NSDictionary *dicValueDic=_plistArray[cIndex];
                        NSArray *dicValueArray=[dicValueDic allValues][0];
                        if (dicValueArray.count>row) {
                            _city =dicValueArray[row];
                        }
                    }
                }
                
                NSLog(@"- - > %@",_resultString);
            }
            break;
        }
    }
}


#pragma mark - 取消点击
- (void)cancelClick
{
    /*
    NSLog(@"%li %li %li",self.oldStateIndex,self.oldCityIndex,self.oldCountyIndex);
    NSLog(@"%li %li %li",self.newStateIndex,self.newCityIndex,self.newCountyIndex);
    NSLog(@"%@ ; %@",self.stateName_Old,self.cityName_Old);
    NSLog(@"%@ ; %@",self.stateName_New,self.cityName_New);
    
    if (_isAreaPickerView)
    {
        if (_isLevelArray)
        {
            [self.pickerView selectRow:_oldStateIndex inComponent:0 animated:YES];
            [self.pickerView selectRow:_oldCityIndex inComponent:1 animated:YES];
            
        }else if (_isLevelString)
        {
            [self.pickerView selectRow:_oldCountyIndex inComponent:0 animated:YES];
        }
    }
     */
    
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
    if (_pickerView) {
        
        /* 添加注释 */
        switch (_isAreaPickerView)
        {
            case YES:
            {
                if (_isLevelString) {
                    
                    _resultString=_countiesArray[_newStateIndex][_newCityIndex][[self.pickerView selectedRowInComponent:0]];
                    
                    
                }else if (_isLevelArray){
                    
                    _resultString=[NSString stringWithFormat:@"%@ %@",_statesArray[_newStateIndex],_plistArray[_newStateIndex][_newCityIndex]];
                }
                
                NSLog(@"result county string:%@",_resultString);
                NSLog(@"%li %li",(long)_newStateIndex,(long)_newCityIndex);
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:_newStateIndex] forKey:@"stateIndex"];
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:_newCityIndex] forKey:@"cityIndex"];
            }
                break;
                
            case NO:
            {
                if (_resultString) {
                    NSLog(@"%@",_resultString);
                }else{
                    if (_isLevelString) {
                        _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
                    }else if (_isLevelArray){
                        _resultString=@"";
                        for (int i=0; i<_plistArray.count;i++) {
                            _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                        }
                    }else if (_isLevelDic){
                        
                        if (_state==nil) {
                            _state =_dicKeyArray[0][0];
                            NSDictionary *dicValueDic=_plistArray[0];
                            _city=[dicValueDic allValues][0][0];
                        }
                        if (_city==nil){
                            NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                            NSDictionary *dicValueDic=_plistArray[cIndex];
                            _city=[dicValueDic allValues][0][0];
                            
                        }
                        _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
                    }
                }
            }
                break;
        }
    }else if (_datePicker) {
#pragma mark - <设置日期选择器的格式>
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentStr = [dateFormatter stringFromDate:_datePicker.date];
        _resultString=[NSString stringWithFormat:@"%@",currentStr];
        NSLog(@"日期选择器：%@",_resultString);
    }
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:_resultString];
    }
    
    [self removeFromSuperview];
}



@end

