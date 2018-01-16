//
//  SetVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/8/19.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#define CellLeftLabelArray @[@"字体大小",@"背景颜色",@"网络提醒",@"清除缓存"]
#define FontArray @[@"小",@"正常",@"大"]
#define ColorArray @[@"简约白",@"酷爽黑",@"气质蓝"]

#import "SetVC.h"

#import "ZCZPickView.h"
#import "NSString+calculate.h"

#import "My_ReuseCllTableViewCell.h"

@interface SetVC ()<UITableViewDataSource,UITableViewDelegate,ZCZPickViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong) NSArray *fontArray;

//方法二
@property (nonatomic,strong) ZCZPickView *fontPickView;
@property (nonatomic,strong) ZCZPickView *colorPickView;

@property(nonatomic,strong) UILabel *headerLabel;

@property(nonatomic,strong) NSIndexPath *indexPathSet;

@end

@implementation SetVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showLeft = YES;

//    self.fontArray = [NSMutableArray arrayWithObjects:@"小",@"正常",@"大", nil];
//    self.colorArray = [NSMutableArray arrayWithObjects:@"简约白",@"酷爽黑",@"气质蓝", nil];
    [self setUpSubviewsAndGesture];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(colorSetChange) name:ColorNoti object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeTextFontAction:) name:FontNoti object:nil];
}

-(UILabel *)headerLabel
{
    if (_headerLabel==nil) {
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.frame = CGRectMake((ScreenSizeWidth - 120) / 2, 2, 120, 40);
        _headerLabel.text = @"常规设置";
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.textColor = [single.colorDic objectForKey:FONT_NAV_MAIN_COLOR];
        _headerLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    }
    return _headerLabel;
}

-(UITableView *)tableView
{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenSizeWidth , ScreenSizeHeigh-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
        [_tableView registerClass:[My_ReuseCllTableViewCell class] forCellReuseIdentifier:NSStringFromClass([My_ReuseCllTableViewCell class])];

    }
    return _tableView;
}

- (void)setUpSubviewsAndGesture
{
    UITapGestureRecognizer *setTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePickViewAction)];
    setTap.delegate = self;
    //    setTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:setTap];
    self.navigationItem.titleView = self.headerLabel;
    [self.view addSubview:self.tableView];
   
  
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)removePickViewAction {
    if (_colorPickView != nil) {
        [_colorPickView removeFromSuperview];
    }
    if (_fontPickView != nil) {
        [_fontPickView removeFromSuperview];
    }
}


- (void)colorSetChange {
    [self.tableView reloadData];
    self.tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
    _headerLabel.textColor = [single.colorDic objectForKey:FONT_NAV_MAIN_COLOR];

    
}


- (void)handleChangeTextFontAction:(NSNotificationCenter *)notification {
    [self.tableView reloadData];
    _headerLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE]intValue]];
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removePickViewAction];

}




#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return CellLeftLabelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    My_ReuseCllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([My_ReuseCllTableViewCell class]) forIndexPath:indexPath];
    //---------------设置字体颜色及大小---------------
    cell.leftLabel.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
    cell.leftLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    cell.rightLabel.textColor = [single.colorDic objectForKey:FONT_SEC_COLOR];
    cell.rightLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE] intValue]];
    cell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    //------------------------------------------------------
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.leftLabel.text = CellLeftLabelArray[indexPath.row];
    //设置右侧label中的内容
    if (indexPath.row == 0) {
        
        cell.rightLabel.text = single.fontEdition;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1) {
        
        //设置右侧label中的内容
        cell.rightLabel.text = single.colorEdition;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2){
        
        UISwitch *switchBtn = [[UISwitch alloc] init];
        switchBtn.backgroundColor = [UIColor clearColor];
        [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if (kPermanent_GET_BOOL(KGetSWitch)) {
            [switchBtn setOn:YES animated:YES];
        } else {
            [switchBtn setOn:NO animated:YES];
        }
        cell.accessoryView = switchBtn;
    }else {
      //计算缓存
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSInteger size = [caches fileSizeCalculate];
        if (size <1024) {
            cell.rightLabel.text = [NSString stringWithFormat:@"%0.1fB",(float)size];
            
        }else if (1024 < size && size < 1024 * 1024){
            cell.rightLabel.text = [NSString stringWithFormat:@"%0.2fKB",(float)size/1024];
        }else{
            cell.rightLabel.text = [NSString stringWithFormat:@"%0.3fMB",(float)size/(1024*1024)];
        }
    }
    return cell;
}

-(ZCZPickView *)fontPickView
{
    if (_fontPickView==nil) {
        _fontPickView = [[ZCZPickView alloc]initSinglePickerWithArray:FontArray];
        _fontPickView.frame = CGRectMake(0, ScreenSizeHeigh - 200, ScreenSizeWidth, 200);
        _fontPickView.delegate = self;
    }
    return _fontPickView;
}
-(ZCZPickView *)colorPickView
{
    if (_colorPickView==nil) {
        _colorPickView = [[ZCZPickView alloc] initSinglePickerWithArray:ColorArray];
        _colorPickView.frame = CGRectMake(0, ScreenSizeHeigh - 200, ScreenSizeWidth, 200);
        _colorPickView.delegate = self;
    }
    return _colorPickView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPathSet = indexPath;
    switch (indexPath.row) {
        case 0:
        {
            [self.view addSubview:self.fontPickView];
            if ([self.colorPickView superview]!=nil) {
                [self.colorPickView removeFromSuperview];
            }
        }
            break;
         case 1:
        {
            [self.view addSubview:self.colorPickView];
            if ([self.fontPickView superview]!=nil) {
                [self.fontPickView removeFromSuperview];
            }
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            [self cleanCacheAction];
            if ([self.fontPickView superview]!=nil) {
                [self.fontPickView removeFromSuperview];
            }
            if ([self.colorPickView superview]!=nil) {
                [self.colorPickView removeFromSuperview];
            }
            
        }
            break;
        default:
            break;
    }
}

//清除缓存
-(void)cleanCacheAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSLog(@"former:%ld",(long)[caches fileSizeCalculate]);
            [mgr removeItemAtPath:caches error:nil];
        NSLog(@"deleate:%ld",(long)[caches fileSizeCalculate]);
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPathSet] withRowAnimation:UITableViewRowAnimationNone];//刷新指定单元格
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//开关的点击事件
-(void)switchAction:(UISwitch *)switchButton {
    if ([self.fontPickView superview]!=nil) {
        [self.fontPickView removeFromSuperview];
    }
    if ([self.colorPickView superview]!=nil) {
        [self.colorPickView removeFromSuperview];
    }
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        //确定要切换为在3G/4G网络下播放或缓存视频？
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"3G/4G网络下播放视频时弹框提醒" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
            [switchButton setOn:NO animated:YES];
            kPermanent_SET_BOOL(NO, KGetSWitch);
        }];
        [alertController addAction:cancelAction];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            kPermanent_SET_BOOL(YES, KGetSWitch);
        }];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        kPermanent_SET_BOOL(NO, KGetSWitch);
    }
}

#pragma mark - <UITableViewDelegate>

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return mlrHeight;
}


#pragma mark - <ZCZpickVIewDelegate>
-(void)headerBarDoneBtnCilck:(ZCZPickView *)pickView WithFinalString:(NSString * )resultString
{
//    NSLog(@"%ld",(long)self.indexPathSet.row);
    My_ReuseCllTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPathSet];
    //字体大小cell
    if (self.indexPathSet.row == 0) {
        cell.rightLabel.text = resultString;
        if (![cell.rightLabel.text isEqualToString:single.fontEdition] ) {
            if ([resultString isEqualToString:SMALL_EDITION]) {
                single.fontDic = SMALLDic;
                single.fontEdition = SMALL_EDITION;
                [CommonCtr saveColor:single];
            }else if ([resultString isEqualToString:NORMAL_EDITION]){
                single.fontDic = NORMALDic;
                single.fontEdition = NORMAL_EDITION;
                [CommonCtr saveColor:single];
            }else if ([resultString isEqualToString:BIG_EDITION]){
                single.fontDic  = BIGDic;
                single.fontEdition = BIG_EDITION;
                [CommonCtr saveColor:single];
            }
        }
       [[NSNotificationCenter defaultCenter]postNotificationName:FontNoti object:nil];
    }else if (self.indexPathSet.row == 1){
       cell.rightLabel.text = resultString;
        
        if (![resultString isEqualToString:single.colorEdition]) {
            if ([resultString isEqualToString:WHITE_EDITION]) {
                single.colorDic = WhiteDic;
                single.colorEdition = WHITE_EDITION;
                [CommonCtr saveColor:single];
            }else if ([resultString isEqualToString:BLACK_EDITION]){
                single.colorDic = BLACKDic;
                single.colorEdition = BLACK_EDITION;
                [CommonCtr saveColor:single];
            }else if ([resultString isEqualToString:BLUE_EDITION]){
                single.colorDic = BLUEDic;
                single.colorEdition = BLUE_EDITION;
                [CommonCtr saveColor:single];
            }
        }
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:ColorNoti object:nil];
    }
}

//防止点按手势与tableview pickerView的点击事件出现冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view  isMemberOfClass:[UITableView class]]){
//        NSLog(@"%@",NSStringFromClass([touch.view class]));
        return YES;
    }else{
//        NSLog(@"%@",NSStringFromClass([touch.view class]));
        return NO;
    }
}

@end
