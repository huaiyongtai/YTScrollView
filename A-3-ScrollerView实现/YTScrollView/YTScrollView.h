//
//  YTScrollView.h
//  A-3-ScrollerView实现
//
//  Created by HelloWorld on 15/9/23.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTScrollView : UIView

/**
 *  ScrollView的内容大小
 */
@property (nonatomic, assign) CGSize contentSize;

/**
 *  水平滚动
 */
@property (nonatomic, assign, getter = isScrollHorizontal) BOOL scrollHorizontal;

/**
 *  垂直滚动
 */
@property (nonatomic, assign, getter = isScrollVertical) BOOL scrollVertical;


@end
