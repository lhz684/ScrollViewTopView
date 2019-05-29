//
//  ViewController.m
//  ScrollTopView
//
//  Created by 684lhz on 2019/5/29.
//  Copyright © 2019年 684lhz. All rights reserved.
//

#import "ViewController.h"
#import "LHZTopScrollView.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet LHZTopScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.scrollView addTopView: view];
    [self.scrollView showTopView];
}


@end
