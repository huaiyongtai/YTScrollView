//
//  YTScrollView.m
//  A-3-ScrollerView实现
//
//  Created by HelloWorld on 15/9/23.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import "YTScrollView.h"
#import <pop/POP.h>

@implementation YTScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    
        [self setClipsToBounds:YES];
        
        _scrollHorizontal = YES;
        _scrollVertical = YES;
        _contentSize = CGSizeMake(100, 2000);

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollView:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}


- (void)scrollView:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStatePossible: {
            NSLog(@"UIGestureRecognizerStatePossible");
            break;
        }
        case UIGestureRecognizerStateBegan: {   //手势开始被识别状态
            [self pop_removeAnimationForKey:@"decelerateAnimation"];
            [self pop_removeAnimationForKey:@"resetAnimation"];
            break;
        }
        case UIGestureRecognizerStateChanged: { //手势状态变化
            
            //拖动的偏移值
            CGPoint offsetPoint = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            
            CGRect bounds = self.bounds;
            if (self.isScrollHorizontal) {
                //Bounds的最新X值
                CGFloat newBoundsOriginX = bounds.origin.x + (-offsetPoint.x);
                //Bounds的最小X值（固定）
                CGFloat minBoundsOriginX = 0.0;
                //Bounds的最大X值（固定值，boundsX 最大contentSize.w - bounds.w）
                CGFloat maxBoundsOriginX = self.contentSize.width - bounds.size.width;
                //限制Bounds的X值大小, 取得合适的值（新值应该小于最大值 大于最小值）
                CGFloat constrainedBoundsOriginX = MAX(minBoundsOriginX, MIN(newBoundsOriginX, maxBoundsOriginX));
                bounds.origin.x = constrainedBoundsOriginX ;
            }
            
            if (self.isScrollHorizontal) {
                CGFloat newBoundsOriginY = bounds.origin.y + (-offsetPoint.y);
                CGFloat minBoundsOriginY = 0.0;
                CGFloat maxBoundsOriginY = self.contentSize.height - bounds.size.height;
                CGFloat constrainedBoundsOriginY = MAX(minBoundsOriginY, MIN(newBoundsOriginY, maxBoundsOriginY));
                bounds.origin.y = constrainedBoundsOriginY + (newBoundsOriginY-constrainedBoundsOriginY)*0.5;
            }
            self.bounds = bounds;
            
            //归零上次的拖动值
            [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
            break;
        }
        case UIGestureRecognizerStateEnded: {   //手势状态结束
            
            CGPoint velocity = [panGestureRecognizer velocityInView:self];
            if (self.bounds.size.width >= self.contentSize.width) {
                velocity.x = 0;
            }
            if (self.bounds.size.height >= self.contentSize.height) {
                velocity.y = 0;
            }
            
            //我们需要将从滑动手势中得到的速率转换成负号，所以我们改变了一下符号。
            velocity.x = -velocity.x;
            velocity.y = -velocity.y;

            //创建一个衰减动画
            POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
            //设定动画属性
            POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"HuaiYongtai"
                                                                      initializer:^(POPMutableAnimatableProperty *prop) {
                //readBlock告诉POP当前的属性值
                prop.readBlock = ^(id obj, CGFloat values[]) {
                    NSLog(@"readBlock values: %f", values[1]);
                    values[0] = [obj bounds].origin.x;
                    values[1] = [obj bounds].origin.y;
                };
                //readBlock告诉POP当前的属性值
                prop.writeBlock = ^(id obj, const CGFloat values[]) {
                    CGRect tempBounds = [obj bounds];
                    NSLog(@"writeBlock values: %f", values[1]);
                    tempBounds.origin.x = values[0];
                    tempBounds.origin.y = values[1];
                    [obj setBounds:tempBounds];
                    
                    if (values[1] < 0 || values[1] > ([obj contentSize].height - [obj bounds].size.height)) {
                        //减速
                        decayAnimation.deceleration = 0.92;
                    }
                };
                //threashold决定了动画变化间隔的阈值，值越大writeBlock的调用次数越少
                prop.threshold = 0.5;
            }];
            
            decayAnimation.property = prop;
            decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            
            //动画完成后对Bounds的X、Y进行校准动画
            __weak typeof(self) weakSelf = self;
            decayAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
                
                CGFloat maxBoundsOriginY = weakSelf.contentSize.height - weakSelf.bounds.size.height;
                if (weakSelf.bounds.origin.y < 0 || weakSelf.bounds.origin.y > maxBoundsOriginY) {
                    CGRect tempBounds = [weakSelf bounds];
                    
                    if (weakSelf.bounds.origin.y < 0) {
                        tempBounds.origin.y = 0;
                    } else {
                        tempBounds.origin.y = maxBoundsOriginY;
                    }
                    
                    POPBasicAnimation *resetAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBounds];
                    resetAnimation.toValue = [NSValue valueWithCGRect:tempBounds];
                    [weakSelf pop_addAnimation:resetAnimation forKey:@"resetAnimation"];
                }
            };
            
            [self pop_addAnimation:decayAnimation forKey:@"decelerateAnimation"];
            NSLog(@"UIGestureRecognizerStateEnded");
            break;
        }
        case UIGestureRecognizerStateCancelled: {   //取消手势
            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
        }
        case UIGestureRecognizerStateFailed: {
            NSLog(@"UIGestureRecognizerStateFailed");
            break;
        }
        default: {
            NSLog(@"default");
            break;
        }
    }
}

@end
