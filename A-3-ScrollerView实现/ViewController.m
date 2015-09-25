//
//  ViewController.m
//  A-3-ScrollerView实现
//
//  Created by HelloWorld on 15/9/22.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import "ViewController.h"
#import "YTScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor orangeColor]];
    
//    UIActivityIndicatorView *indicator =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 50, 40)];
//    [indicator setBackgroundColor:[UIColor redColor]];
//    [indicator startAnimating];
//    [self.view addSubview:indicator];
    
    
//    [self sysScrollView];
    [self customScrollView];
}

//自定义的ScrollView
- (void)customScrollView {
    
    YTScrollView *scrollView = [[YTScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, 400)];
    [scrollView setBackgroundColor:[UIColor grayColor]];
    
    CGFloat maxY = 0;
    CGFloat maxX = 0;
    for (int index=0; index<10; index++) {
        UIView *view = [self randomFrameView];
        [scrollView addSubview:view];
        
        if (CGRectGetMaxY(view.frame)>maxY) {
            maxY = CGRectGetMaxY(view.frame);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY-4, 320, 2)];
            [view setBackgroundColor:[UIColor redColor]];
            [scrollView addSubview:view];
        }
        
        if (CGRectGetMaxX(view.frame)>maxX) {
            maxX = CGRectGetMaxX(view.frame);
        }
    }
    [scrollView setContentSize:CGSizeMake(0, maxY)];
    [self.view addSubview:scrollView];
}

//系统ScrollView
- (void)sysScrollView {
    UIScrollView *sysScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, 400)];
    [sysScrollView setBackgroundColor:[UIColor grayColor]];
    
    CGFloat maxY = 0;
    CGFloat maxX = 0;
    for (int index=0; index<10; index++) {
        UIView *view = [self randomFrameView];
        [sysScrollView addSubview:view];
        
        if (CGRectGetMaxY(view.frame)>maxY) {
            maxY = CGRectGetMaxY(view.frame);
        }
        
        if (CGRectGetMaxX(view.frame)>maxX) {
            maxX = CGRectGetMaxX(view.frame);
        }
    }
    [sysScrollView setContentSize:CGSizeMake(0, maxY)];
    [self.view addSubview:sysScrollView];
    
    NSLog(@"%15f", 0.12);
    NSLog(@"%15f", 1.12);
    NSLog(@"%15f", 11.12);
    NSLog(@"%15f", 111.12);
    
    NSLog(@"%lf", @"123,456.00".floatValue);
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setPositiveFormat:@"###,###.00"];
}

//测试使用的View,来添加到ScrollView上
- (UIView *)randomFrameView {
    
    CGFloat viewWidth = arc4random_uniform(100)+10;
    CGFloat viewHeight = arc4random_uniform(200)+10;
    CGFloat viewX = arc4random_uniform(100);
    CGFloat viewY = arc4random_uniform(2000);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
    [view setBackgroundColor:RANDOMCOLOR];
    return view;
}






















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
