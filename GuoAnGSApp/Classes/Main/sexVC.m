//
//  sexVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/9/17.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "sexVC.h"

#import "HJSTKToastView.h"

@interface sexVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *locationGender;//本地保存的性别，用来临时修改点击后的选中状态
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSArray *array;

@end


@implementation sexVC

-(UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, ScreenSizeWidth, ScreenSizeHeigh) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavLeft_title];
    [self setNavRight_title];
    self.titleMessage = @"性别";
    self.array = @[@"男",@"女"];
    
    [_backSuperView addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    NSLog(@"genderStr:%@",self.gengderStr);
    
    if ([self.identifier isEqualToString:Devise]) {
        //读取本地保存的数值
        locationGender = kPermanent_GET_OBJECT(kGetGender);
    }else{
        locationGender = self.gengderStr;
    }
    NSLog(@"%@",locationGender);
}


-(void)saveRight{
    if ([self.identifier isEqualToString:Devise]) {
        NSLog(@"保存到服务器");
        //如果本地保存的和已读取的不同,则修改本地保存的数据
        if (![locationGender isEqualToString:kPermanent_GET_OBJECT(kGetGender)]) {
            NSLog(@"在这里把修改的数据上传到服务器，修改的数据为：%@", locationGender);
            [self requestDevisePersonInfoForPersonUserName:kPermanent_GET_OBJECT(KGetUserName) nickName:nil birthday:nil gender:locationGender address:nil];
        }else{
            [HJSTKToastView addPopString:UnChange];
        }
    }else{
        if (self.genderBlock) {
            self.genderBlock(locationGender);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - <UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _array[indexPath.row];
    cell.backgroundColor = [single .colorDic objectForKey:BACK_CONTROL_COLOR];
    cell.textLabel.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
    cell.textLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    //根据本地保存的值，修改点击后的选中状态
    if ([locationGender isEqualToString:_array[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  如果点击的是已选中的行，不执行操作，不是已选中的行，则修改本地存储的值，刷新界面。
     */
        if (![locationGender isEqualToString:self.array[indexPath.row]]) {
            //修改点击后变量locationGender所存的值
            locationGender = self.array[indexPath.row];
            [self.tableView reloadData];
        }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LiveCellHeigh;
}

@end
