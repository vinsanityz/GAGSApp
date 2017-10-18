//
//  LoadOnVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/8/31.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "LoadOnVC.h"

//#import "FindVC.h"  //忘记密码
//#import "JPUSHService.h"

#import "MyTabbarViewController.h"
#import <UMSocialCore/UMSocialCore.h>
//#import "ChooseAddressVC.h"
#import "QRScanViewController.h"

@interface LoadOnVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIImageView *accountImage;
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pwdImage;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdLable;
@property (weak, nonatomic) IBOutlet UILabel *loadBtn;
@property (weak, nonatomic) IBOutlet UILabel *forgetButton;

@end


@implementation LoadOnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleMessage = @"登录";
    self.showLeft = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configLoadVCUI];
    //轻点view取消所有编辑
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignLoadOnTextFieldAction)];
    [self.view addGestureRecognizer:tap];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - <重写子类返回>
//注：重写子类返回相应方法，返回到注册，登录按钮界面
-(void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)configLoadVCUI
{
    [_backSuperView removeFromSuperview];
    self.accountView.backgroundColor = cellColor;
    self.pwdView.backgroundColor = cellColor;
    self.loadBtn.backgroundColor = HIGHLIGHTED_COLOR;
    self.loadBtn.textColor= WHTIE_NORMAL;
    self.loadBtn.font = FontSize(normal);
    self.loadBtn.userInteractionEnabled = YES;
    //登陆点击手势
    UITapGestureRecognizer *loadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadBtnAction)];
    [self.loadBtn addGestureRecognizer:loadTap];
    //忘记按钮与点击手势
    self.forgetButton.textColor = mainColor;
    self.forgetButton.backgroundColor = bgColor;
    self.forgetButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *fogetTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetPwdAction)];
    [self.forgetButton addGestureRecognizer:fogetTap];
    //用户名输入框
    _userAccountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_AccountWrite attributes:@{NSForegroundColorAttributeName:secColor}];
    _userAccountTextField.textColor = mainColor;
    _userAccountTextField.font = FontSize(normal);
    _userAccountTextField.delegate = self;
    //密码输入框
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_PasswordLoadWrite attributes:@{NSForegroundColorAttributeName:secColor}];
    _passwordTextField.textColor = mainColor;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.font = FontSize(normal);
    _passwordTextField.delegate = self;
    
    self.accountLabel.textColor = mainColor;
    self.accountLabel.font = FontSize(normal);
    self.pwdLable.textColor = mainColor;
    self.pwdLable.font = FontSize(normal);
}


#pragma mark - <轻拍响应方法>
-(void)resignLoadOnTextFieldAction
{
    [self.view endEditing:YES];
}


#pragma mark - <忘记密码Btn响应方法>
- (void)forgetPwdAction{
//    FindVC *find = [[FindVC alloc] init];
//    find.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:find animated:YES];
}


#pragma mark - <立即登录Btn响应方法>
- (void)loadBtnAction {
    MyTabbarViewController * vc = [[MyTabbarViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    
#warning  todo
//    if (self.userAccountTextField.text.length == 0){
//        [HJSTKToastView addPopString:Tip_AccountUnWrite];
//    }else if (!(([self isUserName:self.userAccountTextField.text])||([self isPureInt:self.userAccountTextField.text]))){
//        [HJSTKToastView addPopString:Tip_AccountWriteWrong];
//    }else if (self.passwordTextField.text.length == 0){
//        [HJSTKToastView addPopString:Tip_PasswordLoadUnWrite];
//    }else if (![self isPassword:self.passwordTextField.text]){
//        [HJSTKToastView addPopString:Tip_PasswordLoadWrong];
//    }else{
//        //网络请求
//        NSString *md5 = [self md5:self.passwordTextField.text];
//        [self requestLoadOnNetWorkingPhoneNoOrUserName:self.userAccountTextField.text password:md5];
//    }
 }


#pragma mark - <登录网络请求>
-(void)requestLoadOnNetWorkingPhoneNoOrUserName:(NSString *)phoneNoOrUserName
                                    password:(NSString *)password {
    [self showMBProgressHud];
    NSDictionary *param;
    if ([self isPureInt:self.userAccountTextField.text]) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:phoneNoOrUserName,@"phoneNo",password,@"passwd",nil];
    }else{
        param =  [NSDictionary dictionaryWithObjectsAndKeys:phoneNoOrUserName,@"appUserName",password,@"passwd", nil];
    }
    NSString *url  = [NSString stringWithFormat:@"%@%@",GetLoadPreUrl,GetLoad];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    [manager setSecurityPolicy:[self customSecurityPolicy]];//适配https
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
     [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      NSLog(@"%@",responseObject);
      self.loadModel = [LoadReturnModel itemLoadReturnModelWithDictionary:responseObject];
         NSLog(@"登录返回信息：%@",self.loadModel.returnMsg);
      [HJSTKToastView addPopString:self.loadModel.returnMsg];
         /**
          * 0:登陆成功
          * 1:密码不正确
          * 2:用户不存在
          * 999:未捕获的异常
          */
      if ([self.loadModel.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
          
          if (![self.loadModel.appUserName isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.appUserName, KGetUserName);//用户名
          }
          if (![self.loadModel.appUserId isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.appUserId,KGetUserID);//用户ID
          }
          if (![self.loadModel.phoneNo isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.phoneNo,KGetPhone);//手机号
          }
          if (![self.loadModel.lastName isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.lastName, kGetName);//昵称
          }
          if (![self.loadModel.address isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.address,KGetAddress );//地址
          }
          if (![self.loadModel.cAdderss isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.cAdderss,KGetArea );//区域
          }
          if (![self.loadModel.headPortraitUrl isEqual:[NSNull null]]) {
          //保存头像地址
              kPermanent_SET_OBJECT(self.loadModel.headPortraitUrl,KGetHeadImageUrl);
          }
          NSLog(@"loadReturnImageUrl:%@--%@",kPermanent_GET_OBJECT(KGetHeadImageUrl),self.loadModel.headPortraitUrl);
          if (![self.loadModel.sex isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.sex,kGetGender);//性别
          }
          if (![self.loadModel.birthday isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.birthday, KGetBirth);//生日
          }
          if (![self.loadModel.ip isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.ip, KGetIP);
          }
          if (![self.loadModel.port isEqual:[NSNull null]]) {
              kPermanent_SET_OBJECT(self.loadModel.port, KGetPort);
          }
          //登陆成功时，置为yes
          kPermanent_SET_BOOL(YES, KGLaunchLoad);
          //如果发送通知指定了object对象，那么观察者接收通知设置的object对象与其一样，才会接收到通知；但是接收通知如果将这个参数设置为nil，则会接收到一切通知
          [[NSNotificationCenter defaultCenter]postNotificationName:LOGINMESSAGE object:LOGIN];
          //设置别名
//          [self registerDeviceId];
      }
      [self hideMBProgressHud];
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      [self hideMBProgressHud];
      [HJSTKToastView addPopString:error.localizedDescription];

  }];
}


#pragma mark - 设置别名 -
//- (void)registerDeviceId {
//    [JPUSHService registrationID];
//    NSLog(@"registrationID:%@",[JPUSHService registrationID]);
//    NSString *alias = kPermanent_GET_OBJECT(KGetUserID);
//    NSLog(@"alias:%@",alias);
//    if (alias == nil) {
//        alias = @"";
//    }
//    /**tags alias
//     *空字符串（@“”）表示取消之前的设置
//     *nil,此次调用不设置此值
//     *每次调用设置有效的别名，覆盖之前的设置
//     */
//    [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
//        //对应的状态码返回为0，代表成功
//    }];
//}


#pragma mark - <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - <第三方登陆>
- (IBAction)quickLoginButtonClick:(UIButton *)btn {
    UMSocialPlatformType currentPlatformType;
    if ([[btn currentTitle] isEqualToString:@"微博"]) {
        currentPlatformType = UMSocialPlatformType_Sina;
    }else if ([[btn currentTitle] isEqualToString:@"微信"])
    {
        currentPlatformType = UMSocialPlatformType_WechatSession; }
    else{
        currentPlatformType = UMSocialPlatformType_QQ;
        }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:currentPlatformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
        }
    }];
}

- (IBAction)registButtonClick:(UIButton *)sender {
//     ChooseAddressVC *cityVc = [[ChooseAddressVC alloc]init];
//    [self.navigationController pushViewController:cityVc animated:YES];
    QRScanViewController * scanVC = [[QRScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}


@end
