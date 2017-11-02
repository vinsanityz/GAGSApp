//
//  ChoosePhotoController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/2.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ChoosePhotoController.h"
#import <Photos/Photos.h>

@interface ChoosePhotoController ()

@end

@implementation ChoosePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    NSLog(@"%@",smartAlbums);
//    // 列出所有用户创建的相册
//    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
//    NSLog(@"%@",topLevelUserCollections);
//    // 获取所有资源的集合，并按资源的创建时间排序
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
//    NSLog(@"%@",assetsFetchResults);
//    
//    
//    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
//    for (NSInteger i = 0; i < smartAlbums.count; i++) {
//        // 获取一个相册（PHAssetCollection）
//        PHCollection *collection = smartAlbums[i];
//        if ([collection isKindOfClass:[PHAssetCollection class]]) {
//            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
//            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
//            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
//            for (NSInteger i = 0; i < fetchResult.count; i++) {
//                            // 获取一个资源（PHAsset）
//                            PHAsset *asset = fetchResult[i];
//                NSLog(@"%@",asset);
//                        }
//            NSLog(@"%@",fetchResult);
//        }    else {
//                NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
//            }
//        
//    
////        for (NSInteger i = 0; i < fetchResult.count; i++) {
////            // 获取一个资源（PHAsset）
////            PHAsset *asset = fetchResult[i];
////        }
//}
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

@end
