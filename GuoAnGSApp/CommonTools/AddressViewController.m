//
//  AddressViewController.m
//  CS_WeiTV
//
//  Created by Nina on 15/11/2.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "AddressViewController.h"

#import "AddressCell.h"
#import "ZHPickView.h"
#import "LoadReturnModel.h"

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) AreaObject *locate;
@property (nonatomic) NSInteger provinceIndex;
@property (strong, nonatomic) NSMutableArray *cityHis;
@property (nonatomic, copy) NSString *provinceName_ed;
@property (nonatomic, copy) NSString *cityName_ed;
@property (strong, nonatomic) NSArray *provinceArr;     //plist 数组
@property (strong, nonatomic) NSArray *citiesArray;     //城市 数组（1个元素）
@property (strong, nonatomic) NSArray *countiesArray;   //区县 数组（多个）
@property (nonatomic,strong) ZHPickView *stateCityPicker;
@property (nonatomic,strong) ZHPickView *countyPicker;
//完整地址信息的字符串分组{@"省份",@"城市",@"区县",@"街道",@"详细"}
@property (nonatomic,strong) NSArray *array;

@end


@implementation AddressViewController

-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, ScreenSizeHeigh) style:UITableViewStyleGrouped];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
    }
    return _tableView;
}


-(UITextField *)cityTextField {
    if (!_cityTextField) {
        self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 5, [UIScreen mainScreen].bounds.size.width - 120, 40)];
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _cityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择省市" attributes:@{NSForegroundColorAttributeName:color}];
        self.cityTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
        self.cityTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        if (self.array.count > 0) {
            _cityTextField.text = [NSString stringWithFormat:@"%@ %@",self.array[0],self.array[1]];
            
        }
        NSLog(@"self.cityTextField.text----%@",self.cityTextField.text);
        _cityTextField.userInteractionEnabled = NO;
    }
    return _cityTextField;
}


-(UITextField *)countyTextField {
    if (!_countyTextField) {
        self.countyTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 5, [UIScreen mainScreen].bounds.size.width - 120, 40)];
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _countyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择区县" attributes:@{NSForegroundColorAttributeName: color}];
        self.countyTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
        self.countyTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        if (self.array.count > 0) {
            self.countyTextField.text = self.array[2];
            
        }
        _countyTextField.userInteractionEnabled = NO;
    }
    return _countyTextField;
}


-(UITextField *)streetTextField {
    if (!_streetTextField) {
        self.streetTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 5, [UIScreen mainScreen].bounds.size.width - 120, 40)];
        _streetTextField.font = [UIFont systemFontOfSize:15];
        _streetTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _streetTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"街道信息" attributes:@{NSForegroundColorAttributeName:color}];
        self.streetTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
        self.streetTextField.delegate = self;

        if (self.array.count>0) {
            self.streetTextField.text = self.array[3];
        }
        
    }
    return _streetTextField;
}



-(UITextField *)detailTextField {
    if (!_detailTextField) {
        self.detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 5, [UIScreen mainScreen].bounds.size.width - 120, 40)];
        _detailTextField.font = [UIFont systemFontOfSize:15];
        _detailTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _detailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"详细地址信息" attributes:@{NSForegroundColorAttributeName:color}];
        self.detailTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
        _detailTextField.delegate = self;
        if (self.array.count > 0) {
            self.detailTextField.text = self.array.lastObject;
        }
        
    }
    return _detailTextField;
}


- (instancetype)init {
    if (self = [super init]) {
        //获取文件路径
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
        //将获取到的plist文件中的内容存放到数组中
        self.provinceArr = [[NSArray alloc] initWithContentsOfFile:path];
        self.pickedStateIndex=0;
        self.pickedCityIndex=0;
        NSMutableArray *tmpArray1=[[NSMutableArray alloc]init];
        NSMutableArray *tmpArray2=[[NSMutableArray alloc]init];
        NSMutableArray *tmpArray3=[[NSMutableArray alloc]init];
        NSMutableArray *tmpArray4=[[NSMutableArray alloc]init];
        
        for (NSDictionary * statesDict in self.provinceArr)
        {
            for (NSDictionary *citiesDict in [statesDict objectForKey:@"cities"]){
                [tmpArray2 addObject:[citiesDict objectForKey:@"city"]];
                [tmpArray4 addObject:[citiesDict objectForKey:@"areas"]];
            }
            [tmpArray1 addObject:[tmpArray2 copy]];
            [tmpArray3 addObject:[tmpArray4 copy]];
            [tmpArray2 removeAllObjects];
            [tmpArray4 removeAllObjects];
        }
        self.citiesArray = [tmpArray1 copy];
        self.countiesArray = [tmpArray3 copy];
        NSLog(@"%@",self.citiesArray);
    }
    return self;
}


- (AreaObject *)locate{
    if (!_locate) {
        _locate = [[AreaObject alloc]init];
    }
    return _locate;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [_backSuperView addSubview:self.tableView];
    [self.tableView registerClass:[AddressCell class] forCellReuseIdentifier:@"cell"];
    self.titleMessage = @"地址";
    [self setNavLeft_title];
    [self setNavRight_title];
    
    NSLog(@"--------------%@",self.cityStr);
    //将上个页面传过来的数据分割存放到数组中
    if (![self.cityStr isEqualToString:UnCompleted]) {
        self.array = [self.cityStr componentsSeparatedByString:@" "];
        NSLog(@"地址相关信息--%lu--%@",(unsigned long)self.array.count,self.array);
    }

    self.streetTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.detailTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [_backSuperView addGestureRecognizer:tap];
}


- (void)resignKeyboard
{
    [self.streetTextField resignFirstResponder];
    [self.detailTextField resignFirstResponder];
    
    if (self.stateCityPicker) {
        [self.stateCityPicker removeFromSuperview];
    }
    if (self.countyPicker) {
        [self.countyPicker removeFromSuperview];
    }
}

#pragma mark - <保存按钮响应方法>
//保存按钮对应的响应方法
-(void)saveRight {
    self.str = [NSString stringWithFormat:@"%@ %@ %@ %@",self.cityTextField.text,self.countyTextField.text,self.streetTextField.text,self.detailTextField.text];
    NSLog(@"strsss--%@",self.str);
    if ([self.identifier isEqualToString:Devise]) {
        
        if (![kPermanent_GET_OBJECT(KGetAddress) isEqualToString:self.str]) {
            [self requestDevisePersonInfoForPersonUserName:kPermanent_GET_OBJECT(KGetUserName) nickName:nil birthday:nil gender:nil address:self.str];
        }else{
            [HJSTKToastView addPopString:UnChange];
        }
    }else{
        NSLog(@"-----%@",self.str);
        if (self.addressBlock) {
            self.addressBlock(self.str);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/* 区县选择 */
-(ZHPickView *)stateCityPicker {
    
    if (!_stateCityPicker) {
        _stateCityPicker = [[ZHPickView alloc] initPickviewWithArray:self.citiesArray isAreaPickerView:YES];
        _stateCityPicker.frame = CGRectMake(0, ScreenSizeHeigh - 230, ScreenSizeWidth, 230);
        _stateCityPicker.delegate = self;
        _stateCityPicker.tag = 1200;
        _stateCityPicker.addressVC=self;
        NSMutableArray *tmpArr1=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in _provinceArr) {
            [tmpArr1 addObject:[dic objectForKey:@"state"]];
            
        }
        _stateCityPicker.statesArray=[tmpArr1 copy];
    }
    
    return _stateCityPicker;
}

/* 省市选择 */
-(ZHPickView *)countyPicker {
    
    self.pickedStateIndex=0;
    self.pickedCityIndex=0;
    
    if (!_countyPicker) {
        self.countyPicker = [[ZHPickView alloc] initPickviewWithArray:self.countiesArray[self.pickedStateIndex][self.pickedCityIndex] isAreaPickerView:YES];
        _countyPicker.frame = CGRectMake(0, ScreenSizeHeigh - 230, ScreenSizeWidth, 230);
        _countyPicker.delegate=self;
        _countyPicker.tag = 1300;
        _countyPicker.countiesArray=self.countiesArray;
        _countyPicker.addressVC=self;
        
        NSMutableArray *tmpArr1=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in _provinceArr) {
            [tmpArr1 addObject:[dic objectForKey:@"state"]];
        }
        _countyPicker.statesArray=[tmpArr1 copy];
    }
    return _countyPicker;
}


-(void)viewWillDisappear:(BOOL)animated {
    [_stateCityPicker removeFromSuperview];
    [_countyPicker removeFromSuperview];
}


#pragma mark - <UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return commonCellHigh;
}


#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Tip_AddressInfo.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *array = Tip_AddressInfo;
    
    cell.currentLabel.text = array[indexPath.row];
    cell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    cell.currentLabel.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
    cell.currentLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE]intValue]];
    if (indexPath.row == 0) {
        // 省市
        [cell.contentView addSubview:self.cityTextField];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrressShow)];
        [cell.contentView addGestureRecognizer:tap];
        
    } else if (indexPath.row == 1){
        // 区县
        [cell.contentView addSubview:self.countyTextField];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countyShow)];
        [cell.contentView addGestureRecognizer:tap];
        
    }else if (indexPath.row == 2) {
        // 街道
        [cell.contentView addSubview:self.streetTextField];
    } else {
        // 详细地址
        [cell.contentView addSubview:self.detailTextField];
    }
    return cell;
}


-(void)arrressShow {
    [self resignKeyboard];
    [_countyPicker removeFromSuperview];
    
    [self.stateCityPicker show];
}


-(void)countyShow{
    [self resignKeyboard];
    [_stateCityPicker removeFromSuperview];
    
    [self.countyPicker.pickerView reloadAllComponents];
    [self.countyPicker show];
}


#pragma mark - <ZHPickView Delegate Methods:>
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    // 代理模式应用;
    /* 添加注释 */
    switch (pickView.tag) {
        case 1200:
            self.cityTextField.text=resultString;
            NSLog(@"label text:%@",resultString);
            break;
        case 1300:
            self.countyTextField.text=resultString;
            NSLog(@"label text:%@",resultString);
            break;
    }
}


#pragma mark - <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
