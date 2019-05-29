//
//  LHZTopScrollView.m
//  ScrollTopView
//
//  Created by 684lhz on MinContentOffSetYHidden19/5/29.
//  Copyright © MinContentOffSetYHidden19年 684lhz. All rights reserved.
//

#import "LHZTopScrollView.h"

NSString *const LHZTopViewKeyContentOffset = @"contentOffset";
NSString *const LHZTopViewKeyPathPanState = @"state";

CGFloat const MaxContentOffsetYWillShow = 70.0;
CGFloat const MinContentOffSetYHidden = 30.0;

typedef NS_ENUM(NSInteger, LHZTopState){
    LHZTopStateHiden,
    LHZTopStateWillHiden,
    LHZTopStatePulling,
    LHZTopStateWillShow,
    LHZTopStateShow
};

@interface LHZTopScrollView ()

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, assign) LHZTopState state ; ///<
@end

@implementation LHZTopScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addObserver];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addObserver];
    }
    return self;
}

- (void)setState:(LHZTopState)state {
    _state = state;
    CGFloat contentOffsetY = self.contentOffset.y;
    
    if (state == LHZTopStateShow) {
        [self showTopView];
    }else if (state == LHZTopStatePulling) {
        CGFloat alpha = (fabs(contentOffsetY) - MinContentOffSetYHidden) / (MaxContentOffsetYWillShow - MinContentOffSetYHidden);
        NSLog(@"%.2f", alpha);
        [self showTopViewWithAlpha:alpha];
    }else if (state == LHZTopStateHiden){
        [self hiddenTopView];
    }else if (state == LHZTopStateWillShow) {
        [self showTopViewWithAlpha:1];
    }else if (state == LHZTopStateWillHiden) {
        [self showTopViewWithAlpha:0];
    }
}

/** 添加topView */
- (void)addTopView:(UIView *)topView {
    self.topView = topView;
    self.topView.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height);
    [self addSubview:self.topView];
    self.topView.alpha = 0;
    self.state = LHZTopStateHiden;
}

/** 显示topView */
- (void)showTopView {
    _state = LHZTopStateShow;
    self.topView.frame = CGRectMake(self.contentOffset.x, -self.topView.frame.size.height, self.topView.frame.size.width, self.topView.frame.size.height);
    self.topView.alpha = 1;
    [self setContentInset:UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0)];
    [self setContentOffset:CGPointMake(self.contentOffset.x, -self.topView.frame.size.height) animated:YES];
}

/** 显示topView alpha 根据下拉程度变化 */
- (void)showTopViewWithAlpha:(CGFloat)alpha {
    self.topView.frame = CGRectMake(self.contentOffset.x, -self.topView.frame.size.height, self.topView.frame.size.width, self.topView.frame.size.height);
    self.topView.alpha = alpha;
}

/** 隐藏topView */
- (void)hiddenTopView {
    [self setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self showTopViewWithAlpha:0];
}

#pragma mark - 观察者

- (void)addObserver {
    [self addObserver:self forKeyPath:LHZTopViewKeyContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [self.panGestureRecognizer addObserver:self forKeyPath:LHZTopViewKeyPathPanState options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    [self removeObserver:self forKeyPath:LHZTopViewKeyContentOffset];
    [self.panGestureRecognizer removeObserver:self forKeyPath:LHZTopViewKeyPathPanState];
}

- (void)dealloc {
    [self removeObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:LHZTopViewKeyContentOffset]) {
        CGFloat contentOffsetY = self.contentOffset.y;
        switch (self.state) {
            case LHZTopStateHiden:
                {
                    if (contentOffsetY < -MinContentOffSetYHidden) {
                        self.state = LHZTopStatePulling;
                    }
                }
                break;
            case LHZTopStateWillHiden:
            {
                if (contentOffsetY < -MinContentOffSetYHidden) {
                    self.state = LHZTopStatePulling;
                }else {
                    self.state = LHZTopStateWillHiden;
                }
            }
                break;
            case LHZTopStatePulling:
                {
                    if (contentOffsetY < - MaxContentOffsetYWillShow) {
                        self.state = LHZTopStateWillShow;
                    }else if (contentOffsetY > - MinContentOffSetYHidden) {
                        self.state = LHZTopStateWillHiden;
                    }else {
                        self.state = LHZTopStatePulling;
                    }
                }
                break;
            case LHZTopStateWillShow:
                {
                    if (contentOffsetY < - MinContentOffSetYHidden && contentOffsetY > - MaxContentOffsetYWillShow) {
                        self.state = LHZTopStatePulling;
                    }else if (contentOffsetY > - MinContentOffSetYHidden) {
                        self.state = LHZTopStateHiden;
                    }
                }
                break;
            case LHZTopStateShow:
            {
                if (contentOffsetY < - MaxContentOffsetYWillShow) {
                    self.state = LHZTopStatePulling;
                }else if (contentOffsetY > - MinContentOffSetYHidden) {
                    self.state = LHZTopStateHiden;
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    if ([keyPath isEqualToString:LHZTopViewKeyPathPanState]) {
        if (self.state == LHZTopStateHiden) {
            return;
        }
        
        if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (self.state == LHZTopStateWillShow) {
                [self showTopView];
            }else if (self.state == LHZTopStatePulling || self.state == LHZTopStateWillHiden) {
                [self hiddenTopView];
            }
        }
    }
}



@end
