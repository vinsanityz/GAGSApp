//
//  MyTabbarViewController.m
//  GuangzhouApp
//
//  Created by wy on 15/4/27.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "MyTabbarViewController.h"
#import <AutoCoding.h>
#import "ParamFile.h"
#import "SingleColor.h"
#import "CommonCtr.h"


@implementation MyTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeMyTabbar];
    
    
}


//创建tabBar
- (void) makeMyTabbar
{
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TabbarConfig" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *viewControllersArr = [NSMutableArray array];
    
    [dataArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        //获取字典中的键值
        NSString *className = [obj objectForKey:@"name"];
        //将类名转化为对应的类
        className = [className stringByAppendingString:@"ViewController"];
        Class class = NSClassFromString(className);
        if (!class) {
            *stop = YES;
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[class alloc] init]];
        [viewControllersArr addObject:nav];

#warning todo 未添加图片
        nav.title = [obj objectForKey:@"title"];
        nav.tabBarItem = [self createTabBarItem:[obj objectForKey:@"title"] image:[NSString stringWithFormat:@"tab_%ld",(unsigned long)idx] selectedImage:[NSString stringWithFormat:@"tab_%ld_select",(unsigned long)idx]];
    }];
    //设置颜色
    single = [SingleColor sharedInstance];
    [self SetTabbarColor];
    self.viewControllers = viewControllersArr;

    //不将标签栏设置为透明的
    [self.tabBar setTranslucent:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetTabbarColor) name:ColorNoti object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)SetTabbarColor
{
    if ([CommonCtr restore] == NULL) {
        single.colorDic = WhiteDic;
        single.fontDic = NORMALDic;
        single.fontSize = FONTSIZE_MIDDLE;
        single.colorEdition = WHITE_EDITION;
        single.fontEdition = NORMAL_EDITION;
        [CommonCtr saveColor:single];
    }else
    {
        single = [CommonCtr restore];
    }

    UIColor *TextColor = [single.colorDic objectForKey:FONT_TABBAR_COLOR];
    NSLog(@"color is %@ ",[single.colorDic objectForKey:TABBARCOLOR]);
    self.tabBar.barTintColor = [single.colorDic objectForKey:TABBARCOLOR];
     UIColor *selTextColor = HIGHLIGHTED_COLOR ;
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName : selTextColor}
      forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName : TextColor}forState:UIControlStateNormal];

}
/**
 *  tabbarItem 定义
 *  @param title      标题
 *  @param imgPath    图片
 *  @param selImgPath 选择图片
 *  @return 返回tarbarItem
 */
- (UITabBarItem *) createTabBarItem:(NSString *)title image:(NSString *)imgPath selectedImage:(NSString *)selImgPath {
    
    UIImage *img1 = [UIImage imageNamed:imgPath];
    UIImage *img2 = [UIImage imageNamed:selImgPath];
    //使用原生图片，UITabBarItem不要擅自处理图片。
    img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *t = [[UITabBarItem alloc] initWithTitle:title image:img1 selectedImage:img2];
    return t;
}

@end
