 //
//  CommonCtr.m
//  CS_WeiTV
//
//  Created by wy on 15/7/15.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "CommonCtr.h"


#define LOGO_IMAGE @"vtv_logo"

#define LOGO_TITLE @"国安微TV"


@interface CommonCtr ()

@property(nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *titleLabel;

@end


static NSArray *_backColorArr;

static inline NSString * myselfSaveFile() {
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/info"];
}

@implementation CommonCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
   _netWorkReachability = [CSReachability shareInstance];//用于网络监测
   _netWorkReachability.delegate = self;

    single =[SingleColor sharedInstance];
    [CommonCtr restore];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCommonColor) name:ColorNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serCommonFont) name:FontNoti object:nil];
    [self creatUI];
    
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

+(void)saveColor:(id)colorArr
{
    NSMutableData *data = [NSMutableData data];
    
    NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [keyedArchiver encodeObject:colorArr forKey:@"dic"];
    
    [keyedArchiver finishEncoding];
    
    NSString *filePath = myselfSaveFile();
    NSLog(@"filePath:%@",filePath);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:filePath])
        
    {
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    [data writeToFile:filePath atomically:YES];
}

+(id )restore
{
    NSString *path =myselfSaveFile();
    NSData *data2 = [NSData dataWithContentsOfFile:path];
    NSLog(@"沙河路径path=%@",path);//打印沙盒路径
    
    NSKeyedUnarchiver *keyedUnarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
    
    SingleColor* newArray = [keyedUnarchiver decodeObjectForKey:@"dic"];
    SingleColor *sing1 = [SingleColor sharedInstance];
    sing1.colorDic = newArray.colorDic;
    sing1.colorEdition = newArray.colorEdition;
    
    sing1.fontDic = newArray.fontDic;
    sing1.fontEdition = newArray.fontEdition;
    
    sing1.fontSize = newArray.fontSize;
    return newArray;
}



-(void)creatUI
{

    _backSuperView  = [UIView new];
    [self.view addSubview:_backSuperView];
    [_backSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    mainColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
    secColor = [single.colorDic objectForKey:FONT_SEC_COLOR];
    cellColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    bgColor = [single.colorDic objectForKey:BACK_SUPER_COlOR];
    normal =[[single.fontDic objectForKey:NAORMAL_SIZE] floatValue];
    big = [[single.fontDic objectForKey:BIG_SIZE] integerValue];
    small =  [[single.fontDic objectForKey:SMALL_SIZE] integerValue];

    
    [self setCommonColor];
  

}

//设置颜色
-(void)setCommonColor
{
    self.view.backgroundColor = [single.colorDic objectForKey:BACK_SUPER_COlOR];

    _backSuperView.backgroundColor = [single.colorDic objectForKey:BACK_SUPER_COlOR];
   
    self.navigationController.navigationBar.barTintColor = [single.colorDic objectForKey:NAVCOLOR];

    self.nameLab.textColor = [single.colorDic objectForKey:FONT_NAV_MAIN_COLOR];
    self.titleLabel.textColor = [single.colorDic objectForKey:FONT_NAV_MAIN_COLOR];
}

//设置字体大小
-(void)serCommonFont{
    self.nameLab.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    self.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    
    
}


#pragma mark - 沙盒路径 -
/**保存在Document文件夹中**/
-(NSString *)returnDocumentPath:(NSString *)fileName
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [documents stringByAppendingPathComponent:fileName];
    NSLog(@"path:%@",filePath);
    return filePath;
    
}

// Library/caches
-(NSString *)returnLibraryCachesfilePath:(NSString *)path
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [documents stringByAppendingPathComponent:path];
    NSLog(@"path:%@",filePath);
    return filePath;
    
}




#pragma mark - writeToFile:写入文件-
-(void)writeEasyToFile:(NSString *)filePath object:(id)object
{
    //1.创建文件路径
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        [manager createFileAtPath:filePath contents:nil attributes:nil];
    }
    //2.将对象写入文件
    if ([object writeToFile:filePath atomically:YES ]) {
        NSLog(@"简单对象成功写入文件");
    }else{
        NSLog(@"简单对象写入文件失败");
    }
}

#pragma mark - 从文件中读取 -
-(NSMutableArray *)readFileFromEay:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSMutableArray *dataList = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSLog(@"dataList:%@",dataList);
    return dataList;
}




//删除文件
-(void)deleateFile:(NSString *)fileName
{
    NSFileManager *file = [NSFileManager defaultManager];
    [file removeItemAtPath:fileName error:nil];
}


#pragma mark - <导航条左侧按钮>
-(BOOL)showLeft {
    return _showLeft;
    
}

-(void)setShowLeft:(BOOL)showLeft {
    _showLeft = showLeft;
    /*
     _showLeft为yes说明返回按钮
     _showLeft为no说明为logo图片
     */
    
    if (_showLeft) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:ImageNamed(@"返回键") forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    } else if(_showLeft == NO) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 54, 30)];
        self.nameLab  = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 150, 38)];
        self.nameLab.textColor = [single.colorDic objectForKey:FONT_NAV_MAIN_COLOR];
        self.nameLab.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
        UIBarButtonItem *imgItem = [[UIBarButtonItem alloc] initWithCustomView:img];
        
        UIBarButtonItem *nameItem = [[UIBarButtonItem alloc] initWithCustomView:self.nameLab];
        NSArray *itemArr = [[NSArray alloc]initWithObjects:imgItem,nameItem, nil];
        self.navigationItem.leftBarButtonItems = itemArr;

        NSArray *sourceArray = [self readDataFromPlist];
       [sourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           NSDictionary *dict = obj;
           NSString *titleName = dict[@"titleName"];
           NSString *imageName = dict[@"imageName"];
           NSLog(@"titleName:%@",titleName);
           NSLog(@"地区：%@",kPermanent_GET_OBJECT(KGetArea));

           if ([kPermanent_GET_OBJECT(KGetArea) isEqualToString:titleName]) {
               img.image = ImageNamed(imageName);
           }
          
           NSLog(@"image:%@",img.image);
       }];
        self.nameLab.text = [NSString stringWithFormat:@"%@%@",kPermanent_GET_OBJECT(KGetArea),LOGO_TITLE];
        NSLog(@"img:%@",img.image);
        if (img.image == nil ) {
            if ([kPermanent_GET_OBJECT(KGetArea) isEqualToString:@"黄冈"] ||[kPermanent_GET_OBJECT(KGetArea) isEqualToString:@"黄石"]||[kPermanent_GET_OBJECT(KGetArea) isEqualToString:@"咸宁"]) {
                img.image = ImageNamed(@"hb_logo");
            
            }
            else   {img.image = ImageNamed(LOGO_IMAGE);
            }
        
        
    
        }}}

-(NSArray *)readDataFromPlist
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"NavSource" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:filePath];
}


#pragma mark - <返回上一层级>
-(void)goBack {
    NSLog(@"返回上一个层级");
    [LYNetworkManager cancelAllRequest];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setNavLeftWithStr:(NSString *)str{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE_OTHER];
    [btn setTitleColor:HIGHLIGHTED_COLOR forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItm = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nextItm;
}


-(void)setNavRightWithStr:(NSString *)str{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE_OTHER];
    [btn setTitleColor:HIGHLIGHTED_COLOR forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItm = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = nextItm;
}


#pragma mark - <导航条右侧图片按钮>
//包含图片的按钮
//主页搜索
-(void)setNavRight:(NSString *)str{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:ImageNamed(str) forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItm = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = nextItm;
    
}

-(void)setNavRightArr:(NSArray *)btnArr
{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<[btnArr count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:ImageNamed(btnArr[i]) forState:UIControlStateNormal];
        btn.tag = 5000+i;
        [btn sizeToFit];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *imgItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [arr addObject:imgItem];
    }
    self.navigationItem.rightBarButtonItems = arr;
    
}



//各类方法中重写
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"common click");
}

#pragma mark - <导航标题>
-(void)setTitleMessage:(NSString *)titleMessage {
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.text = titleMessage;
    _titleLabel.textColor = [single.colorDic objectForKey:FONT_NAV_MAIN_COLOR];
    _titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE]intValue]];
    [_titleLabel sizeToFit];
    self.navigationItem.titleView = _titleLabel;
}





#pragma mark - <判断手机号格式是否正确>
//^1[3|4|5|7|8][0-9]\\d{8}$
//.手机号：11位数字。其他内容属于非法内容，提示用户输入有误。
- (BOOL)isPureInt:(NSString*)string
{
    NSLog(@"判断手机号");
    //手机号位数为11，且均为数字
    NSString *phoneRegex = @"^[0-9]{11}$";
    NSPredicate *phoneP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSLog(@"%u",[phoneP evaluateWithObject:string]);

    return [phoneP evaluateWithObject:string];

}


#pragma mark - <判断密码格式>
//.密码：不包含空格，长度限制6~18位。其他内容属于非法内容，提示用户输入有误。
- (BOOL)isPassword:(NSString*)string
{
    NSLog(@"判断密码");
    //不包含空格，6-18位
    NSString *phoneRegex = @"^[^\\s]{6,18}$";
    NSPredicate *phoneP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSLog(@"%u",[phoneP evaluateWithObject:string]);

    return [phoneP evaluateWithObject:string];

}




#pragma mark - <判断用户名>
//用户名：包含数字、字母、下划线，长度限制4~18位。其他内容属于非法内容，提示用户输入有误。
- (BOOL)isUserName:(NSString*)string
{
    /**
     * "\w" 匹配包括下划线的任何单词字符    等价于   "[A-Za-z0-9_]"
     *
     **/
    NSLog(@"判断用户名");
    //包括数字字符下划线，4-18位
    NSString *phoneRegex = @"^[A-Za-z0-9_]{4,18}$";
    NSPredicate *phoneP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSLog(@"%u",[phoneP evaluateWithObject:string]);

    return [phoneP evaluateWithObject:string];
}



#pragma mark - <导航条取消保存按钮>
-(void)setNavLeft_title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[single.colorDic objectForKey:FONT_SEC_COLOR] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItm = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nextItm;
}

-(void)setNavRight_title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(saveRight) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItm = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = nextItm;
}

-(void)saveRight{
    NSLog(@"导航条右侧保存按钮");
}


#pragma - mark 提交按钮
-(void)submitNavRight{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(submmit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItm = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = nextItm;
    
}

-(void)submmit{
    NSLog(@"提交按钮，子类中实现");
}






#pragma mark - <显示加载进度框>
-(void)showMBProgressHud
{
    _tvHub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_tvHub setMode:MBProgressHUDModeIndeterminate];
    _tvHub.labelText = @"加载中";
}

-(void)showMBProgressHud:(NSString *)str
{
    _tvHub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_tvHub setMode:MBProgressHUDModeIndeterminate];
    _tvHub.labelText = str;
}


#pragma mark - <隐藏加载进度框>
-(void)hideMBProgressHud
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}


#pragma mark - <没有网，没有缓存时加载的视图>

-(void)createAlertStateViewHeight:(CGFloat)headerHeight msg:(NSString *)msg
{
    //保证只创建一次
    if (!self.stateView) {
        self.stateView = [[[NSBundle mainBundle]loadNibNamed:@"AlertStateView" owner:nil options:nil]firstObject];
        self.stateView.backgroundColor = [UIColor clearColor];
        self.stateView.delegate = self;
        self.stateView.alertLabel.text = msg;
        self.stateView.frame = CGRectMake(0, 64 + headerHeight, ScreenSizeWidth, ScreenSizeHeigh-64-headerHeight);
        [self.view addSubview:self.stateView];
    }
}

#pragma mark - <移除警示view>
-(void)removeAlertStateView
{
    NSLog(@"移除view");
    
    [self.stateView removeFromSuperview];
    self.stateView = nil;
    
}

-(void)requestOnceMoreNetWorking
{
    NSLog(@"再次请求网络代理方法，子类中实现");
}

-(void)netWorkChangedAction:(NetworkStatus)status
{
    NSLog(@"网络状态变化代理方法，子类中实现");
}

#pragma mark - <修改个人信息---昵称，生日，性别，地址网络请求方法>
-(void)requestDevisePersonInfoForPersonUserName:(NSString *)userName nickName:(NSString *)nickName birthday:(NSString *)birthday gender:(NSString *)gender address:(NSString *)address
{
    [self showMBProgressHud];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (userName != nil) {
        [dict setObject:userName forKey:@"appUserName"];
    }
    if ( nickName != nil) {
        [dict setObject:nickName forKey:@"lastName"];
    }
    if (birthday != nil) {
        [dict setObject:birthday forKey:@"birthday"];
    }
    if (gender != nil) {
        [dict setObject:gender forKey:@"sex"];
    }
    if (address != nil) {
        [dict setObject:address forKey:@"address"];

    }
        NSLog(@"DeviceParam:%@",dict);
    [LYNetworkManager POST:GetCompletePersonInfo parameters:dict successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"DeviseMessageInfo:%@",responseObject);
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        NSLog(@"修改返回信息：%@\n%@",self.commonReturnCode.returnCode,self.commonReturnCode.returnMsg);
        NSLog(@"修改前：%@",self.loadModel.lastName);
        if ([self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [HJSTKToastView addPopString:@"修改成功"];
            if (nickName != nil) {
                kPermanent_SET_OBJECT(nickName, kGetName);
            }
            if (birthday != nil) {
                kPermanent_SET_OBJECT(birthday, KGetBirth);
            }
            if (gender != nil) {
                kPermanent_SET_OBJECT(gender, kGetGender);
            }
            if (address != nil) {
                kPermanent_SET_OBJECT(address, KGetAddress);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        }
        [self hideMBProgressHud];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        [HJSTKToastView addPopString:error.localizedDescription];
        [self hideMBProgressHud];
    }];

}

#pragma mark - <md5加密>
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark - <https证书验证>
- (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ca" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    
    return securityPolicy;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
