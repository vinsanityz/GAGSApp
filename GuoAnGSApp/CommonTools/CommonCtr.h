//
//  CommonCtr.h
//  CS_WeiTV
//
//  Created by wy on 15/7/15.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamFile.h" //宏定义

#import <MBProgressHUD.h>
#import "LYNetworkManager.h" //网络请求基类
#import "SVPullToRefresh.h" //上拉加载，下拉刷新
#import "HJSTKToastView.h" 
#import "CSReachability.h" //网络监测封装
#import "ReturnModel.h"    //错误数据返回
#import "LoadReturnModel.h" //登录数据返回
#import "AlertStateView.h"
#import<CommonCrypto/CommonDigest.h> 




@interface CommonCtr : UIViewController<CSReachabilityDelegate,RequestMoreDelegate,NSCoding>
{   //显示判断
    BOOL _showLeft;
    
    UIView *_backSuperView;
    
       
    SingleColor *single;//颜色、字体大小
    CSReachability *_netWorkReachability;//网络监测
    MBProgressHUD *_tvHub;//加载框
    
    UIColor *mainColor; //一级字体颜色
    UIColor *secColor; //二级字体颜色
    UIColor *bgColor; //view背景色
    UIColor *cellColor; //cell背景色
    CGFloat normal; //正常字体大小
    CGFloat small;  //小 字体
    CGFloat big; //大 字体

}
@property (nonatomic, assign) id object;
@property (nonatomic, assign) SEL btnSelector;

@property (nonatomic, assign) BOOL showLeft;
@property (nonatomic, copy) NSString *titleMessage;//导航栏的标题
@property (nonatomic,strong) ReturnModel *commonReturnCode;
@property (nonatomic,strong) LoadReturnModel *loadModel;//登录返回的信息
@property(nonatomic,strong) AlertStateView *stateView;



/* 缺省实现 子类需要override */
- (void) goBack;
-(void)btnClick:(UIButton *)btn;


/**判断手机号码是否正确**/
- (BOOL)isPureInt:(NSString*)string;

/**
 *  设置字体大小
 */
//-(void)setFontSize:(NSString*)size;
/**
 *设置右导航包含背景图的Btn
 */
-(void)setNavRight:(NSString*)rightBtn;

-(void)setNavRightArr:(NSArray *)btnArr;


+(id)restore;
+(void)saveColor:(id)singleInfo;


-(void)setNavLeftWithStr:(NSString *)str;
-(void)setNavRightWithStr:(NSString *)str;



/**
 *提交按钮
 */
-(void)submitNavRight;

/**
 *保存在Documents文件夹中
 */
-(NSString *)returnDocumentPath:(NSString *)fileName;


/**
 *保存在caches文件夹中
 */
-(NSString *)returnLibraryCachesfilePath:(NSString *)path;

/**
 *删除文件
 */
-(void)deleateFile:(NSString *)fileName;

-(void)writeEasyToFile:(NSString *)filePath object:(id)object;


-(NSMutableArray *)readFileFromEay:(NSString *)filePath;




//设置导航条上的保存按钮
-(void)setNavRight_title;

/**设置导航条取消按钮*/
-(void)setNavLeft_title;


/**个人信息修改网络请求,昵称，生日，性别，地址**/
-(void)requestDevisePersonInfoForPersonUserName:(NSString *)userName nickName:(NSString *)nickName birthday:(NSString *)birthday gender:(NSString *)gender address:(NSString *)address ;

/**显示加载进度框**/
-(void)showMBProgressHud;
-(void)showMBProgressHud:(NSString *)str;

/**隐藏加载进度框**/
-(void)hideMBProgressHud;

/**无网络，无数据时所添加的警示view**/
-(void)createAlertStateViewHeight:(CGFloat)headerHeight msg:(NSString *)msg;
/**移除警示view**/
-(void)removeAlertStateView;

/*md5加密*/
- (NSString *)md5:(NSString *)str;

/*判断密码位数是否为6-18位*/
- (BOOL)isPassword:(NSString*)string;

/*判断用户名*/
- (BOOL)isUserName:(NSString*)string;


- (AFSecurityPolicy*)customSecurityPolicy;

@end
