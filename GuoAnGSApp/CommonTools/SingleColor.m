//
//  singleColor.m
//  CS_WeiTV
//
//  Created by wy on 15/9/23.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "SingleColor.h"

static inline NSString * myselfSaveFile() {
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/info"];
}

@implementation SingleColor

+(instancetype)sharedInstance
{
    static SingleColor *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


-(void)saveColor
{
    NSMutableData *data = [NSMutableData data];
    
    NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [keyedArchiver encodeObject:self forKey:@"dic"];
    
    [keyedArchiver finishEncoding];
    
    NSString *filePath = myselfSaveFile();
//    NSLog(@"filePath:%@",filePath);
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:filePath])
        
    {
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    [data writeToFile:filePath atomically:YES];
}

-(SingleColor *)restore
{
    NSString *path =myselfSaveFile();
    NSData *data = [NSData dataWithContentsOfFile:path];
    //    NSLog(@"沙河路径path=%@",path);//打印沙盒路径
    
    //解档
    NSKeyedUnarchiver *keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    SingleColor* newArray = [keyedUnarchiver decodeObjectForKey:@"dic"];
    SingleColor *sing1 = [SingleColor sharedInstance];
    sing1.colorDic = newArray.colorDic;
    sing1.colorEdition = newArray.colorEdition;
    sing1.fontDic = newArray.fontDic;
    sing1.fontEdition = newArray.fontEdition;
    sing1.fontSize = newArray.fontSize;
    return newArray;
}
@end
