//
//  NSString+calculate.m
//  CS_WeiTV
//
//  Created by Nina on 16/5/6.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "NSString+calculate.h"

@implementation NSString (calculate)

/**
 *fileExistsAtPath:isDirectory:
 *判断指定文件名对应的文件或目录是否存在，该方法的后一个参数可用于返回该文件名是否为目录。
 */
-(NSInteger)fileSizeCalculate
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL dir = NO ; //判断是否为目录
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];//判断指定文件对应的文件或目录是否存在
    if (exists == NO) {
        return 0;
    }else{
        //如果是目录（文件夹）
        if (dir) {
            NSArray *subPaths = [mgr subpathsAtPath:self];//递归获取指定路径包含的所有（直接和间接）内容（目录或子目录）-----获得一个目录下的所有文件名
            NSInteger totalByteSize = 0;
            for (NSString *subPath in subPaths) {
                NSString *fullSubPath = [self stringByAppendingPathComponent:subPath];//获取全路径，（在self的路径后追加一个路径）
                BOOL subDir = NO;
                [mgr fileExistsAtPath:fullSubPath isDirectory:&dir];
                if (subDir == NO) {//此目录中不包含子目录
                    totalByteSize += [[mgr attributesOfItemAtPath:fullSubPath error:nil] [NSFileSize] integerValue];//获取指定文件名对应文件的属性
                }
            }
            return totalByteSize;
        }else{
//            return [[mgr attributesOfItemAtPath:self error:nil] [NSFileSize]integerValue];
             return (NSInteger)[[mgr attributesOfItemAtPath:self error:nil] fileSize];
        }
    }
}

@end
