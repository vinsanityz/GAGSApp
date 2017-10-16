//
//  FindVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/9/1.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "FindVC.h"
#import "PwconCell.h"
#import "ZHPickView.h"
#import "AddressInfoModel.h"

@interface FindVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZHPickViewDelegate>

@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) ZHPickView *selectUrlPV;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UITextField *mobileTextField;
@property(nonatomic,strong) UITextField *userNameTextField;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UITextField *configTextField;
@property(nonatomic,strong) UITextField *testTextField;

@property(nonatomic,strong) UIButton *testBtn;
@property(nonatomic,copy) NSString *vertifyNO;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) AddressInfoModel *modle;
@property(nonatomic,strong) NSMutableArray *nameArray;

@property (nonatomic, assign) CGRect tableViewFrame;

@end

@implementation FindVC

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(NSMutableArray *)nameArray{
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenSizeWidth, ScreenSizeHeigh-64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        self.tableViewFrame = _tableView.frame;
    }
    return _tableView;
}


-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, commonCellHigh)];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.userInteractionEnabled = YES;
        _addressLabel.textColor = HIGHLIGHTED_COLOR;
        _addressLabel.text = Tip_AreaText;
        UITapGestureRecognizer *addressSelect = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressSelectAction)];
        [_addressLabel addGestureRecognizer:addressSelect];
    }
    return _addressLabel;
}

-(UITextField *)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenSizeWidth - 10, commonCellHigh)];
        _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_PhoneWrite attributes:@{NSForegroundColorAttributeName:color}];
        _mobileTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        _mobileTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
        _mobileTextField.delegate = self;
    }
    return _mobileTextField;
}

-(UITextField *)userNameTextField{
    if (!_userNameTextField) {
        _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, ScreenSizeWidth - 10, commonCellHigh)];
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_ResetUserNameWrite attributes:@{NSForegroundColorAttributeName:color}];
        _userNameTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        _userNameTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
        _userNameTextField.delegate = self;
    }
    return _userNameTextField;
}

-(UITextField *)testTextField{
    if (!_testTextField) {
        _testTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenSizeWidth -30-self.testBtn.frame.size.width, commonCellHigh)];
        _testTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _testTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_VertifyWrite attributes:@{NSForegroundColorAttributeName:color}];
        _testTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        _testTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
        _testTextField.delegate = self;
        
    }
    return _testTextField;
}

-(UIButton *)testBtn{
    if (!_testBtn) {
        _testBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _testBtn.frame = CGRectMake(ScreenSizeWidth-120, 10, 110, 30);
        _testBtn.backgroundColor = HIGHLIGHTED_COLOR;
        [_testBtn addTarget:self action:@selector(findtestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _testBtn.layer.cornerRadius = 10;
        _testBtn.adjustsImageWhenHighlighted = YES;
        _testBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_testBtn setTitle:Tip_VsertyfyClick forState:UIControlStateNormal];
    }
    return _testBtn;
}

-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenSizeWidth - 10, commonCellHigh)];
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_ResetNewPassWordWrite attributes:@{NSForegroundColorAttributeName:color}];
        _passwordTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        _passwordTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
        
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

-(UITextField *)configTextField{
    if (!_configTextField) {
        _configTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenSizeWidth - 10, commonCellHigh)];
        _configTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _configTextField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:Tip_ResetConfirmPwdWrite attributes:@{NSForegroundColorAttributeName:color}];
        _configTextField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        _configTextField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
        _configTextField.delegate = self;
        _configTextField.secureTextEntry = YES;
    }
    return _configTextField;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleMessage = @"重置密码";
    self.showLeft = YES;
    [_backSuperView addSubview:self.tableView];
    [self.tableView registerClass:[PwconCell class] forCellReuseIdentifier:@"buttonCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"find"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findresignTextFieldAction)];
    [_backSuperView addGestureRecognizer:tap];
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HJSTKToastView addPopString:Tip_AreaUnSelect];
}


#pragma mark - <轻拍，移除pickerView和键盘>
-(void)findresignTextFieldAction{
    NSLog(@"轻拍手势移除");
    [self.view endEditing:YES];
    
    if (_selectUrlPV != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = self.tableViewFrame;

        }];
        [_selectUrlPV removeFromSuperview];
    }else{
        NSLog(@"pickerView不存在");
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    //视图即将消失时，移除pickerView
    if (_selectUrlPV != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = self.tableViewFrame;
        }];
        [_selectUrlPV removeFromSuperview];
    }else{
        NSLog(@"pickerView不存在");
    }
}

#pragma mark - <选择区域列表页>
-(void)addressSelectAction
{
    [self.view endEditing:YES];
    [self requestAddressInfoNetWorkingOfPwd];
}

#pragma mark - <选择地址列表页请求>
-(void)requestAddressInfoNetWorkingOfPwd
{
    [self showMBProgressHud];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",GetLoadPreUrl,GetAddressInfo];
    NSLog(@"urlOfAddress:%@",url);
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"所有地址信息：%@",responseObject);
        if (self.nameArray.count > 0) {
            [self.nameArray removeAllObjects];
        }
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
        }
        NSArray *array = responseObject;
        for (NSDictionary *dict in array) {
            self.modle = [AddressInfoModel itemAddressInfoWithDictionary:dict];
            [self.nameArray addObject:self.modle.cAdderss];
            [self.dataSource addObject:self.modle];
        }
        
        NSLog(@"%@,%ld",self.nameArray,(unsigned long)self.nameArray.count);
        NSLog(@"%@,%ld",self.dataSource,(unsigned long)self.dataSource.count);
        //创建pickerView
        if (self.selectUrlPV == nil) {
            self.selectUrlPV = [[ZHPickView alloc]initPickviewWithArray:self.nameArray isAreaPickerView:NO];
            _selectUrlPV.delegate = self;
            _selectUrlPV.frame = CGRectMake(0, ScreenSizeHeigh-PickerViewHeight, ScreenSizeWidth, PickerViewHeight);
        }
        
        [_selectUrlPV show];
        //向上偏移
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(self.tableViewFrame.origin.x, self.tableViewFrame.origin.y - PickerViewHeight, self.tableViewFrame.size.width, self.tableViewFrame.size.height);
        }];
        [self hideMBProgressHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self hideMBProgressHud];
        [HJSTKToastView addPopString:NETWRONG];//连接超时
    }];
}

#pragma mark - <ZHPickViewDelegate>

-(void)toolbarCancelBtnClick
{

    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = self.tableViewFrame;
    }];
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultStrin
{
    //回到原位
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = self.tableViewFrame;

    }];
    self.addressLabel.text = resultStrin;
    NSLog(@"resultStrin:%@",resultStrin);
    NSLog(@"数据源：%@,%ld",self.dataSource,(unsigned long)self.dataSource.count);
    for (int i = 0; i < self.dataSource.count; i++) {
        self.modle = self.dataSource[i];
        NSLog(@"%@--%i--%@",self.modle.cAdderss,i,resultStrin);
        if ([self.modle.cAdderss isEqualToString:resultStrin]) {
            NSLog(@"内部：%d,%@,%@,%@",i,self.modle.cAdderss,self.modle.ip,self.modle.port);
            //保存获取的url
            kPermanent_SET_OBJECT(self.modle.ip, KGetIP);
            kPermanent_SET_OBJECT(self.modle.port, KGetPort);
            NSLog(@"%@",kPermanent_GET_OBJECT(KGetIP));
            NSLog(@"%@",kPermanent_GET_OBJECT(KGetPort));
        }
    }
}

#pragma mark - <点击获取验证码Btn相应方法>
-(void)findtestBtnClick:(UIButton *)sender{
    NSLog(@"%@%@",kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort));
    NSLog(@"%@",self.addressLabel.text);
    
    if (kPermanent_GET_OBJECT(KGetIP) !=nil && kPermanent_GET_OBJECT(KGetPort) != nil &&(![self.addressLabel.text isEqualToString:Tip_AreaText])) {
        if (self.mobileTextField.text.length == 0) {
            [HJSTKToastView addPopString:Tip_PhoneUnWrite];
        }else if (![self isPureInt:self.mobileTextField.text]){
            [HJSTKToastView addPopString:Tip_PhoneWrong];
        }else if (self.userNameTextField.text.length == 0){
            [HJSTKToastView addPopString:Tip_UserNameUnWrite];
        }else if (![self isUserName:self.userNameTextField.text]){
            [HJSTKToastView addPopString:Tip_UserNameWrong];
        }else{
            
            //验证用户名和手机号一致性的网络请求
            [self requestConsistenceOfPhoneWithUser:self.mobileTextField.text userName:self.userNameTextField.text button:sender];
        }
        
    }else{
        [HJSTKToastView addPopString:Tip_AreaUnSelect];
    }
    
    
}


#pragma mark - <发送验证码方法>
-(void)vertifyAction:(UIButton *)sender
{
    __block int timeout = 30;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"重新发送验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [sender setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                sender.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



#pragma mark - <重置密码Btn响应方法>
-(void)revisePasswordAction
{
    if (kPermanent_GET_OBJECT(KGetIP) !=nil && kPermanent_GET_OBJECT(KGetPort) != nil &&(![self.addressLabel.text isEqualToString:Tip_AreaText])) {
        if (self.mobileTextField.text.length == 0) {
            [HJSTKToastView addPopString:Tip_PhoneUnWrite];
        }else if (![self isPureInt:self.mobileTextField.text]){
            [HJSTKToastView addPopString:Tip_PhoneWrong];
        }else if (self.userNameTextField.text.length == 0){
            [HJSTKToastView addPopString:Tip_UserNameUnWrite];
        }else if (![self isUserName:self.userNameTextField.text]){
            [HJSTKToastView addPopString:Tip_UserNameWrong];
        }else if (self.passwordTextField.text.length == 0){
            [HJSTKToastView addPopString:Tip_ResetNewPwdUnWrite];
        }else if (![self isPassword:self.passwordTextField.text]){
            [HJSTKToastView addPopString:Tip_ResetNewPwdWrong];
        }else if (self.configTextField.text.length == 0){
            [HJSTKToastView addPopString:Tip_PasswordConfirmUnWrite];
        }else if (![self isPassword:self.configTextField.text]){
            [HJSTKToastView addPopString:Tip_PassWordConfirWrong];
        }else if (![self.passwordTextField.text isEqualToString:self.configTextField.text]){
            [HJSTKToastView addPopString:Tip_AgreeMentOfPassword];
        }else if (self.testTextField.text.length == 0){
            [HJSTKToastView addPopString:Tip_VertifyWrite];
        }else{
            NSString *md5 = [self md5:self.passwordTextField.text];
            [self requestResetPasswordNetWorkingPhoneNo:self.mobileTextField.text passwd:md5 vertifyNo:self.testTextField.text appUserName:self.userNameTextField.text];
        }
    }else{
        [HJSTKToastView addPopString:Tip_AreaUnSelect];
 
    }
   
    
}



#pragma mark - <重置密码请求>
-(void)requestResetPasswordNetWorkingPhoneNo:(NSString *)phoneNo passwd:(NSString *)passwd vertifyNo:(NSString *)vertifyNo appUserName:(NSString *)appUserName
{
    [self showMBProgressHud];
    //手机号与用户名可二选一
    NSDictionary *param=  [NSDictionary dictionaryWithObjectsAndKeys:phoneNo,@"phoneNo",appUserName,@"appUserName",passwd,@"passwd",vertifyNo,@"verifyNo", nil];
    NSLog(@"重置密码参数：%@",param);
    [LYNetworkManager POST:GetFindPassword parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"忘记密码：%@",responseObject);
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        if ([self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            //重置密码成功，返回到选择注册登录界面
             [self.navigationController popToRootViewControllerAnimated:YES];
        }
        NSLog(@"找回密码返回信息:%@",self.commonReturnCode.returnMsg);
        [self hideMBProgressHud];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
        [self hideMBProgressHud];
    }];
 
}



#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    if (section == 0) {
        return 6;
    } else {
        return 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        UITableViewCell *headCell =[tableView dequeueReusableCellWithIdentifier:@"find" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
            {
                
                [headCell.contentView addSubview:self.addressLabel];
                break;
            }
            case 1:
            {
                
                [headCell.contentView addSubview:self.mobileTextField];
                break;
            }
            case 2:
            {
                
                [headCell.contentView addSubview:self.userNameTextField];
                break;
            }
            case 3:
            {
                [headCell.contentView addSubview:self.passwordTextField];
                break;
            }
            case 4:
            {
                [headCell.contentView addSubview:self.configTextField];
                break;
            }

            case 5:
            {
                [headCell.contentView addSubview:self.testBtn];
                
                [headCell.contentView addSubview:self.testTextField];
                break;
            }
           
            default:
                break;
        }
        headCell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return headCell;

        
    } else {
        PwconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        [cell.button setTitle:@"重置密码" forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(revisePasswordAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}


#pragma mark - <UITableViewDelegate>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return commonCellHigh;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_selectUrlPV != nil) {
        [_selectUrlPV removeFromSuperview];
    }else{
        NSLog(@"pickerView不存在");
    }

}


#pragma mark - <验证用户名与手机号码一致性网络请求>
-(void)requestConsistenceOfPhoneWithUser:(NSString *)phone userName:(NSString *)userName button:(UIButton *)sender
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phoneNo",userName,@"appUserName",nil];
    [LYNetworkManager POST:GetPhoneAndUser parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    /**
     *0成功 并已经发送验证码
     1手机号不存在
     2用户名不存在
     3用户名与手机号不匹配
     */
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject   ];
        if ([self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [HJSTKToastView addPopString:@"验证码发送成功"];
            //调用发送验证码
            [self vertifyAction:sender];
            
        }else{
            [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        }
        NSLog(@"%@",self.commonReturnCode.returnMsg);
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
