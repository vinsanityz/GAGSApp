//
//  BirthVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/11/16.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "BirthVC.h"

@interface BirthVC ()<ZHPickViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)ZHPickView *pickview;

@end


@implementation BirthVC

-(UITableView *)tableView {
    if (!_tableView) {
        //减44(让视图刚好显示在tabbar的上面)
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenSizeWidth,ScreenSizeHeigh-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //隐藏竖直方向的滑动条
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


-(UILabel *)label {
    if (!_label) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenSizeWidth, 50)];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.userInteractionEnabled = YES;
        if (self.birthStr == nil) {
            _label.text = @"请选择生日";
            self.label.textColor = [single.colorDic objectForKey:FONT_SEC_COLOR];
        }else{
            _label.text = self.birthStr;
            self.label.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        }
        self.label.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE]intValue]];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(birthShow)];
        [_label addGestureRecognizer:tap];
        NSDate *currentDate = [NSDate date];
        /**UIDatePickerModeDate代表展示年月日**/
        if (_pickview == nil) {
            self.pickview = [[ZHPickView alloc]initDatePickWithDate:currentDate datePickerMode:UIDatePickerModeDate];
            _pickview.delegate = self;
            /*
             pickerView的默认高度
             横向：320 * 216
             纵向：480 * 162
             */
            _pickview.frame = CGRectMake(0, ScreenSizeHeigh - 230, ScreenSizeWidth, 230);
        }
    }
    return _label;
}


-(void)birthShow {
    [_pickview show];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleMessage = @"生日";
    [self setNavLeft_title];
    [self setNavRight_title];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_backSuperView addSubview:self.tableView];
    
    UITapGestureRecognizer *birthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(birthPickAction)];
    [_backSuperView addGestureRecognizer:birthTap];
}


-(void)birthPickAction{
    if (_pickview != nil) {
        [_pickview removeFromSuperview];
    }
}


-(void)saveRight {
    if ([self.identifier isEqualToString:Devise]) {
    if (![kPermanent_GET_OBJECT(KGetBirth) isEqualToString:self.label.text]) {
            [self requestDevisePersonInfoForPersonUserName:kPermanent_GET_OBJECT(KGetUserName) nickName:nil birthday:self.label.text gender:nil address:nil];
        }else{
            [HJSTKToastView addPopString:UnChange];
        }
    }else{
        if (self.returnText) {
            self.returnText(self.label.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    if (_pickview != nil) {
        [_pickview removeFromSuperview];
    }
}


#pragma mark - <ZhpickVIewDelegate,pickerView确定按钮>
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    self.label.text = resultString;
    self.label.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
}


#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
       [cell.contentView addSubview:self.label];
    cell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    return cell;
}


#pragma mark - <UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return commonCellHigh;
}

@end
