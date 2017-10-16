
//  ChooseAddressVC.m
//  CS_WeiTV
//
//  Created by Nina on 16/4/20.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "ChooseAddressVC.h"

#import "RegVC.h"
//#import "loginAndRegViewController.h"
#import "AddressInfoModel.h"

@interface ChooseAddressVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIButton *chooseBtn;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) AddressInfoModel *modle;
@property(nonatomic,strong) UITableView *tableView;

@end


@implementation ChooseAddressVC

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenSizeWidth, ScreenSizeHeigh-64) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showLeft = YES;
    self.titleMessage = @"注册";
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.dataSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    
//    [self requestAddressInfoNetWorking];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.modle = self.dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
    cell.textLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] floatValue]];
//    cell.textLabel.text = self.modle.cAdderss;
        cell.textLabel.text = self.dataSource[indexPath.row];
    cell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LiveCellHeigh;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.modle = self.dataSource[indexPath.row];
    /**保存对应区域的ip及端口号*/
    kPermanent_SET_OBJECT(self.modle.ip, KGetIP);
    kPermanent_SET_OBJECT(self.modle.port, KGetPort);
    RegVC *reg = [[RegVC alloc]init];
    reg.CAddrss = self.dataSource[indexPath.row];
    reg.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reg animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataSource.count > 0) {
        return 33;
    }else{
        return 0.1;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataSource.count > 0 ) {
        UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, 33)];
       sectionLabel.backgroundColor = [single.colorDic objectForKey:BACK_SUPER_COlOR];
        sectionLabel.textAlignment = NSTextAlignmentCenter;
        sectionLabel.textColor = [single.colorDic objectForKey:FONT_SEC_COLOR];
        sectionLabel.text = @"请选择你所在的城市(注册成功后不可更改)";
        return sectionLabel;
    }else{
        return nil;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)requestOnceMoreNetWorking {
    [self requestAddressInfoNetWorking];
}


#pragma mark - <地址信息网络请求页>
-(void)requestAddressInfoNetWorking
{
    [self showMBProgressHud];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",GetLoadPreUrl,GetAddressInfo];
    NSLog(@"获取地址urlOfAddress:%@",url);
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSLog(@"所有地址信息：%@",responseObject);
        self.dataSource = [NSMutableArray array];
        NSArray *array = responseObject;
        for (NSDictionary *dict in array) {
            self.modle = [AddressInfoModel itemAddressInfoWithDictionary:dict];
            [self.dataSource addObject:self.modle];
        }
        if (self.dataSource.count > 0) {
            [self removeAlertStateView];
        }else{
            [self createAlertStateViewHeight:0 msg:messageIsNULL];
        }
        [self.tableView reloadData];
        [self hideMBProgressHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"%@",error);
        [HJSTKToastView addPopString:error.localizedDescription];
        [self createAlertStateViewHeight:0 msg:error.localizedDescription];
        [self hideMBProgressHud];
    }];
}

@end
