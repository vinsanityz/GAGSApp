//
//  NSString+AppendFilePath.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/24.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "NSString+AppendFilePath.h"

@implementation NSString (AppendFilePath)

/**保存在Document文件夹中**/
-(NSString *)returnDocumentPath
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [documents stringByAppendingPathComponent:self];
    NSLog(@"path:%@",filePath);
    return filePath;
}

// Library/caches
-(NSString *)returnLibraryCachesfilePath
{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *filePath = [documents stringByAppendingPathComponent:self];
    NSLog(@"path:%@",filePath);
    return filePath;
}

-(void)deleateFile
{
    NSFileManager *file = [NSFileManager defaultManager];
    [file removeItemAtPath:self error:nil];
}
@end
