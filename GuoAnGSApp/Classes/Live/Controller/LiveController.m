//
//  LiveController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "LiveController.h"

#import "ZCZTipsView.h"
#import "EPGRightTableViewCell.h"
#import "ZCZMoviePlayerController.h"

#import "LiveChannelModel.h"

#import <MJRefresh.h>
#import <MJExtension.h>
#import <SDWebImageManager.h>

@interface LiveController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
//请求数据的页码
@property(nonatomic,assign)NSUInteger channelPage;
//tableView数据源
@property(nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation LiveController

-(BOOL)shouldAutorotate
{
    return  NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationItemAndTitle];
    [self.view addSubview:self.tableView];
    //第一次网络请求
    [self firstNetworkRequest];
    //设置上拉加载下拉刷新
    [self setUpMJRefresh];
}

-(void)setUpNavigationItemAndTitle
{
    self.titleMessage = @"直播";
    [self setNavRightArr:@[@"屏幕快照 2017-10-17 下午2.15.37",@"屏幕快照 2017-10-17 下午2.15.50"]];
}

-(void)firstNetworkRequest
{
    //无网加载缓存
    if (_netWorkReachability.CSReachabilityStatus==NotReachable) {
        NSMutableArray * tempArray = [NSMutableArray array];
        tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self returnDocumentPath:FKGetLive]];
        if (tempArray == nil) {
            NSLog(@"Live缓存尚不存在");
            if (self.stateView) {
                [self removeAlertStateView];
            }
            [self createAlertStateViewHeight:0 msg:AlertStateView_NoData];
        }else{
            NSLog(@"Live缓存已存在");
            self.dataSource =tempArray;
            [self.tableView reloadData];
        }
    }else{
        self.channelPage = 1;
        [self requestSearchChannelMessage:self.channelPage];
    }
}

#pragma mark - <MJRefresh相关代码>
-(void)setUpMJRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
//下拉刷新
-(void)loadNewData
{
    self.channelPage = 1;
    [self requestSearchChannelMessage:self.channelPage];
}
//上拉加载
-(void)loadMoreData
{
     [self requestSearchChannelMessage:++self.channelPage];
}

#pragma mark - <懒加载>
-(NSMutableArray *)dataSource
{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView *)tableView
{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:@"EPGRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPGRightTableViewCell"];
        //设置header
        _tableView.tableHeaderView =[[[NSBundle mainBundle]loadNibNamed:@"tableViewHeaderView" owner:nil options:nil]lastObject];
    }
    return _tableView;
}

-(void)headerViewbtnClick:(UIButton *)btn
{
    NSLog(@"clickbtntbtntbtntbtn");
    ZCZMoviePlayerController * vc = [[ZCZMoviePlayerController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//-(void)setUpLeftView{
//    UIView * leftView = [[UIView alloc]init];
//    leftView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:leftView];
//    leftView.frame = CGRectMake(0, 64, 100, 600);
//
//    for (int i = 0;i<self.leftViewArray.count;i++) {
//
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:self.leftViewArray[i] forState:UIControlStateNormal];
//        btn.tag = i;
//        [btn setBackgroundColor:[UIColor blueColor]];
//
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
//        btn.frame = CGRectMake(0, i*100, leftView.frame.size.width, 80);
//        [btn addTarget:self action:@selector(leftViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [leftView addSubview:btn];
//    }
//}
//-(void)setUpRightView{
//    UITableView * tableV = [[UITableView alloc]initWithFrame:CGRectMake(110, 64, 250, 500)];
//    self.rightTableView = tableV;
//    tableV.delegate =self;
//    tableV.dataSource = self;
//    [self.view addSubview:tableV];
//    tableV.rowHeight = 79;
//    [self.rightTableView registerNib:[UINib nibWithNibName:@"EPGRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPGRightTableViewCell"];
//}
#pragma mark - <UITableViewDataSource>
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

#pragma mark - <UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCZMoviePlayerController * vc = [[ZCZMoviePlayerController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EPGRightTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EPGRightTableViewCell" forIndexPath:indexPath ];
//    cell.LabelView = [ZCZLabel showWithTitle:@"adsfhsjlfhdsjklfhldsflflhahl老实交代划分了的接口放到数据库绿肥红瘦类库的方式肯定放三德科技理发师勒紧裤带发货速度接口方式了接口后来看是点击返回了说地方"];
    if (self.dataSource.count==0) {
        return cell;
    }
    
    LiveChannelModel * model =self.dataSource[indexPath.row];
    cell.titleLabel.text = model.channelTitle;
    
    NSString *imageUrl = [NSString stringWithFormat:PreHttpImage,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),model.channelPostUrl];

    [cell.zcz_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loginpic"]];
    
//    cell.LabelView.font = [UIFont systemFontOfSize:13    ];
//    cell.LabelView.textColor = [UIColor redColor];
//    cell.LabelView.textAlignment = 0;
//    cell.LabelView.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.LabelView.numberOfLines = 0;
//    cell.LabelView.text = @"12hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123122hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123122hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123122hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123123";
//
//    NSAttributedString *text = [[NSAttributedString alloc]initWithString:cell.LabelView.text];
//    
//    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(240, CGFLOAT_MAX) options:options context:nil];
//    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
//    
//    CGSize size = CGSizeMake(240, CGFLOAT_MAX);
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
//    layout.textBoundingRect; // get bounding rect
//    layout.textBoundingSize;
//    NSLog(@"size:%@", NSStringFromCGSize(layout.textBoundingSize));
//    cell.LabelView.frame =layout.textBoundingRect;
//    cell.titleLabel.text = self.str;
    return cell;
}
//    NSAttributedString *st =

//    CGSize maxSize = CGSizeMake(74, MAXFLOAT);
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:st];
//    cell.LabelView.textLayout = layout;
//    CGFloat introHeight = layout.textBoundingSize.height;
//
//    cell.LabelView.frame = CGRectMake(0, 0, maxSize.width, introHeight);

//    cell.LabelView.width = maxSize.width;
//    cell.LabelView.frame.size. = introHeight + 50;
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"skjhjkxccxvhzljkcxvh"];
//
//    // 2. 为文本设置属性
//    text.yy_font = [UIFont boldSystemFontOfSize:13];
//    text.yy_color = [UIColor blueColor];
//    [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
//    text.yy_lineSpacing = 10;
//
//    // 3. 赋值到 YYLabel 或 YYTextView
//
//    //    label.attributedString = text;
//    label.attributedText = text;



//-(void)leftViewBtnClick:(UIButton *)btn
//{
//    self.selBtn.selected = !self.selBtn.selected;
//    self.str = [btn currentTitle];
//    [self.rightTableView reloadData];
//    btn.selected = !btn.selected;
//    self.selBtn = btn;
//    ZCZMoviePlayerController * zcz = [[ZCZMoviePlayerController alloc]init];
////    [UIApplication sharedApplication].keyWindow.rootViewController = zcz;
//
//    zcz.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:zcz animated:YES];
//
//}


#pragma mark - <分页查询频道信息网络请求>
-(void)requestSearchChannelMessage:(NSInteger)currentPage
{
    [self showMBProgressHud];
    NSString *pageNmuber = [NSString stringWithFormat:@"%ld",currentPage];
//    NSLog(@"pageNumber:%@",pageNmuber);
    NSDictionary *params = [NSDictionary dictionaryWithObject:pageNmuber forKey:@"currentPage"];
    
    [LYNetworkManager POST:GetChannelKey parameters:params successBlock:^(NSURLSessionDataTask *task, id responseObject)
     {
//         NSLog(@"channelResponse:%@",responseObject);
         NSArray *channelArray = responseObject;
         //传入的页码为1时,重新加载数据，清除dataSource的数据
         if ([pageNmuber isEqualToString:@"1"]&&self.dataSource.count >0) {
                 [self.dataSource removeAllObjects];
         }
         //如果返回的数据为空并且页码大于1,页码需要自减1,弹窗提示无数据
         if (channelArray.count == 0) {
             if (![pageNmuber isEqualToString:@"1"]) {
                 --self.channelPage;
             }
             [ZCZTipsView showWithString:NoMoreMessage];
         }else{
         for (NSDictionary *dict in channelArray) {
//             NSLog(@"channelPostUrl:%@",[dict objectForKey:@"channelPostUrl"]);
//             NSLog(@"channelTitle:%@",[dict objectForKey:@"channelTitle"]);
//             NSLog(@"channelTitleId:%@",[dict objectForKey:@"channelTitleId"]);
             LiveChannelModel * model = [LiveChannelModel mj_objectWithKeyValues:dict];
             [self.dataSource addObject:model];
//             NSLog(@"%@",model);
            }
         }
         //警示View的相关操作
         if (self.dataSource.count > 0  ) {
             [self removeAlertStateView];
             /**将缓存写入文件**/
//             self.cacheArray = [NSMutableArray arrayWithArray:self.dataSource];
             NSString *filePath = [self returnDocumentPath:FKGetLive];
             if ([NSKeyedArchiver archiveRootObject:self.dataSource toFile:filePath]) {
                 NSLog(@"LiveVC缓存写入成功");
             }else{
                 NSLog(@"LiveVC缓存写入失败");
             }
         }else if (self.dataSource.count == 0){
             if (self.stateView) {
                 [self removeAlertStateView];
             }
             [self createAlertStateViewHeight:0 msg:AlertStateView_NoData];
         }
//         NSLog(@"dataSource:%@,%ld",self.dataSource,(unsigned long)self.dataSource.count);

         [self.tableView reloadData];//刷新
         [self hideMBProgressHud];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
         if (![pageNmuber isEqualToString:@"1"]) {
             --self.channelPage;
         }
         if (self.dataSource.count == 0) {
             if (self.stateView) {
                 [self removeAlertStateView];
             }
             [self createAlertStateViewHeight:0 msg:error.localizedDescription];
         }
         [self hideMBProgressHud];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];
}

#pragma mark - <警示框代理>
-(void)requestOnceMoreNetWorking
{   self.channelPage = 1;
    [self requestSearchChannelMessage:self.channelPage];
}

@end
