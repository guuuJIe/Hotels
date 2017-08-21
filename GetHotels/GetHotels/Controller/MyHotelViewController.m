//
//  MyHotelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/20.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyHotelViewController.h"
#import "HMSegmentedControl.h"
@interface MyHotelViewController ()
@property (strong,nonatomic) HMSegmentedControl *segmentcontrol;
@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置菜单栏的方法
-(void)setsegment{
    //设置菜单栏主题字体
    _segmentcontrol = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部订单",@"可使用",@"已过期"]];
        [self.view addSubview:_segmentcontrol];
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
