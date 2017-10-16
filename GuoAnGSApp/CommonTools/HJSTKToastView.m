//
//  popLabel.m
//  textLabel
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HJSTKToastView.h"
#import <QuartzCore/QuartzCore.h>

#define AppearWithDisappearTime 0.2
#define ShowTime 1.2

static UIView *popView;
static UILabel *label;
static UIView *backView;
static NSMutableArray *popStrArray;//存储所要toast的文字内容
static Boolean bShowSidewards=NO;//是否是横屏

@implementation HJSTKToastView


static NSCondition	*condition;

+(void)setbShowSidewards:(Boolean)bSetIn
{
    bShowSidewards=bSetIn;
}

+(void)hidePoplabel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:AppearWithDisappearTime];
        backView.alpha=0;
        [UIView commitAnimations];
        sleep(AppearWithDisappearTime);
        popView.hidden=YES;
        if (popStrArray.count > 0) {
            [popStrArray removeObjectAtIndex:0];
        }
        [condition unlock];
        [self showPop];
    });
}

+(void)showPop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([popStrArray count]>0)
        {
            [condition lock];
            NSString *str=[popStrArray objectAtIndex:0];
            backView.alpha=0;
            
            popView.hidden=NO;
            UIWindow *window=[UIApplication sharedApplication].keyWindow;
            [window bringSubviewToFront:popView];
            
            label.textColor=[UIColor whiteColor];
            
            
            CGSize labelSize=[str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(180, 300) lineBreakMode:NSLineBreakByCharWrapping];
            
            label.text=str;
            label.font=[UIFont systemFontOfSize:15];
            label.numberOfLines=0;
            label.lineBreakMode=NSLineBreakByCharWrapping;
            label.textAlignment=NSTextAlignmentCenter;
            
            
            if(!bShowSidewards)
            {
                label.layer.transform=CATransform3DIdentity;
                label.transform=CGAffineTransformMakeRotation(0);
                label.frame=CGRectMake(15,17, 180, labelSize.height);
                backView.frame=CGRectMake((popView.frame.size.width-210)/2,popView.frame.size.height/2-labelSize.height/2-17,210, labelSize.height+34);
            }
            else
            {
                label.layer.transform=CATransform3DIdentity;
                label.transform=CGAffineTransformMakeRotation(M_PI_2);
                label.frame=CGRectMake(17,15,labelSize.height,180);
                
                backView.frame=CGRectMake((popView.frame.size.width-labelSize.height)/2-17,popView.frame.size.height/2-105,labelSize.height+34,210);
            }
            
            backView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            backView.layer.cornerRadius=5;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:AppearWithDisappearTime];
            backView.alpha=1;
            [UIView commitAnimations];
            
            //        [popStrArray removeObject:0];
            
            [HJSTKToastView performSelector:@selector(hidePoplabel) withObject:nil afterDelay:ShowTime];
        }
        
    });
}



//显示数据内容
+(void)addPopString:(NSString *)str
{
    if(str)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(nil==popView)
            {
                UIWindow *window=[UIApplication sharedApplication].keyWindow;
                CGRect frame=CGRectMake(0,0,window.frame.size.width,window.frame.size.height);
                popView=[[UIView alloc] initWithFrame:frame];
                popView.backgroundColor=[UIColor clearColor];
                [window addSubview:popView];
                popView.hidden=NO;
                backView=[[UIView alloc] init];
                label=[[UILabel alloc] init];
                label.backgroundColor=[UIColor clearColor];
                [popView addSubview:backView];
                [backView addSubview:label];
                
                if(nil==popStrArray)
                {
                    popStrArray=[[NSMutableArray alloc] initWithCapacity:10];
                }
                [popStrArray addObject:str];
                [HJSTKToastView performSelector:@selector(showPop) withObject:nil afterDelay:0];
            }
            else
            {
                if(nil==popStrArray)
                {
                    popStrArray=[[NSMutableArray alloc] initWithCapacity:10];
                }
                [popStrArray addObject:str];
                [HJSTKToastView performSelector:@selector(showPop) withObject:nil afterDelay:0];
                
            }
        });
    }
    else
    {
        [self addPopString:@"数据为空"];
    }
}

@end
