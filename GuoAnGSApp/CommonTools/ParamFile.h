//
//  ParamFile.h
//  CS_WeiTV
//
//  Created by wy on 15/7/15.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#ifndef CS_WeiTV_ParamFile_h
#define CS_WeiTV_ParamFile_h

#import "SingleColor.h"             //颜色单例
#import "ZCZTipsView.h"             //弹出的提示窗
#import "CSReachability.h"          //网络监测封装
#import "AlertStateView.h"          //警视窗
#import "LYNetworkManager.h"        //封装的网络请求基类
#import "UIView+Frame.h"            //frame的类扩展
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>

#pragma mark - <宏定义方法>
//^^^^^^^^以下为宏定义方法^^^^^^^^^^^^^^^
/*显示图片名称方法*/
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

/*显示字体大小方法*/
#define FontSize(_size) [UIFont systemFontOfSize:_size]

/*防止block循环引用的方法*/
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

/*字符串拼接*/
#define JoinTwoParamFormatStr(firstParam,secondParam) [NSString stringWithFormat:@"%@%@",firstParam,secondParam];

/*颜色转码*/
#define HEXCOLOR(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

/*判断服务器返回的数值是否为空*/
#define vertifyNumber(value)\
({\
id tmp;\
if (value isKindOfClass:[NSNull class])\
tmp == nil;\
else\
tmp = value;\
tmp;\
})\

/**
 *  永久存储对象 NSUserDefaults
 *  @param object 需要存储的对象
 *  @param key    对应的key
 */
#define kPermanent_SET_OBJECT(object, key)\
({\
NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];\
[defaults setObject:object forKey:key]; \
[defaults synchronize];\
})

#define kPermanent_SET_BOOL(BOOL, key)\
({\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];;\
[defaults setBool:BOOL forKey:key];\
[defaults synchronize];\
})

/**
 *  取出永久存储的对象
 *  @param  key 对象对应的key
 *  @return key 所对应的对象
 */
#define kPermanent_GET_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define kPermanent_GET_BOOL(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]


#pragma mark - 友盟分享标识 -
//^^^^^^友盟分享^^^^^^^^^^^^^^^^^^^^
#warning todo  不必写在这里
#define UMAppKey @"5836495d07fe65019e0024af"

#define UMQQAppID @"1105219519"
#define UMQQAppKey @"r2hskYHiYsiAPwB0"
#define UMWXAppId @"wx49fc02e152178554"
#define UMWXAppSecert @"6093d6eff09f07c76a48c2075bdd63ce"
#define UMWBAppKey @"246862663"
#define UMWBAppSecret @"f5937e74b93537185f0d9843f4aa7f63"

#pragma mark - <标识符>
//^^^^^^^标识^^^^^^^^^^^^^^^^^^^^^^
/*用户个人信息存储key*/

/*用户名*/
#define KGetUserName @"userName"
/*用户ID*/
#define KGetUserID @"userID"
/*性别*/
#define kGetGender @"gender"
/*昵称*/
#define kGetName @"nickName"
/*手机号*/
#define KGetPhone @"cellPhoneNumber"
/*地址*/
#define KGetAddress @"address"
/*生日*/
#define KGetBirth @"birthday"
/*区域*/
#define KGetArea @"area"
/*头像路径*/
#define KGetHeadImageUrl @"headPortraitUrl"
/*开关的状态*/
#define KGetSWitch @"switchOn"

/*记录是否登录过: yes登录成功, no退出登录 */
#define KGLaunchLoad @"launchLoad"

/*城市定位*/
#define KGetLocate @"locateCity"

/*警示图片名称*/
#define AlertImageName @"no_data"

#define LOGINMESSAGE @"loginAndreg"
/*登录标识*/
#define LOGIN @"login"
/*退出登录标识*/
#define EXITLOGIN @"exitLog"

/**注册前的信息列表页以及登录返回的url 因地而异**/
/*ip地址*/
#define KGetIP @"ip"
/*端口号*/
#define KGetPort @"port"


#pragma mark - <归档信息存储key>
/*直播主界面键值*/
#define KGetLive @"LiveVC"
/*直播详情界面键值*/
#define KGetTimeOfLive @"LiveTime"

/*归档信息文件名*/

/*点播主界面滑动条缓存*/
#define FKGetVideoFirst @"FrontPageFirst"
/*直播主界面缓存*/
#define FKGetLive @"LiveVCcache"
/*直播详情缓存*/
#define FKGetTimeOfLive @"LiveTimeCache"

#define TieUp_Btn @"绑定按钮"


#pragma mark -颜色-
//^^^^^^^^^^颜色^^^^^^^^^^^^^^^^^^
//颜色值
//白色版本
#define NAV_WHITE HEXCOLOR(0xffffff)
#define BACKGROUD_WHITE HEXCOLOR(0xeeeeee)
#define TABBAR_WHITE HEXCOLOR(0xffffff)
#define BACK_CONTROL_WHITE HEXCOLOR(0xffffff)
#define LINE_WHITE HEXCOLOR(0xdddddd)
#define FONT_MAIN_WHITE HEXCOLOR(0x797979)
#define FONT_SEC_WHITE HEXCOLOR(0xaaaaaa)
#define FONT_NAV_WHITE HEXCOLOR(0x333333)
#define FONT_NAV_SEC_WHITE HEXCOLOR(0x888888)
#define FONT_TABBAR_WHITE HEXCOLOR(0x777777)

//黑色版本
#define NAV_BLACK HEXCOLOR(0x444444)
#define BACKGROUD_BLACK HEXCOLOR(0x000000)
#define TABBAR_BLACK HEXCOLOR(0x444444)
#define BACK_CONTROL_BLACK HEXCOLOR(0x444444)
#define LINE_BLACK HEXCOLOR(0x666666)
#define FONT_MAIN_BLACK HEXCOLOR(0xffffff)
#define FONT_SEC_BLACK HEXCOLOR(0xffffff)
#define FONT_NAV_BLACK HEXCOLOR(0xffffff)
#define FONT_NAV_SEC_BLACK HEXCOLOR(0xffffff)
#define FONT_TABBAR_BLACK HEXCOLOR(0xffffff)
//#define HIGHLIGHTED_BLACK HEXCOLOR(0xf97526)
//#define OTHER_BLACK HEXCOLOR(0xcccccc)

//蓝色版本
#define NAV_BLUE HEXCOLOR(0x253e66)
#define BACKGROUD_BLUE HEXCOLOR(0x1b2c47)
#define TABBAR_BLUE HEXCOLOR(0x253e66)
#define BACK_CONTROL_BLUE HEXCOLOR(0x253e66)
#define LINE_BLUE HEXCOLOR(0x4d4d4d)
#define FONT_MAIN_BLUE HEXCOLOR(0xffffff)
#define FONT_SEC_BLUE HEXCOLOR(0xffffff)
#define FONT_NAV_BLUE HEXCOLOR(0xffffff)
#define FONT_NAV_SEC_BLUE HEXCOLOR(0xffffff)
#define FONT_TABBAR_BLUE HEXCOLOR(0xcccccc)
//#define HIGHLIGHTED_BLUE HEXCOLOR(0xf97526)
//#define OTHER_BLUE HEXCOLOR(0xcccccc)

//高亮及其他
#define HIGHLIGHTED_COLOR HEXCOLOR(0xf97526)
#define OTHER_COLOR HEXCOLOR(0xcccccc)
#define WHTIE_NORMAL HEXCOLOR(0xffffff)


//颜色字典
//白色
#define WhiteDic @{@"navColor":NAV_WHITE,@"tabbarColor":TABBAR_WHITE,@"backSuperColor":BACKGROUD_WHITE,@"backControlColor":BACK_CONTROL_WHITE,@"lineColor":LINE_WHITE,@"fontMainColor":FONT_MAIN_WHITE,@"fontSecColor":FONT_SEC_WHITE,@"fontNavColor":FONT_NAV_WHITE,@"fontTabbarColor":FONT_TABBAR_WHITE,@"fontNacSecColor":FONT_NAV_SEC_WHITE}

//黑色
#define BLACKDic @{@"navColor":NAV_BLACK,@"tabbarColor":TABBAR_BLACK ,@"backSuperColor":BACKGROUD_BLACK,@"backControlColor":BACK_CONTROL_BLACK,@"lineColor":LINE_BLACK,@"fontMainColor":FONT_MAIN_BLACK,@"fontSecColor":FONT_SEC_BLACK,@"fontNavColor":FONT_NAV_BLACK,@"fontTabbarColor":FONT_TABBAR_BLACK,@"fontNacSecColor":FONT_NAV_SEC_BLACK}

//蓝色
#define BLUEDic @{@"navColor":NAV_BLUE,@"tabbarColor":TABBAR_BLUE ,@"backSuperColor":BACKGROUD_BLUE,@"backControlColor":BACK_CONTROL_BLUE,@"lineColor":LINE_BLUE,@"fontMainColor":FONT_MAIN_BLUE,@"fontSecColor":FONT_SEC_BLUE,@"fontNavColor":FONT_NAV_BLUE,@"fontTabbarColor":FONT_TABBAR_BLUE,@"fontNacSecColor":FONT_NAV_SEC_BLUE}

//颜色key
#define NAVCOLOR @"navColor"
#define TABBARCOLOR @"tabbarColor"
#define BACK_SUPER_COlOR @"backSuperColor"
#define BACK_CONTROL_COLOR @"backControlColor"
#define LINECOLOR @"lineColor"
#define FONT_MAIN_COLOR @"fontMainColor"//标题字体颜色
#define FONT_SEC_COLOR @"fontSecColor"//副标题字体颜色
#define FONT_TABBAR_COLOR @"fontTabbarColor"
#define FONT_NAV_MAIN_COLOR @"fontNavColor"
#define FONT_NAV_SEC_COLOR @"fontNacSecColor"//二级分类导航颜色
//#define HIGHLIGHTED_COLOR @"selectColor"//高亮颜色
//#define OTHER_COLOR @"otherColor"//备注及加载文字颜色


#pragma mark - 字号 -
//^^^^^^^^^^^^^字号^^^^^^^^^^^^^^^^^^^^
/*字体大小*/
#define SetFontSize(size)
//字号
#define FONTSIZE_MAX 21
#define FONTSIZE_MIDDLE 17
#define FONTSIZE_MIN 13
#define FONTSIZE_OTHER 14

//小版本
#define SMALL_MIN @"9"
#define SMALL_MIDDLE @"13"
#define SMALL_MAX @"17"
#define SMALL_OTHER @"12"
#define SMALL_MORE @"10"


//正常版本
#define  NORMAL_MIN @"13"
#define  NORMAL_MIDDLE @"17"
#define  NORMAL_MAX @"21"
#define  NORMAL_OTHER @"14"
#define  NORMAL_MORE @"12"

//大版本
#define BIG_MIN @"17"
#define BIG_MIDDLE @"21"
#define BIG_MAX @"25"
#define BIG_OTHER @"16"
#define BIG_MORE @"14"

//字号字典
//小
#define SMALLDic @{@"small":SMALL_MIN,@"middle":SMALL_MIDDLE,@"big":SMALL_MAX,@"other":SMALL_OTHER,@"more":SMALL_MORE}

//正常
#define NORMALDic @{@"small":NORMAL_MIN,@"middle":NORMAL_MIDDLE,@"big":NORMAL_MAX,@"other":NORMAL_OTHER,@"more":NORMAL_MORE}

//大
#define BIGDic @{@"small":BIG_MIN,@"middle":BIG_MIDDLE,@"big":BIG_MAX,@"other":BIG_OTHER,@"more":BIG_MORE}

//字号key
#define SMALL_SIZE @"small"
#define NAORMAL_SIZE @"middle"
#define BIG_SIZE @"big"
#define OTHER_SIZE @"other"
#define MORE_SIZE @"more"


#define Horizontal_Offset 146

#define ColorNoti @"colorNoti"
#define FontNoti @"fontNoti"

//颜色版本
#define WHITE_EDITION @"简约白"
#define BLACK_EDITION @"酷爽黑"
#define BLUE_EDITION @"气质蓝"

//颜色版本数组
#define COLOR_ARR @[WHITE_EDITION,BLACK_EDITION,BLUE_EDITION]

//字体大小版本
#define BIG_EDITION @"大"
#define NORMAL_EDITION @"正常"
#define SMALL_EDITION @"小"

//字体大小版本数组
#define SIZE_ARR @[BIG_SIZE,NORMAL_SIZE,SMALL_SIZE];


#pragma mark -高度宏定义-
//^^^^^^^^^控件高度^^^^^^^^^^^^^^^^^^^^^^
/**
 *设置轮播图的高度
 *设置图片的宽高比为16:9
 *设置固定宽度为 [[UIScreen mainScreen] bounds].size.width
 */
#define TOP_HEIGHT [[UIScreen mainScreen] bounds].size.width * 9 / 16

#define mlrHeight 55

/**悬浮按钮起始高度**/
#define Icon_Height 64 + 49


#define LiveCellHeigh 45


#define SearchCellHigh 130

#define ScreenSize [[UIScreen mainScreen] bounds].size
#define ScreenSizeWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenSizeHeigh [[UIScreen mainScreen] bounds].size.height

#define Common_offset 20
#define LabelHeight 30
#define buttonWH 16


#define SCREEN_BOUNDS               [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width


/*
 iPhone4 320*480
 iPhone5 320*568
 iPhone6/6s 375*667
 iPhone6/6s Plus 414*736
 
 iPad 768*1024
 iPad2 768*1024
 iPad3 768*1024
 iPadAir 768*1024
 iPadMini 768*1024
 */

// 屏幕尺寸适配:
#define SCREEN_HEIGHT_OF_IPHONE4        480
#define SCREEN_HEIGHT_OF_IPHONE5        568
#define SCREEN_HEIGHT_OF_IPHONE6        667
#define SCREEN_HEIGHT_OF_IPHONE6PLUS    736
#define SCREEN_BOUNDS               [UIScreen mainScreen].bounds

#define ISIPHONE4 (ScreenSizeHeigh == SCREEN_HEIGHT_OF_IPHONE4)
#define ISIPHONE5 (ScreenSizeHeigh == SCREEN_HEIGHT_OF_IPHONE5)
#define ISIPHONE6 (ScreenSizeHeigh == SCREEN_HEIGHT_OF_IPHONE6)
#define ISIPHONE6PLUS (ScreenSizeHeigh == SCREEN_HEIGHT_OF_IPHONE6PLUS)


#define PickerViewHeight 200

#define BusinessInfo_CellHigh 130

//tabbar高度是49
#define TabBar_Height 49

//导航条和状态栏的总高度
#define NaviAndStatus_Height 20+44

#define Bottom_interval 5

#define Interval_15 15

#define DownBtnWidHei 30

/**应用在点播中
 *设置图片的宽高比为----10:13
 *设置图片的行间距为15
 *设置图片的固定宽度为  SW = ([[UIScreen mainScreen] bounds].size.width - 60)/3
 *根据以上条件求出图片的高度
 */
#define ImageHigh (ScreenSizeWidth - 15 *4) /3 * 13 /10


/*应用在点播中
 *图片名字的高度为20，图片和名字与cell的上下间距分别是10
 *cell高度 = 图片+图片名字+上下间距
 */
#define VideoCellHigh (ScreenSizeWidth - 15 *4) /3 *13 /10 +5+20+20

#define commonCellHigh 50
#define otherCellHigh 60



#pragma mark - 宏定义数组 -
//^^^^^^^^宏定义数组^^^^^^^^^^^^^^^^^
#define MY_Finish_Message @[@"昵称",@"性别",@"生日",@"地址"]
#define Service_SortArray @[@"序列排序",@"首字母排序",@"价格排序"]
#define My_PersonSecondArray @[@"昵称",@"手机号",@"修改密码"]
#define MY_PersonThirdArray @[@"性别",@"生日",@"地址"]
#define MY_PwdDeviseAray @[@"当前密码",@"新密码",@"确认新密码"]

#define MY_LoadTitleName @[@"账号",@"密码"]
#define MY_LoadImageName  @[@"iconfont-zhanghao01_小",@"iconfont-mima01_小"]

#define MY_SectionArrayFirst  @[@"消费记录",@"预约记录",@"收藏记录",@"播放记录"]
//#define MY_SectionArraySecond @[@"离线缓存",@"城市选择",@"关于",@"设置"]
//#define MY_SectionArraySecond @[@"城市选择",@"关于",@"设置"]
#define MY_SectionArraySecond @[@"家庭成员",@"历史记录",@"我的预约",@"我的收藏",@"我的设备",@"产品订购",@"设置",@"账号绑定"]

#define PersonalCenterTableViewSectionArray                   @[@[@"账号密码"],                                                         @[@"账号关联"],                                              @[@"观看记录",@"预约记录",@"收藏记录"],                         @[@"盒子绑定管理",@"购买记录"],                               @[@"设置"]]

#define MY_PictureNameFirst  @[@"my_con",@"my_orders",@"my_collection",@"my_play"]
//#define MY_PictureNameSecond @[@"my_cache",@"my_city",@"my_about",@"my_set"]
//#define MY_PictureNameSecond @[@"my_city",@"my_about",@"my_set"]
#define MY_PictureNameSecond @[@"my_about",@"my_set"]

//#define Service_SectionArray  @[@"电视业务",@"宽带业务",@"营业网点分布",@"故障维修",@"互动业务",@"新装业务"]
#define Service_SectionArray  @[@"电视业务",@"宽带业务",@"营业网点分布"]

//#define Service_PictureArray @[@"tv",@"broadband",@"fenbu",@"fix",@"yewu",@"new"]
#define Service_PictureArray @[@"tv",@"broadband",@"fenbu",@"fix",@"new"]

#define Service_TVsvPicArray @[@"组合套餐订购",@"专业单频道订购",@"专业频道包订购",@"点播订购",@"测试产品类型",@"test",@"ttt"]
#define Service_BroadsvPicArray @[@"tao_a",@"tao_b",@"tao_c",@"tao_d"]

#define Tip_AddressInfo @[@"省市",@"区县",@"街道",@"详细地址"]
#define CityArray @[@"北京市",@"上海市",@"成都市",@"杭州市",@"郑州市",@"武汉市"]
#define Control_Array @[@"数字键",@"功能键",@"频道"]

#define picNameVideoDetail @[@"缓存",@"分享",@"电视播放"]
#define titleNameVideoDetail @[@"缓存",@"分享",@"电视播放"]



#pragma mark - 提示框中内容 -
//^^^^^^提示框中内容^^^^^^^^^^^^^^^^^^^
//手机号码相关
#define Tip_PhoneWrite @"请输入手机号"
#define Tip_PhoneWrong @"手机号输入有误"
#define Tip_PhoneUnWrite @"尚未输入手机号"
//用户名相关
#define Tip_UserNameWrong @"用户名输入有误"
#define Tip_UserNameOcupy @"用户名已被使用"
#define Tip_UserNameUnWrite @"尚未输入用户名"
#define Tip_ResetUserNameWrite @"请输入用户名"
#define Tip_UserNameWrite @"请输入用户名(由4-18位的数字、字母或下划线组成)"
//密码相关
#define Tip_ResetNewPwdWrong @"新密码输入有误"
#define Tip_PasswordLoadWrite @"请输入登录密码"
#define Tip_PasswordLoadWrong @"登录密码输入有误"
#define Tip_ResetNewPwdUnWrite @"尚未输入新密码"
#define Tip_ResetNewPassWordWrite @"请输入新密码"
#define Tip_PassWordWriteConfirm @"请再次输入密码"
#define Tip_PasswordLoadUnWrite @"尚未输入登录密码"
#define Tip_PassWordOriginWrong @"初始密码输入有误"
#define Tip_PassWordConfirWrong @"再次输入密码有误"
#define Tip_ResetConfirmPwdWrite @"请再次输入新密码"
#define Tip_PasswordOriginUnWrite @"尚未输入初始密码"
#define Tip_PasswordConfirmUnWrite @"尚未再次输入密码"
#define Tip_AgreeMentOfPassword @"两次输入的密码不一致"
#define Tip_PassWordWriteOrigin @"请输入初始密码（由6-18位不包含空格的字符组成)"
//昵称相关
#define Tip_NickNameWrong @"昵称输入有误"
#define Tip_NickNameWrite @"请输入昵称(由1-18位的任意字符组成)"


#define Tip_VideoPlayFailed @"无法在当前网络下播放，请切换到对应局域网播放"

#define Tip_AccountUnWrite @"尚未输入用户名或手机号"

#define Tip_AccountWriteWrong @"用户名或手机号输入有误"

#define Tip_AccountWrite @"请输入用户名或手机号"




#define Tip_VertifyWrite @"请输入验证码"

#define Tip_VsertyfyClick @"点击获取验证码"
#define Tip_AreaUnSelect @"请先选择区域"

#define Tip_AreaText @"请先选择区域(必选项)"

#define Tip_VertifySendSuccess @"验证码发送成功"

#define UnCompleted @"待完善"

#define UnChange @"尚未更改"

/**代表FinishVC跳转到详情页的标识**/
#define ComPleted @"完善"
/**代表MessageVC跳转到详情页面的标识**/
#define Devise @"修改"

#define IsNull @"kong"


#pragma mark - Http -
//^^^^^^^^^^^^^以下为Http^^^^^^^^^^^^^^^^
//广式测试平台
//#define GetLoadPreUrl @"http://111.13.30.152:1840/center/"

//长沙测试平台
//#define GetLoadPreUrl @"http://30.110.109.123:8080/center/"

//正式发布!!!
#define GetLoadPreUrl @"http://cen.phone.citicguoanbn.com:8080/center/"

//#define GetLoadPreUrl @"http://182.18.26.5:8087/center/"

//https ip测试
//#define GetLoadPreUrl @"https://182.18.26.5:21580/center/"

//https 域名测试
//#define GetLoadPreUrl @"https://www.bjone.com:21580/center/"

#define PreHttpCommon @"http://%@:%@/csapp/%@"

#define PreHttpImage @"http://%@:%@%@"

//GET请求
/**首页一级接口分类请求**/
#define GetFirstVideoAction @"PlayVideo/getFirstVideo"

/**查询全部频道信息**/
#define GetAllChannelInfo @"Channel/getAllChannelTitle"

/**获取营业厅信息**/
#define GetAllBusinssInfo @"Business/getBusinessHallInfo"

/**获取全部区域和全部区域服务器ip**/
#define GetAddressInfo @"User/getCAddressInfo"

//POST请求
/**首页二级接口**/
#define GetProgramByFirstVideoAction @"PlayVideo/getProgramByFirstVideoId"

/**二级分类更多**/
#define GetSecondVideoMore @"PlayVideo/getProgramInfoBySecondVideoId"

/**视频点播接口第一次**/
#define GetVideoPlayFirst @"PlayVideo/getProgramByProgramIdFirst"

/**视频点播接口第二次**/
#define GetSecondVideoPlay @"PlayVideo/getProgramByProgramIdAndEpisodesNumber"

/**保存用户播放记录**/
#define GetSavedHiesory @"PlayVideo/savePlayHistory"

/**预定节目推送**/
#define GetReserveJpush @"Channel/reserveChannel"

/**取消节目预定**/
#define GetCancelJpush @"Channel/cancelReserveChannel"

/**模糊查询，按照频道别名精确查询频道信息**/
#define GetFounctionSearch @"Channel/getChannelNameByAlias"

/**用户常用频道**/
#define GetCommonUseChannel @"Channel/getCommonChannelTitle"


/**搜索关键字查询信息**/
#define GetSearchKeyHttp @"PlayVideo/getProgramInfoAndYearsAndLeadByKey"

/**分页查询频道信息**/
#define GetChannelKey @"Channel/getChannelTitleByPage"

/**节目预告信息**/
#define GetForeCast @"Channel/getChannelInfoByChannelTitleId"

/**添加用户常用频道**/
#define GetAddCommonChannelInfo @"Channel/addCommonChannelTitle"

/**删除用户常用频道**/
#define GetDeleteCommonChannel @"Channel/deleteCommonChannelTitle"


/**营业厅，获取业务一级分类信息**/

#define GetFirstBusinessInfo @"Business/getBusinessInfo"

/**获取产品的信息**/
#define GetProductInfo @"Business/getProductInfo"

/**获取产品详细信息**/
#define GetProductDetailInfo @"Business/getProductInfoMore"

/**测试用户名是否被占用**/
#define GetTestUserName @"User/testUserName"

/**测试手机号是否被占用**/
#define GetTestPhoneNo @"User/testPhoneNo"

/**验证码**/
#define GetVertify @"User/getValidate"

/**注册**/
#define GetRegHttp @"User/OnlineRegister"

/**登陆**/
#define GetLoad @"User/getCustLoginInfo"

/**完善个人信息**/
#define GetCompletePersonInfo @"User/updateUserPerfect"

/**更改密码**/
#define GetPasswdDevise @"User/modifyPasswd"

/**找回密码**/
#define GetFindPassword @"User/resetPasswd"

/**忘记密码测试手机号和用户名是否一致**/
#define GetPhoneAndUser @"User/testPhoneNoAndUserName"

/**头像上传**/
#define GetUpLoadImage @"User/updatePicture"
/**修改手机号**/
#define GetDevisePhoneNo @"User/modifyPhoneNo"

/**免责声明**/
#define GetStatement @"Version/getDisclaimer"
/**版本信息**/
#define GetVersionInfo @"Version/getIOSVersionInfo"

#define GetAreaStreet @"CustMgt/getAreaStreet"





#pragma mark - 图片名称 -
//^^^^^^^^^以下为图片名称^^^^^^^^^^^^^^^^^
/*占位图*/
#define MAX_IMAGE @"vtv_Video"
#define MIN_IMAGE @"vtv_live"

/*注册页面图片*/
#define Image_Wrong @"icon_wrong"
#define Image_Right @"icon_right"

#define Image_up @"排序朝上"
#define Image_down @"排序朝下"
#define Img_PackUp @"up"
#define Img_Expand @"down"


//设置超时时间
#define TimeOutInterval 15


#define AlertStateView_Msg @"网络出错，请检查网络连接"
#define AlertStateView_NoData @"暂无数据"

#define AlertVersion_BgColor HEXCOLOR(0xFFFFFB)

#endif
