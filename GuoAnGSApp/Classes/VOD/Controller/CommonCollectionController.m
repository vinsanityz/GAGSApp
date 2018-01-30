//
//  CommonCollectionController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/24.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "CommonCollectionController.h"
#import <SDCycleScrollView.h>
#import <MJExtension.h>
#import "MovieCollectionViewCell.h"
#import <SDWebImageManager.h>

#import "CommonCollectionReusableHeaderView.h"
#import "MoreMovieCollectionController.h"

#import "FirstMovieIdModel.h"
#import "SecondMovieIdModel.h"
#import "SecondMovieIdDataArrayModel.h"

@interface CommonCollectionController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,CommonCollectionReusableHeaderViewDelegate>
@property(nonatomic,strong)SDCycleScrollView * cycleScrollView;
@property(nonatomic,strong)UICollectionView * collectionView;
//@property(nonatomic,strong)
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)SecondMovieIdModel * secondModel;
@end

@implementation CommonCollectionController
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
}

//-(void)setUpCycleScrollView
//{
//    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240) delegate:self placeholderImage:[UIImage imageNamed:@"loginpic"]];
//    _cycleScrollView.delegate = self;
//
//    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    _cycleScrollView.currentPageDotColor = [UIColor orangeColor];
//    _cycleScrollView.pageDotColor = [UIColor whiteColor];
//    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.cycleScrollView];
//    self.cycleScrollView.autoScrollTimeInterval = 1.0;
//    //注：标题数组元素个数必须和图片数组元素个数标识一致
//    NSURL * url1 = @"123";
//    self.cycleScrollView.imageURLStringsGroup = @[url1,url1,url1];
//    self.cycleScrollView.titlesGroup = @[@"1",@"2",@"3"];
//}

-(void)setModel:(FirstMovieIdModel *)model
{
    _model = model;
    [self requestDataByFirstVideoId];
    
    
}

-(void)requestDataByFirstVideoId
{
    
        [self showMBProgressHud];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.model.firstVideoId forKey:@"firstVideoId"];
    [LYNetworkManager POST:GetProgramByFirstVideoAction parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"VideoTableresponseObject:%@",responseObject);
        NSArray *downArray = [responseObject objectForKey:@"Info"];
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
        }
        [SecondMovieIdModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"data" : @"SecondMovieIdDataArrayModel",
                     // @"statuses" : [Status class],
                   
                     };
        }];
        for (NSDictionary *dic in downArray) {
            self.secondModel = [SecondMovieIdModel mj_objectWithKeyValues:dic];
            
            [self.dataSource addObject:self.secondModel];
            
            
//            self.downModel = [VideoTableDownModel itemWithWideoTableDownModelDictionary:dic];
//            [self.dataSource addObject:_downModel];
        }
        //以下为轮播图中的数据内容
//        self.infoArray = [responseObject objectForKey:@"RollPhoto"];
//        NSLog(@"infoArray:%ld,%@",(unsigned long)self.infoArray.count,self.infoArray);
//        NSDictionary *timeDictionary = [responseObject objectForKey:@"rollPhotoConfig"];
//        self.rollInfoNumber = [timeDictionary objectForKey:@"rollInfoNumber"];
//        self.rollInfoTime = [timeDictionary objectForKey:@"rollInfoTime"];
//
//        // 缓存数据：
//        self.cacheModel.dataSource = [NSMutableArray arrayWithArray:self.dataSource];
//        self.cacheModel.infoArray = [NSArray arrayWithArray:self.infoArray];
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//        NSString *filename=[NSString stringWithFormat:@"FrontPage-%ld-Caches.txt",(long)self.firstID.integerValue];
//        NSString *filePath = [documents stringByAppendingPathComponent:filename];
//        // 缓存的写入：
//        if(![NSKeyedArchiver archiveRootObject:self.cacheModel toFile:filePath])
//        {
//            NSLog(@"VideoTalbeViewController 缓存写入失败！");
//        }else{
//            NSLog(@"VideoTableViewController 缓存写入成功！");
//        }
//        [self hideMBProgressHud];
//        self.isShow = YES;
//        NSLog(@"isShow:%u",self.isShow);[self showMBProgressHud];
        [self hideMBProgressHud];
        [self.collectionView reloadData];//刷新数据源
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"VideoTablViewControllerFailure:%@",error);
        [self hideMBProgressHud];
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-40-46)collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blueColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = YES;
//    _collectionView.contentSize = CGSizeMake(0, 1000);
    //    [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CommonCollectionReusableHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cycleheader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    
    [ self.collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];// 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"]; // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"]; }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }else{
        
        
    return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    SecondMovieIdModel * model = self.dataSource[indexPath.section];
    SecondMovieIdDataArrayModel * datamodel;
    if (model.data.count>indexPath.row) {
        datamodel = model.data[indexPath.row];
    }
    
    
    cell.titleLabel.text = datamodel.programName;
     NSString *urlStr = [NSString stringWithFormat:PreHttpImage,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),datamodel.postUrl];
    [cell.imageV  sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"loginpic"]];
    
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGSizeMake(self.view.bounds.size.width, 240);
    }else{
    return CGSizeMake(self.view.bounds.size.width, 40);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:@"cycleheader" forIndexPath:indexPath];
        
        [view addSubview:self.cycleScrollView];
        return view;
    }
    CommonCollectionReusableHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    SecondMovieIdModel * model = self.dataSource[indexPath.section];
    view.indexPath =indexPath;
    view.leftLabel.text = model.secondVideoTypeName;
    view.delegate = self;
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    SecondMovieIdModel * model = self.dataSource[indexPath.section];
//    NSString * str = model.secondVideoTypeName;
//
//    [btn setTitle:str forState:UIControlStateNormal];
//
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    btn.frame = CGRectMake(0, 0, 200, 20);
//    [view addSubview:btn];
//    view.backgroundColor = [UIColor redColor];
    return view;
}

-(SDCycleScrollView *)cycleScrollView
{
    if (_cycleScrollView==nil) {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240) delegate:self placeholderImage:[UIImage imageNamed:@"loginpic"]];
        _cycleScrollView.delegate = self;
        
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor orangeColor];
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        [self.view addSubview:self.cycleScrollView];
        self.cycleScrollView.autoScrollTimeInterval = 1.0;
        //注：标题数组元素个数必须和图片数组元素个数标识一致
        NSURL * url1 = @"123";
        self.cycleScrollView.imageURLStringsGroup = @[url1,url1,url1];
        self.cycleScrollView.titlesGroup = @[@"1",@"2",@"3"];
    }
    return _cycleScrollView;
}


- (void)CommonCollectionReusableHeaderViewRightButtonClick:(CommonCollectionReusableHeaderView *)view{
    MoreMovieCollectionController * vc = [[MoreMovieCollectionController alloc]init];
    SecondMovieIdModel * model = self.dataSource[view.indexPath.section];
    
    vc.secondVideoId = model.secondVideoId;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
//点击图片回调
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index

@end
