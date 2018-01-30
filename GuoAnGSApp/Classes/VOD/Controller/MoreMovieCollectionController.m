//
//  MoreMovieCollectionController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/29.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "MoreMovieCollectionController.h"
#import "MoreVideoModel.h"
#import "MovieCollectionViewCell.h"



@interface MoreMovieCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//@property(nonatomic,strong) VideoMoreModel *moreModel;


@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,assign) NSInteger showPage;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation MoreMovieCollectionController



-(NSMutableArray *)dataSource
{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    [self requesetSecondMoreNetWorking:1];
    
    [self setUpMJRefresh];
 

}

#pragma mark - <MJRefresh相关代码>
-(void)setUpMJRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
//下拉刷新
-(void)loadNewData
{
    self.showPage = 1;
    [self requesetSecondMoreNetWorking:self.showPage];
}
//上拉加载
-(void)loadMoreData
{
    [self requesetSecondMoreNetWorking:++self.showPage];
}
-(void)setSecondVideoId:(NSString *)secondVideoId
{
    _secondVideoId = secondVideoId;
    
    
    
}

#pragma mark - <更多接口网络请求>
-(void)requesetSecondMoreNetWorking:(NSInteger)page
{
        [self showMBProgressHud];
    
    NSNumber *currentPage = [NSNumber numberWithInteger:page];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.secondVideoId,@"secondVideoId",currentPage,@"currentPage", nil];
    NSLog(@"param:%@",param);
//    NSLog(@"current:%ld",(long)nShowPage);
    [LYNetworkManager POST:GetSecondVideoMore parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject;
        if ([currentPage isEqualToNumber:@1]) {
            if (self.dataSource.count >0) {
                [self.dataSource removeAllObjects];
            }
            self.showPage = 1;
        }
        if (array.count == 0) {
            if (![currentPage isEqualToNumber:@1]) {
                --self.showPage;
            }
            [ZCZTipsView showWithString:NoMoreMessage];
        }
//        NSLog(@"originArray:%ld,%@",(unsigned long)array.count,array);
        for (NSDictionary *dict in array) {
            MoreVideoModel *model = [MoreVideoModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:model];
        }
        [self.collectionView reloadData];
        [self hideMBProgressHud];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"moreError:%@",error);
        if (![currentPage isEqualToNumber:@1]) {
            --self.showPage;
        }
        if (self.dataSource.count == 0) {
            [self createAlertStateViewHeight:0 msg:error.localizedDescription];
        }
        [self hideMBProgressHud];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}

-(void)setUpCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 定义大小
    layout.itemSize = CGSizeMake(110    , 110);
    // 设置最小行间距
    layout.minimumLineSpacing = 1;
    // 设置垂直间距
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumInteritemSpacing = 10;
    // 设置滚动方向（默认垂直滚动）
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-46)collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blueColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = YES;
    //    _collectionView.contentSize = CGSizeMake(0, 1000);
    //    [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    

    [self.view addSubview:_collectionView];// 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"]; // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"]; }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    MoreVideoModel * model = self.dataSource[indexPath.row];
    NSString *url = [NSString stringWithFormat:PreHttpImage,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),model.postUrl];
    //转化图片的url路径
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loginpic"]];
    
    cell.titleLabel.text = model.programName;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
