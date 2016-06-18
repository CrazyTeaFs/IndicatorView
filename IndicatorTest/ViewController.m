//
//  ViewController.m
//  IndicatorTest
//
//  Created by gameloft on 16/6/18.
//  Copyright © 2016年 gameloft. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

#define NAVIGATEHEIGHT self.navigationController.navigationBar.bounds.size.height + \
[UIApplication sharedApplication].statusBarFrame.size.height

@interface ViewController ()

//** indicator */
@property (nonatomic, weak) UIView *indicatorView;

//** red line */
@property (nonatomic, weak) UIView *indicatorLine;

//** button */
@property (nonatomic, weak) UIButton *indicatorDisableBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建指示器
    [self setupIndicator];
}

/**
 *  我们来创建指示器！
 */
- (void)setupIndicator
{
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.frame = CGRectMake(0, NAVIGATEHEIGHT, self.view.bounds.size.width, 35);
    //设置一个背景色，先设置半透明红色，方便我们观察
    indicatorView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    //保存到属性中，后面会用到
    self.indicatorView = indicatorView;
    [self.view addSubview:indicatorView];
    
    //这里用到的height、x、y、width都是我给UIView写的分类中的方法。
    //因为不能直接给这些属性赋值，必须创建一个frame，然后替换控件原有的frame才能达到更改x，y，宽高等属性的目的
    //所以我写了个UIView分类来实现了这些属性的getter和setter方法，方便使用
    UIView *indicatorLine = [[UIView alloc] init];
    indicatorLine.height = 2;
    indicatorLine.y = indicatorView.height - indicatorLine.height;
    indicatorLine.width = 40;
    indicatorLine.x = 0;
    //先给个绿色，方便观察
    indicatorLine.backgroundColor = [UIColor redColor];
    //保存到属性中
    self.indicatorLine = indicatorLine;
    //注意，这里是self.indicatorView，不是self.view，因为我们要把红线添加到indicatorView里
    [self.indicatorView addSubview:indicatorLine];
    
    //添加4个button
    NSArray *titles = @[@"个性推荐", @"歌单", @"主播电台", @"排行榜"];
    CGFloat buttonHeight = indicatorView.height;
    CGFloat buttonWidth = indicatorView.width / 4;
    CGFloat buttonY = 0;
    NSUInteger count = 4;
    
    for (int i = 0; i < count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        //正常状态下title为黑色
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        ////这里注意要使用Disable状态，防止button被选中后(selected)一直是红色，导致所有button变红
        //后面会设置button的disable状态来调整button中文字的颜色
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        btn.frame = CGRectMake(buttonWidth * i, buttonY, buttonWidth, buttonHeight);
        //修改title字体
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        //button 添加响应事件
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            //默认选中第一个button，并disable它
            btn.enabled = NO;
            //保存disable的button到属性中，方便后面更改被disable的button的状态
            self.indicatorDisableBtn = btn;
            
            //这个必须调用，不然指示器的frame不正确。
            [btn layoutIfNeeded];
            
            //重新设置红线宽度和位置,让它移动到第一个button的位置
            self.indicatorLine.width = btn.titleLabel.width;
            self.indicatorLine.centerX = btn.centerX;
        }
        
        [self.indicatorView addSubview:btn];
    }
}

- (void)btnClicked:(UIButton *)btn
{
    //设置上次点击被disable的button为enable状态
    self.indicatorDisableBtn.enabled = YES;
    //当前点击的button为disable状态，好显示红色title
    btn.enabled = NO;
    //保存当前点击的button
    self.indicatorDisableBtn = btn;
    
    //设置红线的动画
    [UIView animateWithDuration:0.2f animations:^{
        self.indicatorLine.width = btn.titleLabel.width;
        self.indicatorLine.centerX = btn.centerX;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
