//
//  FinishVC.m
//  CS_WeiTV
//
//  Created by Nina on 15/9/2.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "FinishVC.h"

#import "sexVC.h" //性别
#import "NameVC.h" //昵称
#import "AddressViewController.h"//地址
#import "BirthVC.h"//生日
#import "LoadOnVC.h"//登录页面
#import "My_ReuseCllTableViewCell.h"
#import "FinishSectionHeaderFooter.h"

@interface FinishVC ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FinishLoadImgDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *button; //提交
@property (nonatomic, strong) NSMutableDictionary *contentDic;
@property(nonatomic,copy) NSString *upLoadImgUrl;
@property(nonatomic,copy) NSString *nameStr;
@property(nonatomic,copy) NSString *genderStr;
@property(nonatomic,copy) NSString *birthStr;
@property(nonatomic,copy) NSString *addresStr;

@end


@implementation FinishVC

- (NSMutableDictionary *)contentDic {
    if (!_contentDic) {
        _contentDic = [NSMutableDictionary dictionary];
    }
    return _contentDic;
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenSizeWidth, ScreenSizeHeigh-64-50) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}


-(UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0,ScreenSizeHeigh - 50, ScreenSizeWidth , 50);
        [_button setTitle:@"提交" forState:UIControlStateNormal];
        [_button setTitleColor:WHTIE_NORMAL forState:UIControlStateNormal];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
        _button.backgroundColor = HIGHLIGHTED_COLOR;
    }
    return _button;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleMessage = @"完善资料";
    self.showLeft = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置nav右上角跳过按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"跳过" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:SMALL_SIZE]intValue]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(passAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextItm = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = nextItm;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.button];
    
    [_tableView registerClass:[My_ReuseCllTableViewCell class] forCellReuseIdentifier:NSStringFromClass([My_ReuseCllTableViewCell class])];
    [_tableView registerClass:[FinishSectionHeaderFooter class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([FinishSectionHeaderFooter class])];
}


#pragma mark - 跳过Btn -
-(void)passAction
{
    LoadOnVC *load = [[LoadOnVC alloc]initWithNibName:@"LoadOnVC" bundle:nil];
    load.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:load animated:YES];
}


#pragma mark - UITableViewDataSource -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MY_Finish_Message.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    My_ReuseCllTableViewCell *reuseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([My_ReuseCllTableViewCell class]) forIndexPath:indexPath];
    reuseCell.leftLabel.text = MY_Finish_Message[indexPath.row];
    if ([self.contentDic.allKeys containsObject:indexPath]) {
        reuseCell.rightLabel.text = [self.contentDic objectForKey:indexPath];
    }else{
        reuseCell.rightLabel.text = UnCompleted;
    }
    
    switch (indexPath.row) {
        case 0:
            self.nameStr = reuseCell.rightLabel.text;//昵称
            break;
        case 1:
            self.genderStr = reuseCell.rightLabel.text;//性别
            break;
            
        case 2:
            self.birthStr = reuseCell.rightLabel.text;//生日
            break;
        case 3:
            self.addresStr = reuseCell.rightLabel.text;
            break;
        default:
            break;
    }
    reuseCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    reuseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return reuseCell;
}

#pragma mark - UITableViewDelegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //由于block会发生循环引用的现象，必须用弱指针引用其他对象，即不能用self，用ws取代。
    WS(ws);
    My_ReuseCllTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    switch (indexPath.row) {
        case 0:
        {
            NameVC *name = [[NameVC alloc] init];
            name.identifier = ComPleted;
            //从前往后传值
            if (![cell.rightLabel.text isEqualToString:UnCompleted]) {
                name.nameStr = cell.rightLabel.text;
            }
            //从后往前传值，判断传过来的文字长度是否大于0；若等于0,则设置为待完善；若大于0，则设置为更改后的
            name.passingValue = ^(UITextField *textField){
                [ws.contentDic setObject:textField.text.length > 0 ? textField.text :UnCompleted forKey:indexPath];
                //刷新指定行
                [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            NSLog(@"nameContentDic:%@",ws.contentDic);
            name.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:name animated:YES];
            break;
        }
        case 1:
        {
            sexVC *sex = [[sexVC alloc]init];
            sex.identifier = ComPleted;
            if (![cell.rightLabel.text isEqualToString:UnCompleted]) {
                sex.gengderStr = cell.rightLabel.text;
            }
            sex.genderBlock = ^(NSString *str){
                [ws.contentDic setObject:str.length > 0 ? str : UnCompleted forKey:indexPath];
                [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            sex.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sex animated:YES];
            break;
        }
        case 2:
        {
            BirthVC *birth = [[BirthVC alloc] init];
            birth.identifier = ComPleted;
            if (![cell.rightLabel.text isEqualToString:UnCompleted]) {
                birth.birthStr = cell.rightLabel.text;//生日
            }
            birth.returnText = ^(NSString *str){
                [ws.contentDic setObject:str.length>0 ? str:UnCompleted forKey:indexPath];
                [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            birth.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:birth animated:YES];
            break;
        }
        case 3:
        {
            AddressViewController *address = [[AddressViewController alloc] init];
            address.identifier =ComPleted;
            if (![cell.rightLabel.text isEqualToString:UnCompleted]) {
                address.cityStr = cell.rightLabel.text;
            }
            NSLog(@"---属性传值-%@",address.cityStr);
            address.addressBlock = ^(NSString *str){
                [ws.contentDic setObject:str.length > 0 ? str:UnCompleted forKey:indexPath];
                [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            address.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:address animated:YES];
            break;
        }
        default:
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return commonCellHigh;
}

//返回头标题的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 165;
}

//为分区头标题添加对应的视图对象
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    FinishSectionHeaderFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FinishSectionHeaderFooter class])];
    FinishSectionHeaderFooter *view = [[FinishSectionHeaderFooter alloc]initWithReuseIdentifier:NSStringFromClass([FinishSectionHeaderFooter class])];
    view.delegate = self;
      /**SDWebImageRefreshCached,刷新缓存，有时本地图片更新后，与服务器没有同步一致时可以使用；专门用于处理相同url，不同image的情况**/
    [view.imgView sd_setImageWithURL:[NSURL URLWithString:self.upLoadImgUrl] placeholderImage:ImageNamed(@"完善资料-上传头像") options:SDWebImageRefreshCached];
    return view;
}


#pragma mark - FinishLoadImgDelegate -
-(void)selectImgAction {
    [self uploadAction];
}

#pragma mark -  UIAlertSheetController,拍照、从手机相册选择、取消 -
-(void)uploadAction{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [sheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //检测设备是否支持来自相机的图库
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pic = [[UIImagePickerController alloc]init];
            pic.sourceType = UIImagePickerControllerSourceTypeCamera;
            pic.delegate = self;
            pic.allowsEditing = YES;
            /**模态画面显示/隐藏时动画效果的属性
             UIModalTransitionStyleCoverVertical = 0,画面从下向上徐徐弹出，关闭时向下隐藏
             UIModalTransitionStyleFlipHorizontal,从前一个画面的后方，以水平旋转的方式显示后一画面
             UIModalTransitionStyleCrossDissolve,前一湖面逐渐消失的同时，后一画面逐渐显示
             UIModalTransitionStylePartialCurl,
             */
            pic.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:pic animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"你没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }]];
    
    [sheet addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //从用户相册获取活动图片
        //检测设备是否支持来自图库的数据
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *pic = [[UIImagePickerController alloc]init];
            pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//调用图片库,表明当前图片来源为相册
            pic.delegate = self;
            pic.allowsEditing = YES;//设置用户对图片可编辑
            
            [self presentViewController:pic animated:YES completion:^{
            }];
        }
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:sheet animated:YES completion:nil];
}




#pragma mark - UIImagePickerControllerDelegate -
//当得到图片或者视频的时候调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *photos = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imgData = UIImageJPEGRepresentation(photos, 0.7f);
    //上传头像网络请求
    [self requestUploadImageHeaderNetWorking:self.userNameStr fileData:imgData fileName:@"uploadImage.jpg"];
}


//当用户取消相册时, 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 头像上传网络请求 -
-(void)requestUploadImageHeaderNetWorking:(NSString *)appUserName fileData:(NSData *)fileData fileName:(NSString *)fileName
{
    [self showMBProgressHud];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:appUserName,@"appUserName",fileName,@"file",nil];
    NSLog(@"upLoadParam:%@",param);
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer.timeoutInterval = TimeOutInterval;
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [sessionManager setSecurityPolicy:[self customSecurityPolicy]];
    NSString *url = [NSString stringWithFormat:PreHttpCommon,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),GetUpLoadImage];
    NSLog(@"%@--%@",kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort));
    NSLog(@"url路径：%@",url);
    [sessionManager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"uploadImageFile" fileName:fileName mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"UPdatePictureSuccess:%@",responseObject);
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        NSLog(@"返回路径：%@",self.commonReturnCode.returnMsg);
        if ([self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            //获取完整的头像路径
           self.upLoadImgUrl = [NSString stringWithFormat:PreHttpImage,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),self.commonReturnCode.returnMsg];
            NSLog(@"BeforeuploadImgUrl:%@",self.upLoadImgUrl);
            [HJSTKToastView addPopString:HeadImageUploadSuccess];
        }else{
            [HJSTKToastView addPopString:HeadImageFailure];
        }
    
        [self.tableView reloadData];
        [self hideMBProgressHud];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HJSTKToastView addPopString:error.localizedDescription];
        [self hideMBProgressHud];
    }];
}


#pragma mark - 提交信息Action -
-(void)submit
{
    NSLog(@"用户名“%@",self.userNameStr);
    [self requestCompelteUserInfoNetWorkingAppUserName:self.userNameStr lastName:self.nameStr birthday:self.birthStr sex:self.genderStr address:self.addresStr];
}


#pragma mark - 完善用户资料网络请求 -
-(void)requestCompelteUserInfoNetWorkingAppUserName:(NSString *)userName lastName:(NSString *)lastName birthday:(NSString *)birthday sex:(NSString *)sex address:(NSString *)address
{
    [self showMBProgressHud];
    if ([userName isEqualToString:@"待完善"]) {
        userName = @"";
    }
    if ([lastName isEqualToString:@"待完善"]) {
        lastName = @"";
    }
    if ([birthday isEqualToString:@"待完善"]) {
        birthday = @"";
    }
    if ([sex isEqualToString:@"待完善"]) {
        sex = @"";
    }
    if ([address isEqualToString:@"待完善"]) {
        address = @"";
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"appUserName",lastName,@"lastName",birthday,@"birthday",sex,@"sex",address,@"address", nil];
    NSLog(@"paramFinish:%@",param);
    [LYNetworkManager POST:GetCompletePersonInfo parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"finishreturn:%@",responseObject);
        self.commonReturnCode = [ReturnModel itemReturnModelWithDictionary:responseObject];
        if ([self.commonReturnCode.returnCode isEqualToNumber:[NSNumber numberWithInt:0]]) {
            //跳转到登录界面
            LoadOnVC *load = [[LoadOnVC alloc]initWithNibName:@"LoadOnVC" bundle:nil];
            load.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:load animated:YES];
        }else{
            [HJSTKToastView addPopString:self.commonReturnCode.returnMsg];
        }
        [self hideMBProgressHud];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self hideMBProgressHud];
    }];
}

@end
