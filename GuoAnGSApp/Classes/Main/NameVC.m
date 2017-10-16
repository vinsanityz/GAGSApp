//
//  NameVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/8/26.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "NameVC.h"

#import "LoadReturnModel.h"

@interface NameVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end


@implementation NameVC

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenSizeWidth,ScreenSizeHeigh-64 ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //隐藏竖直方向的滑动条
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


-(UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0,ScreenSizeWidth-10,commonCellHigh)];
        //输入框中的删除按钮,用于一次性删除输入框中的内容
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        UIColor *color = [single.colorDic objectForKey:FONT_SEC_COLOR];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Tip_NickNameWrite attributes:@{NSForegroundColorAttributeName:color}];
        _textField.text = self.nameStr;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
    }
    return _textField;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavLeft_title];
    [self setNavRight_title];
    self.titleMessage = @"昵称";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_backSuperView addSubview:self.tableView];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameAction)];
    [_backSuperView addGestureRecognizer:nameTap];
}


#pragma mark - 取消第一响应 -
-(void)nameAction
{
    [self.textField resignFirstResponder];
}


#pragma mark - 右侧保存按钮 -
//保存按钮对应的响应方法----如果本地不存在此数值，则修改本地存储的值，刷新界面
-(void)saveRight {
    //去掉字符串中首尾的空格
   self.textField.text = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.textField.text.length > 0 && self.textField.text.length < 19) {
        if ([self.identifier isEqualToString:Devise]) {
            if (![kPermanent_GET_OBJECT(kGetName) isEqualToString:self.textField.text]) {
                //修改昵称网络请求
                [self requestDevisePersonInfoForPersonUserName:kPermanent_GET_OBJECT(KGetUserName) nickName:self.textField.text birthday:nil gender:nil address:nil];
            }else{
                [HJSTKToastView addPopString:UnChange];
            }
        }else{
            NSLog(@"完善资料");            
            if (self.passingValue) {
                self.passingValue(self.textField);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [HJSTKToastView addPopString:Tip_NickNameWrong];
    }
}


#pragma mark - UITableViewDataSource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    self.textField.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
    self.textField.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE]intValue]];
    [cell.contentView addSubview:self.textField];
    return cell;
}


#pragma mark - UITableViewDelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return commonCellHigh;
}

@end
