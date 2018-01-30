//
//  NSString+AppendFilePath.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/24.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AppendFilePath)
-(NSString *)returnLibraryCachesfilePath;
-(NSString *)returnDocumentPath;
-(void)deleateFile;
@end
