//
//  SearchController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/6.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "SearchController.h"
#import "SearchResultsTableViewCell.h"
#import "HistoryCollectionViewCell.h"
#import "HistoryCollectionReusableView.h"
#import "ZCZTipsView.h"

static NSString * const reuseIdentifierForSearch =@"searchResults";

@interface SearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HistoryCollectionReusableViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger nShowPage;
    UIButton *moreBtn;
}
//TableView数据源
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITextField *textFieldSearch;
//显示搜索后的数据
@property (nonatomic, nonnull,strong) UITableView *tableView;
//历史记录数组
@property (nonatomic,strong) NSMutableArray *dataList;
/** 保存搜索按钮点击状态
 *  NO :代表历史记录页
 *  YES :代表搜索页
 */
@property (nonatomic, assign) BOOL searchBtnClicked;
//搜索记录
@property(nonatomic,strong)UICollectionView * collectionView;

@end

@implementation SearchController
-(BOOL)shouldAutorotate
{
    return  NO;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, ScreenSizeWidth, ScreenSizeHeigh-64) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.allowsSelection = NO;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
            [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultsTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierForSearch];
        self.tableView.hidden=YES;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置nav上的View
    [self createSearchNaviUI];
    //添加搜索结果的TableView
    [_backSuperView addSubview:self.tableView];
    //读取搜索记录数组
    [self readSearchDataList];
    //设置搜索记录的collectionView
    [self setUpCollectionView];
}

//没用
-(void)createFooter
{
    UIView *moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, 45)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, 1)];
    lineView.backgroundColor = [single.colorDic objectForKey:LINECOLOR];
    [moreView addSubview:lineView];
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0,1,self.view.frame.size.width, 44);
    [moreBtn addTarget:self action:@selector(handleMoreSearchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[single.colorDic objectForKey:FONT_MAIN_COLOR] forState:UIControlStateNormal];
    moreBtn.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    [moreView addSubview:moreBtn];
    self.tableView.tableFooterView = moreView;
    self.tableView.tableFooterView.hidden = YES;
}

-(void)readSearchDataList
{
    NSString *arrayPath = [self returnDocumentPath:@"historyArrayPath.plist"];
    NSLog(@"%@",arrayPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:arrayPath]) {
        //根据指定的文件路径、内容创建文件
        [fileManager createFileAtPath:arrayPath contents:nil attributes:nil];
    }
    //获取文件路径中的数据存放到数组中
    self.dataList = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:arrayPath]];
    NSLog(@"%lu--%@",(unsigned long)self.dataList.count,self.dataList);
}


#pragma mark - <加载更多按钮响应方法>
-(void)handleMoreSearchBtnAction
{
    [self requestSearchNetWorking:self.textFieldSearch.text currentPage:++nShowPage];
}

#pragma mark - <导航条布局>
-(void)createSearchNaviUI
{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40 , 40);
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回键"] forState:UIControlStateNormal];
    backBtn.backgroundColor = [UIColor greenColor];
//    [backBtn setTitle:@"<<" forState:UIControlStateNormal];
//    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:self action:@selector(searchBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView * vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [vc addSubview:backBtn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = -20;  //偏移距离  -向左偏移, +向右偏移
    self.navigationItem.leftBarButtonItems = @[space, [[UIBarButtonItem alloc] initWithCustomView:vc]];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//
//    self.navigationItem.leftBarButtonItem = backItem;
    
    //搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(ScreenSizeWidth-50-15, 5, 50, 34);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:HIGHLIGHTED_COLOR forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(handleSearchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    //搜索框
    self.textFieldSearch = [[UITextField alloc] initWithFrame:CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 15 , 5, ScreenSizeWidth-searchBtn.frame.size.width - 30-backBtn.frame.size.width-30, 34)];
    _textFieldSearch.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldSearch.placeholder = @"请输入视频";
    _textFieldSearch.returnKeyType = UIReturnKeySearch;
    _textFieldSearch.clearButtonMode = UITextFieldViewModeWhileEditing;//编辑时出现叉号
    _textFieldSearch.delegate = self;
    _textFieldSearch.textColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-小"]];
    _textFieldSearch.leftView = imageView;
    _textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    UIBarButtonItem *textFieldItem = [[UIBarButtonItem alloc] initWithCustomView:self.textFieldSearch];
    NSArray *itemArr = [NSArray arrayWithObjects:searchBtnItem,textFieldItem, nil];
    self.navigationItem.rightBarButtonItems = itemArr;
    
    //监测textField中数据的更换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)searchBackAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - <导航栏右侧搜索按钮对应的响应方法>
-(void)handleSearchClick
{
    /**点击搜索按钮时隐藏键盘**/
    [self.textFieldSearch resignFirstResponder];
    NSLog(@"searchTextField:%@",self.textFieldSearch.text);
    if ((![self judgeIsEmptyWithString:self.textFieldSearch.text]) && (![self isBlankString:self.textFieldSearch.text])) {
        [self configSearchDataList];
        //写入历史数组中
        [self writeSearchDataList];
        
        self.collectionView.hidden = YES;
        self.tableView.hidden=NO;
    }
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (self.dataSource.count >= 15) {
            tableView.tableFooterView.hidden = NO;
        }
        return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        SearchResultsTableViewCell *srtvc=(SearchResultsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifierForSearch forIndexPath:indexPath];
    
    srtvc.selectionStyle = UITableViewCellSelectionStyleNone;
    srtvc.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
    return srtvc;
}

#pragma mark - <UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return SearchCellHigh;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
//    UILabel * historylabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
//    historylabel.text = @"搜索历史";
//    historylabel.textColor = [UIColor redColor];
//
//    [view addSubview:historylabel];
//
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"清除历史记录" forState:UIControlStateNormal];
//
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    btn.frame = CGRectMake(150, 0, 80, 60);
//    [view addSubview:btn];
//    [btn addTarget:self action:@selector(zczbtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    return view;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.searchBtnClicked) {
//
////        //进入详情播放页
////        VideoDetailViewController *video = [[VideoDetailViewController alloc] init];
////        _model = self.dataSource[indexPath.row];
////        video.programIdStr = _model.programId;
////        video.nameStr = _model.programName;
////        video.hidesBottomBarWhenPushed = YES;
////        [self.navigationController pushViewController:video animated:YES];
//    } else {
    
//        self.textFieldSearch.text = self.dataList[indexPath.row];
//        //        if (self.dataSource.count) {
//        //            [self.dataSource removeAllObjects];
//        //        }
//        nShowPage = 1;
//        [self requestSearchNetWorking:self.dataList[indexPath.row] currentPage:nShowPage];
//    }
}

#pragma mark - <根据关键字查询信息--网络请求>
-(void)requestSearchNetWorking:(NSString *)searchKey currentPage:(NSInteger)currentPage
{
    self.searchBtnClicked = YES;
    [self showMBProgressHud];
    NSString *pageNumber = [NSString stringWithFormat:@"%ld",(long)currentPage];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:searchKey,@"searchKey",pageNumber,@"currentPage", nil];
    NSLog(@"params:%@",params);
    [LYNetworkManager POST:GetSearchKeyHttp parameters:params successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"searhBarSuccess:%@",responseObject);
        NSLog(@"nshow:%ld",(long)nShowPage);
        NSArray *array = responseObject;
        if ([pageNumber isEqualToString:@"1"]) {
            if (self.dataSource.count > 0) {
                [self.dataSource removeAllObjects];
            }
            nShowPage = 1;
        }
        if (array.count == 0) {
            if (![pageNumber isEqualToString:@"1"]) {
                --nShowPage;
                
            }
            [[ZCZTipsView sharedZCZTipsView]showWithString:NoMoreMessage];
            
        }
//        for (NSDictionary *dict in array) {
////            self.model = [SearchModel itemSearchModelWithDictionary:dict];
////            [self.dataSource addObject:_model];
//        }
        [self.tableView reloadData];
        [self hideMBProgressHud];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"searchBarError:%@",error);
        if (![pageNumber isEqualToString:@"1"]) {
            --nShowPage;
        }
        [self hideMBProgressHud];
    }];
}

#pragma mark - <监听文字更改对应的响应方法>
//当textFiled无内容时，改为显示历史记录。
- (void)textFieldTextDidChanged:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    if ([self judgeIsEmptyWithString:textField.text] == YES) {
//        self.searchBtnClicked = NO;
//        [self.tableView reloadData];
        self.collectionView.hidden =NO;
        self.tableView.hidden = YES;
        [self.collectionView reloadData];
    }
}

#pragma mark - <UITextFieldDelegate,点击return进行网络请求>
//返回一个bool值，指明是否许在按下回车键时结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self handleSearchClick];
    return YES;
}

//发送网络请求，改变历史数组
-(void)configSearchDataList
{
    nShowPage = 1;
#warning todo
//    [self requestSearchNetWorking:self.textFieldSearch.text currentPage:nShowPage];
    
    //如果存在相同，就把那个数据放在第一个位置同时，移除之前的
    for (int i = 0; i < self.dataList.count; i++) {
        NSString *str = self.dataList[i];
        NSLog(@"str:%@",str);
        NSLog(@"text:%@",self.textFieldSearch.text);
        if ([self.textFieldSearch.text isEqualToString:str]) {
            NSLog(@"1,2,3,4");
            [self.dataList removeObject:str];
            [self.dataList insertObject:str atIndex:0];
            return;
        }
    }
    //不存在相同的，移除最后一个，把新的放在最前面
        if (self.dataList.count == 10) {
            [self.dataList removeObjectAtIndex:self.dataList.count - 1];
        }
        [self.dataList insertObject:self.textFieldSearch.text atIndex:0];
}

-(void)writeSearchDataList
{
    NSString *arrayPath = [self returnDocumentPath:@"historyArrayPath.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    /**
     *fileExistsAtPath:
     *判断指定文件名对应的文件是否存在
     */
    if (![fileManager fileExistsAtPath:arrayPath]) {
        //根据指定的文件路径、内容创建文件
        [fileManager createFileAtPath:arrayPath contents:nil attributes:nil];
    }
    [self.dataList writeToFile:arrayPath atomically:YES];
}

-(BOOL)isBlankString:(NSString *)string
{
    NSString *phoneRegex = @"^\\s*$";
    NSPredicate *phoneP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSLog(@"%u",[phoneP evaluateWithObject:string]);
    //no,代表不包含空格
    //yes,代表包含空格
    return [phoneP evaluateWithObject:string];
}

- (BOOL)judgeIsEmptyWithString:(NSString *)string
{
    if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]])
    {
        //代表空
        return YES;
    }
    //代表不为空
    return NO;
}

-(void)setUpCollectionView
{
    UICollectionViewFlowLayout *layout =
    [[UICollectionViewFlowLayout alloc] init];
    // 定义大小
    layout.itemSize = CGSizeMake(self.view.frame.size.width/2-2, 35);
    // 设置最小行、列间距
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    // 设置垂直间距
    // layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    // 设置滚动方向（默认垂直滚动）
    // layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen ].bounds.size.width, [UIScreen mainScreen ].bounds.size.height ) collectionViewLayout:layout]; _collectionView.backgroundColor = [UIColor blueColor];
    
    _collectionView.dataSource = self; _collectionView.delegate = self;
    
    _collectionView.scrollEnabled = NO;
    //    [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HistoryCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerNib:[UINib nibWithNibName:@"HistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Historycell"];
    
//    [[ self.collectionView registerNib:[UINib nibWithNibName:@"HistoryCollectionViewCell" bundle:nil]] forCellWithReuseIdentifier:@"Historycell"];
    [_backSuperView addSubview:_collectionView];// 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"]; // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"]; }
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Historycell" forIndexPath:indexPath];
    if (indexPath.section==0) {
        if (indexPath.row<self.dataList.count) {
            cell.cellLabel.text = (NSString *)self.dataList[indexPath.item];
            
            return cell;
        }
        cell.cellLabel.text=nil;
        return cell;
    }else{
       cell.cellLabel.text = @"kaikaixinxin";
    }
    return cell;
}

//sectionHeader的布局
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HistoryCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    view.delegate = self;
    if (indexPath.section==0) {
        view.nameLabel.text = @"历史记录";
        view.cleanButton.hidden=NO;
    }else{
 view.nameLabel.text = @"热门搜索";
        view.cleanButton.hidden=YES;
    }
    return view;
    }

#pragma mark - <UICollectionViewDelegateFlowLayout>
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 50);
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str;
if(indexPath.section==0&&indexPath.row<self.dataList.count)
{
         str = self.dataList[indexPath.row];
    }else if (indexPath.section==1)
    {
         str = @"kaikixinxin";
    }else
    {
        return;
    }
    self.textFieldSearch.text = str;
    [self handleSearchClick];
}

#pragma mark - <点击清除历史记录HistoryCollectionReusableViewDelegate>
- (void)HistoryCollectionReusableViewCleanButtonClick
{
        NSString *arrayPath = [self returnDocumentPath:@"historyArrayPath.plist"];
        [[NSMutableArray array]writeToFile:arrayPath atomically:YES];
        self.dataList = [NSMutableArray array];
        [self.collectionView reloadData];
}
@end
