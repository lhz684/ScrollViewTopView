//
//  LHZTopScrollView.h
//  ScrollTopView
//
//  Created by 684lhz on 2019/5/29.
//  Copyright © 2019年 684lhz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHZTopScrollView : UIScrollView

/** 添加topView */
- (void)addTopView:(UIView *)topView;
/** 显示topView */
- (void)showTopView;
@end

NS_ASSUME_NONNULL_END
