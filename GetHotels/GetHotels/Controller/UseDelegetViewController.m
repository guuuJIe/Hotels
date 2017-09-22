//
//  UseDelegetViewController.m
//  GetHotels
//
//  Created by admin on 2017/9/21.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "UseDelegetViewController.h"

@interface UseDelegetViewController ()

@end

@implementation UseDelegetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
}

- (void)setNavigationItem {
     
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(23, 115, 232)];
    
    //实例化一个button，类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    
    //设置背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回3"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}


//自定义的返回按钮的事件
- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
