//
//  BasicViewController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/23.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "BasicViewController.h"
#import "MyTabbarViewController.h"
#import "ProcessImageController.h"
@interface BasicViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)MyTabbarViewController * MyTabBarVC;
@property(nonatomic,strong)UIView * LeftView;
@property(nonatomic,strong)UIView * RightView;
@property(nonatomic,strong)UIView * MyTabBarVCView;
@property(nonatomic,strong)UIView * swipView;
@property(nonatomic,assign)BOOL IsLeft;
@property(nonatomic,strong)UIPanGestureRecognizer * recognizer;
@property(nonatomic,assign)CGFloat BeginX;
@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _IsLeft = YES;
    self.BeginX =0;
//    ProcessImageController * pic = [[ProcessImageController alloc]init];
//
//    [self addChildViewController:pic];
//    self.LeftView = pic.view;
//
//    self.LeftView.frame =CGRectMake(0, 0, 400, 667);
//    self.LeftView.clipsToBounds = NO;
    self.LeftView = [[UITableView alloc]initWithFrame:CGRectMake(-150, 0, 300, 667)];
    [self.LeftView addSubview:[[UISwitch alloc]initWithFrame:CGRectMake(150, 150, 300, 300)] ];
    self.LeftView.backgroundColor = [UIColor greenColor];
    
    self.RightView = [[UITableView alloc]initWithFrame:CGRectMake(375-150, 0, 300, 667)];
    [self.RightView addSubview:[[UISwitch alloc]initWithFrame:CGRectMake(150, 150, 300, 300)] ];
    self.RightView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.RightView];
    
    self.RightView.hidden = YES;
    self.LeftView.hidden = YES;
//    self.LeftView.center = CGPointMake(0, 333);
    [self.view addSubview:self.LeftView];
    self.MyTabBarVC = [[MyTabbarViewController alloc]init];
    self.MyTabBarVCView =self.MyTabBarVC.view;
    [self.view addSubview:self.MyTabBarVC.view];
    [self addChildViewController:self.MyTabBarVC];

  UIPanGestureRecognizer * recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.delegate = self;
    self.recognizer = recognizer;
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.MyTabBarVCView addGestureRecognizer:recognizer];
    
    [self setUpSwipViewOverTabBarView];
    UITapGestureRecognizer * swip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipView:)];
    
//    UIPanGestureRecognizer * recognizerRight = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromRight:)];
//    recognizerRight.delegate = self;
    [self.swipView addGestureRecognizer:swip];
}
-(void)setUpSwipViewOverTabBarView
{
    UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.MyTabBarVCView addSubview:view];
    view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
    view.alpha = 0;
    
    self.swipView = view;
}

- (void)handleSwipeFrom:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"%@",   NSStringFromCGPoint ( [recognizer velocityInView:self.MyTabBarVCView]));
    
//    if ([recognizer velocityInView:self.MyTabBarVCView].x>2000) {
//        self.LeftView.hidden = NO;
//        self.RightView.hidden = YES;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.LeftView.center = CGPointMake(150, 333);
//            self.MyTabBarVCView.center =CGPointMake(375/2+300, 333);
//            self.swipView.alpha = 1;
//
//        }];
////        return;
//    }if ([recognizer velocityInView:self.MyTabBarVCView].x<-2000) {
//        self.LeftView.hidden = YES;
//        self.RightView.hidden = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.RightView.center = CGPointMake(375-150, 333);
//            self.MyTabBarVCView.center =CGPointMake(375/2-300, 333);
//            self.swipView.alpha = 1;
//
//        }];
//        return;
//    }
//    NSLog(@"%ld",recognizer.state);
//    NSLog(@"123123");
   CGFloat  direction =  [recognizer translationInView:self.view].x;
    CGFloat offsetX = [recognizer locationInView:self.view].x;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.BeginX =  [recognizer locationInView:self.MyTabBarVCView].x;
    }
    
    
    if (direction>0&&self.BeginX<150) {
       
        self.RightView.hidden = YES;
        self.LeftView.hidden = NO;
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            if (offsetX> 300) {
                offsetX = 300;
//                self.swipView.alpha = 1;
            }
            self.LeftView.center = CGPointMake(offsetX/2, 333);
            self.MyTabBarVCView.center =CGPointMake(offsetX+375/2, 333);
            self.swipView.alpha = offsetX/300;
            
            
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded)
        {
            
            if (offsetX>375/2 ) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.LeftView.center = CGPointMake(150, 333);
                    self.MyTabBarVCView.center =CGPointMake(300+375/2, 333);
                    self.swipView.alpha = 1;
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.LeftView.center = CGPointMake(0, 333);
                    self.MyTabBarVCView.center =CGPointMake(375/2, 333);
                    self.swipView.alpha = 0;
                }];
                
            }
            
        }
        
    }else if (direction>0&&self.BeginX>225){
        if (self.RightView.hidden ==YES) {
        return;
        }
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            if (offsetX<75) {
                offsetX = 75;
            }
            self.RightView.center = CGPointMake(375-150+(offsetX-75)/2, 333);
            self.MyTabBarVCView.center =CGPointMake(-375/2+offsetX, 333);
            self.swipView.alpha = (375-offsetX)/300;
//
//            if (offsetX< 75) {
//                self.RightView.center = CGPointMake(375-150, 333);
//                self.MyTabBarVCView.center =CGPointMake(375/2-300, 333);
//                self.swipView.alpha = 1;
//            }
        }else if (recognizer.state == UIGestureRecognizerStateEnded)
        {
//            self.recognizer.enabled = NO;
            if (offsetX>375/2 ) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.RightView.center = CGPointMake(375, 333);
                    self.MyTabBarVCView.center =CGPointMake(375/2, 333);
                    self.swipView.alpha = 0;
                    
                }completion:^(BOOL finished) {
                    self.RightView.hidden = YES;
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.RightView.center = CGPointMake(375-150, 333);
                    self.MyTabBarVCView.center =CGPointMake(375/2-300, 333);
                    self.swipView.alpha = 1;
                }];
            }
        }
        
    }
    
    
    
    
    else if (direction<0&&self.BeginX<150)
    {
        if (self.LeftView.hidden==YES) {
            return;
        }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (offsetX>300) {
            offsetX=300;
        }
            self.LeftView.center = CGPointMake(offsetX/2, 333);
            self.MyTabBarVCView.center =CGPointMake(offsetX+375/2, 333);
            self.swipView.alpha = offsetX/300;
            
//            if (offsetX< 75) {
//                self.RightView.center = CGPointMake(375-150, 333);
//                self.MyTabBarVCView.center =CGPointMake(375/2-300, 333);
//                self.swipView.alpha = 1;
//            }
        }else if (recognizer.state == UIGestureRecognizerStateEnded)
        {
//            self.recognizer.enabled = NO;
            if (offsetX>375/2 ) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.LeftView.center = CGPointMake(150, 333);
                    self.MyTabBarVCView.center =CGPointMake(375/2+300, 333);
                    self.swipView.alpha = 1;
                }completion:^(BOOL finished) {
                    
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.LeftView.center = CGPointMake(0, 333);
                    self.MyTabBarVCView.center =CGPointMake(375/2, 333);
                    self.swipView.alpha = 0;
                }completion:^(BOOL finished) {
                    self.LeftView.hidden = YES;
                }];
            }
            
        }
        
        
    }    else if (direction<0&&self.BeginX>225){
        
        
        if (offsetX<75) {
            offsetX = 75;
        }
        self.RightView.hidden = NO;
        self.LeftView.hidden = YES;
            if (recognizer.state == UIGestureRecognizerStateChanged) {
              
                self.RightView.center = CGPointMake(375-(375-offsetX)/2, 333);
                self.MyTabBarVCView.center =CGPointMake(375/2-(375-offsetX), 333);
                self.swipView.alpha = (375-offsetX)/300;
                
                //            if (offsetX< 75) {
                //                self.RightView.center = CGPointMake(375-150, 333);
                //                self.MyTabBarVCView.center =CGPointMake(375/2-300, 333);
                //                self.swipView.alpha = 1;
                //            }
            }else if (recognizer.state == UIGestureRecognizerStateEnded)
            {
                //            self.recognizer.enabled = NO;
                if (offsetX>375/2 ) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.RightView.center = CGPointMake(375, 333);
                        self.MyTabBarVCView.center =CGPointMake(375/2, 333);
                        self.swipView.alpha = 0;
                    }completion:^(BOOL finished) {
                        self.RightView.hidden = YES;
                    }];
                    
                }else{
                    [UIView animateWithDuration:0.3 animations:^{
                        self.RightView.center = CGPointMake(375-300+150, 333);
                        self.MyTabBarVCView.center =CGPointMake(75-375/2, 333);
                        self.swipView.alpha = 1;
                    }completion:^(BOOL finished) {
                        
                    }];
                }
                
            }
            
            
        }
        
    

}

- (void)swipView:(UIPanGestureRecognizer *)recognizer
{
    if (self.MyTabBarVCView.center.x!=375/2) {
        [UIView animateWithDuration:0.5 animations:^{
            self.LeftView.center = CGPointMake(0, 333);
            self.RightView.center = CGPointMake(375-150, 333);
            self.MyTabBarVCView.center =CGPointMake(375/2, 333); }];
        self.swipView.alpha = 0;
    }

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer locationInView:self.MyTabBarVCView].x<100||[gestureRecognizer locationInView:self.MyTabBarVCView].x>375-40) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
