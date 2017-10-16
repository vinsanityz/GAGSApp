//
//  RegVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/9/1.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "RegVC.h"

#import "FinishVC.h"
#import "ChooseAddressVC.h"

#define Tip_PhoneOcupy @"手机号已被占用"
@interface RegVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *phoneView;
@property(nonatomic,strong) UIView *userView;
@property(nonatomic,strong) UIView *originPwdView;
@property(nonatomic,strong) UIView *againPwdView;
@property(nonatomic,strong) UIView *vertifyView;
@property(nonatomic,strong) UIImageView *phoneImageView;
@property(nonatomic,strong) UIImageView *userNameImageView;
@property(nonatomic,strong) UITextField *mobileTextField;  //手机号
@property(nonatomic,strong) UITextField *userNameTextField;//用户名
@property(nonatomic,strong) UITextField *passwordTextField;//初始密码
@property(nonatomic,strong) UITextField *configTextField;  //确认密码
@property(nonatomic,strong) UITextField *testTextField;    //验证码
@property(nonatomic,strong) UIButton *testBtn;             //验证码Btn
@property(nonatomic,strong) UILabel *regBtn;               //立即注册
@property(nonatomic,strong) NSString *phoneFlag;           //手机占用标识
@property(nonatomic,strong) NSString *phoneMsg;
@property(nonatomic,strong) NSNumber *userNameCode;        //用户名验证返回值
@property(nonatomic,strong) NSNumber *phoneCode;           //手机号验证返回值

@end


@implementation RegVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleMessage = @"新用户注册";
    self.showLeft = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createRegVCUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignRegTextFieldAction)];
    [_backSuperView addGestureRecognizer:tap];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - <配置UI界面>
-(void)createRegVCUI
{
    //请输入手机号的View
    self.phoneView = [[UIView alloc]init];
    _phoneView.backgroundColor = cellColor;
    [_backSuperView addSubview:self.phoneView];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(commonCellHigh));
        make.top.equalTo(self.view.mas_top).offset(94);
    }];
    //手机号码输入正确的图标
    self.phoneImageView = [[UIImageView alloc]init];
    _phoneImageView.hidden = YES;
    [self.phoneView addSubview:self.phoneImageView];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(30));
        make.top.equalTo(self.phoneView.mas_top).offset(10);
        make.bottom.equalTo(self.phoneView.mas_bottom).offset(-10);
        make.right.equalTo(self.phoneView.mas_right).offset(-10);
    }];
    //textField
    self.mobileTextField = [[UITextField alloc]init];
    _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileTextField.tag = 3100;
    _mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_PhoneWrite attributes:@{NSForegroundColorAttributeName:secColor}];
    _mobileTextField.textColor = mainColor;
    _mobileTextField.font = [UIFont systemFontOfSize:normal];
    _mobileTextField.delegate = self;
    [self.phoneView addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneView.mas_left).offset(10);
        make.right.equalTo(self.phoneImageView.mas_left).offset(-10);
        make.top.equalTo(self.phoneView.mas_top);
        make.bottom.equalTo(self.phoneView.mas_bottom);
    }];
    
    //用户名View
    self.userView = [[UIView alloc]init];
    _userView.backgroundColor = cellColor;
    [_backSuperView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(commonCellHigh));
        make.top.equalTo(self.phoneView.mas_bottom).offset(1);
    }];
    //用户名输入成功时的图片
    self.userNameImageView = [[UIImageView alloc]init];
    _userNameImageView.hidden = YES;
    [self.userView addSubview:self.userNameImageView];
    [self.userNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(30));
        make.top.equalTo(self.userView.mas_top).offset(10);
        make.bottom.equalTo(self.userView.mas_bottom).offset(-10);
        make.right.equalTo(self.userView.mas_right).offset(-10);
    }];
    //用户名textField
    self.userNameTextField = [[UITextField alloc]init];
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.tag = 3300;
    _userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_UserNameWrite attributes:@{NSForegroundColorAttributeName:secColor}];
    _userNameTextField.textColor = mainColor;
    _userNameTextField.font = [UIFont systemFontOfSize:normal];
    _userNameTextField.delegate = self;
    [self.userView addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userView.mas_left).offset(10);
        make.right.equalTo(self.userNameImageView.mas_left).offset(-10);
        make.top.equalTo(self.userView.mas_top);
        make.bottom.equalTo(self.userView.mas_bottom);
    }];
    
    //初始密码
    self.originPwdView = [[UIView alloc]init];
    _originPwdView.backgroundColor = cellColor;
    [_backSuperView addSubview:self.originPwdView];
    [self.originPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(commonCellHigh));
        make.top.equalTo(self.userView.mas_bottom).offset(1);
    }];
    
    self.passwordTextField = [[UITextField alloc]init];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_PassWordWriteOrigin attributes:@{NSForegroundColorAttributeName:secColor}];
    _passwordTextField.textColor = mainColor;
    _passwordTextField.font = [UIFont systemFontOfSize:normal];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self.originPwdView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.originPwdView.mas_left).offset(10);
        make.right.equalTo(self.originPwdView.mas_right);
        make.top.equalTo(self.originPwdView.mas_top);
        make.bottom.equalTo(self.originPwdView.mas_bottom);
    }];
    
    //再次输入密码
    self.againPwdView = [[UIView alloc]init];
    _againPwdView.backgroundColor = cellColor;
    [_backSuperView addSubview:self.againPwdView];
    [self.againPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(commonCellHigh));
        make.top.equalTo(self.originPwdView.mas_bottom).offset(1);
    }];
    
    self.configTextField = [[UITextField alloc]init];
    _configTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _configTextField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:Tip_PassWordWriteConfirm attributes:@{NSForegroundColorAttributeName:secColor}];
    _configTextField.textColor =mainColor;
    _configTextField.font = [UIFont systemFontOfSize:normal];
    _configTextField.delegate = self;
    _configTextField.secureTextEntry = YES;
    [_backSuperView addSubview:self.configTextField];
    [self.configTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.againPwdView.mas_left).offset(10);
        make.right.equalTo(self.againPwdView.mas_right);
        make.top.equalTo(self.againPwdView.mas_top);
        make.bottom.equalTo(self.againPwdView.mas_bottom);
    }];
    
    //验证码
    self.vertifyView = [[UIView alloc]init];
    _vertifyView.backgroundColor = cellColor;
    [_backSuperView addSubview:self.vertifyView];
    [self.vertifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(commonCellHigh));
        make.top.equalTo(self.againPwdView.mas_bottom).offset(1);

    }];
    //获取验证码按钮
    self.testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _testBtn.backgroundColor = HIGHLIGHTED_COLOR;
    _testBtn.layer.cornerRadius = 10;
    _testBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_testBtn setTitle:Tip_VsertyfyClick forState:UIControlStateNormal];
    [_testBtn addTarget:self action:@selector(vertifyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vertifyView addSubview:self.testBtn];
    [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vertifyView.mas_right).offset(-10);
        make.top.equalTo(self.vertifyView.mas_top).offset(10);
        make.bottom.equalTo(self.vertifyView.mas_bottom).offset(-10);
        make.width.equalTo(@(120));
    }];
    
    self.testTextField = [[UITextField alloc]init];
    _testTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _testTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_VertifyWrite attributes:@{NSForegroundColorAttributeName:secColor}];
    _testTextField.textColor = mainColor;
    _testTextField.font = [UIFont systemFontOfSize:normal];
    _testTextField.delegate = self;
    [_backSuperView addSubview:self.testTextField];
    [self.testTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vertifyView.mas_left).offset(10);
        make.right.equalTo(self.testBtn.mas_left).offset(-10);
        make.top.equalTo(self.vertifyView.mas_top);
        make.bottom.equalTo(self.vertifyView.mas_bottom);
    }];
    
    //立即注册
    self.regBtn = [[UILabel alloc]init];
    self.regBtn.userInteractionEnabled = YES;
    self.regBtn.textAlignment = NSTextAlignmentCenter;
    self.regBtn.textColor=WHTIE_NORMAL;
    self.regBtn.text = @"立即注册";
    self.regBtn.font = FontSize(normal);
    self.regBtn.backgroundColor = HIGHLIGHTED_COLOR;
    UITapGestureRecognizer *regTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(regAction)];
    [self.regBtn addGestureRecognizer:regTap];
   [_backSuperView addSubview:self.regBtn];
    [self.regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(commonCellHigh));
        make.top.equalTo(self.vertifyView.mas_bottom).offset(30);
    }];
}


#pragma mark - <点击获取验证码>
- (void)vertifyBtnAction:(UIButton *)sender {
    NSLog(@"点击获取验证码");
    if (self.phoneCode != NULL &&[self.phoneCode isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [HJSTKToastView addPopString:self.phoneMsg];
    }
    else if (self.mobileTextField.text.length == 0) {
        [HJSTKToastView addPopString:Tip_PhoneUnWrite];
    }else if (![self isPureInt:self.mobileTextField.text]){
        [HJSTKToastView addPopString:Tip_PhoneWrong];
    }else{
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
        
        [self requestVertifyNetWorksing:self.mobileTextField.text];
    }
}



#pragma mark - <轻拍收起键盘>
-(void)resignRegTextFieldAction
{
    [self.view endEditing:YES];
}


#pragma mark - <点击进行注册>
- (void)regAction
{
//    FinishVC *finsh = [[FinishVC alloc] init];
//    finsh.userNameStr = self.userNameTextField.text;
//    finsh.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:finsh animated:YES];
//    return;
    
    if (self.mobileTextField.text.length == 0) {
        [HJSTKToastView addPopString:Tip_PhoneUnWrite];
    }else if (![self isPureInt:self.mobileTextField.text]){
        [HJSTKToastView addPopString:Tip_PhoneWrong];
    }else if ([self.phoneCode isEqualToNumber:[NSNumber numberWithInt:1]]){
        [HJSTKToastView addPopString:Tip_PhoneOcupy];
    }else if (self.userNameTextField.text.length == 0){
        [HJSTKToastView addPopString:Tip_UserNameUnWrite];
    }else if (![self isUserName:self.userNameTextField.text]){
        [HJSTKToastView addPopString:Tip_UserNameWrong];
    }else if ([self.userNameCode isEqualToNumber:[NSNumber numberWithInt:1]]){
        [HJSTKToastView addPopString:Tip_UserNameOcupy];
    }else if (self.passwordTextField.text.length == 0){
        [HJSTKToastView addPopString:Tip_PasswordOriginUnWrite];
    }else if ((![self isPassword:self.passwordTextField.text])){
        [HJSTKToastView addPopString:Tip_PassWordOriginWrong];
    }else if (self.configTextField.text.length == 0){
        [HJSTKToastView addPopString:Tip_PasswordConfirmUnWrite];
    }else if ((![self isPassword:self.configTextField.text])){
        [HJSTKToastView addPopString:Tip_PassWordConfirWrong];
    }else if (![self.passwordTextField.text isEqualToString:self.configTextField.text]){
        [HJSTKToastView addPopString:Tip_AgreeMentOfPassword];
    }else if (self.testTextField.text.length == 0){
        [HJSTKToastView addPopString:Tip_VertifyWrite];
    }else{
        NSString *md5 = [self md5:self.configTextField.text];
        [self requestRegNetWorking:self.mobileTextField.text passwd:md5 vertifyNo:self.testTextField.text caddress:self.CAddrss userName:self.userNameTextField.text];
    }
}


#pragma mark - <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 3100) {
        self.phoneImageView.hidden = YES;
    }
    if (textField.tag == 3300 ) {
        self.userNameImageView.hidden = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
     if ( self.navigationController.topViewController ==self) {
    if (textField.tag == 3100 && textField.editing == NO) {
        NSLog(@"手机号测试:%@",textField.text);
       
            
        if (textField.text.length == 0) {
            [HJSTKToastView addPopString:Tip_PhoneUnWrite];
        }else{
            if ([self isPureInt:textField.text] ) {
                
                [self requestTestPhoneNoNetWorking:self.mobileTextField.text];
            }else{
                [HJSTKToastView addPopString:Tip_PhoneWrong];
          }
       }
    }
    else if(textField.tag == 3300 && textField.editing == NO){
        NSLog(@"用户名测试:%@",textField.text);
        if (textField.text.length == 0) {
            [HJSTKToastView addPopString:Tip_UserNameUnWrite];
        }else{
            if ( [self isUserName:textField.text]) {
                [self requestTestUserNameNetWorking:self.userNameTextField.text];
            }else{
                [HJSTKToastView addPopString:Tip_UserNameWrong];
        }
      }
    }
  }
}


#pragma mark - 测试用户是否被占用网络请求 -
-(void)requestTestUserNameNetWorking:(NSString *)userName
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"appUserName", nil];
    [LYNetworkManager POST:GetTestUserName parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"user:%@",responseObject);
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        self.userNameImageView.hidden = NO;
        [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        
        if (![self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            self.userNameImageView.image = ImageNamed(Image_Wrong);
        }else{
            self.userNameImageView.image = ImageNamed(Image_Right);
        }
        self.userNameCode = self.commonReturnCode.returnCode;
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 测试手机号是否被占用网络请求
-(void)requestTestPhoneNoNetWorking:(NSString *)phoneNo
{
    NSLog(@"phoneNo:%@",phoneNo);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phoneNo,@"phoneNo", nil];
    [LYNetworkManager POST:GetTestPhoneNo parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject)
     {
        NSLog(@"phoneno:%@",responseObject);
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        
        NSLog(@"手机内容返回信息:%@",self.commonReturnCode.returnMsg);
        self.phoneCode = self.commonReturnCode.returnCode;
        self.phoneMsg = self.commonReturnCode.returnMsg;
      
        self.phoneImageView.hidden = NO;
        [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        if (![self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]){
            self.phoneImageView.image = ImageNamed(Image_Wrong);
        }else{
            self.phoneImageView.image = ImageNamed(Image_Right);
        }
        self.phoneCode = self.commonReturnCode.returnCode;
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 发送短信验证码网络请求
//注册时，只能通过手机号发送验证码
-(void)requestVertifyNetWorksing:(NSString *)phoneNo
{
    //注册时的参数只有手机号
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phoneNo,@"phoneNo", nil];
      NSLog(@"%@",param);
    [LYNetworkManager POST:GetVertify parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"vertify:%@\n%@",responseObject,self.commonReturnCode.returnMsg);
        
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        if ([self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [HJSTKToastView addPopString:Tip_VertifySendSuccess];
        }else{
            [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - 注册跳转网络请求 -
-(void)requestRegNetWorking:(NSString *)phoneNo passwd:(NSString *)passwd vertifyNo:(NSString *)vertifyNo caddress:(NSString *)address userName:(NSString *)userName
{
    [self showMBProgressHud];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:phoneNo,@"phoneNo",passwd,@"passwd",vertifyNo,@"verifyNo",address,@"cAddress" ,userName,@"appUserName",nil];
    NSLog(@"regParam:%@",param);
    [LYNetworkManager POST:GetRegHttp parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        //若注册成功，则跳转到完善信息界面
        if ([self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            FinishVC *finsh = [[FinishVC alloc] init];
            finsh.userNameStr = self.userNameTextField.text;
            finsh.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:finsh animated:YES];
        }
        [self hideMBProgressHud];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideMBProgressHud];
        
    }];
}

@end
