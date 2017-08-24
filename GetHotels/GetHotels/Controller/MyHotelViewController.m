//
//  MyHotelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/20.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyHotelViewController.h"
#import "HMSegmentedControl.h"
#import "AllOrdersTableViewCell.h"
#import "UseableOrderTableViewCell.h"
#import "DatedOrderTableViewCell.h"
@interface MyHotelViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) HMSegmentedControl *segmentcontrol;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *AllOrderTableView;
@property (weak, nonatomic) IBOutlet UITableView *UseableOrderTableView;
@property (weak, nonatomic) IBOutlet UITableView *DatedOrderTableView;
@property (strong,nonatomic) UIActivityIndicatorView *aiv;
@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setsegment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//页面将要出现的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationItem];
}

//设置菜单栏的方法
-(void)setsegment{
    //设置菜单栏主题字体
    _segmentcontrol = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部订单",@"可使用",@"已过期"]];
    //设置位置，原点是模拟器左上角
    _segmentcontrol.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+30, UI_SCREEN_W, 40);
    //设置默认选中项为下标为 0 ；
    _segmentcontrol.selectedSegmentIndex = 0;
    //设置背景颜色
    _segmentcontrol.backgroundColor = [UIColor whiteColor];
    //设置下划线的高度
    _segmentcontrol.selectionIndicatorHeight = 2.5;
    //设置选中状态的样式
    _segmentcontrol.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //选中时的标记
    _segmentcontrol.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //设置未选中的标题属性
    _segmentcontrol.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(230, 230, 230),NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f]};
    //选中时的标题样式
    _segmentcontrol.selectedTitleTextAttributes =@{NSForegroundColorAttributeName:UIColorFromRGB(23, 115, 232),NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f]};
    __weak typeof(self) weakSelf = self;
    [_segmentcontrol setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * index, 0, UI_SCREEN_W,200) animated:YES];
    }];

    [self.view addSubview:_segmentcontrol];
}
//设置导航样式
- (void)setNavigationItem {
    //设置导航栏的背景颜色
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(23, 115, 232)];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//全部订单
-(void)AllOrdersRequest{
    NSDictionary *para = @{@"openid":@"",@"id":@1};
    [RequestAPI requestURL:@"/findOrders" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"acquire:%@",responseObject);
        [_aiv stopAnimating];
        //防范式编程   强制转换(UIRefreshControl *)
        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
           
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
    }];
    
}
//可使用订单
-(void)UseableOrdersRequest{
    NSDictionary *para = @{@"openid":@"",@"id":@2};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"acquire:%@",responseObject);
        [_aiv stopAnimating];
        //防范式编程   强制转换(UIRefreshControl *)
        NSLog(@"%@",responseObject);
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
    }];
    
}

#pragma mark - tableView
//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _AllOrderTableView) {
        return 1;
    }
    else if(tableView == _UseableOrderTableView){
        return 1;
    }
    else{
        return 1;
    }
}
//细胞有多高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}
//哪行细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//每组有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//每行长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _AllOrderTableView) {
        AllOrdersTableViewCell *AllOrderCell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderCell" forIndexPath:indexPath];
        return AllOrderCell;
    }
    else if(tableView == _UseableOrderTableView){
        UseableOrderTableViewCell *useableCell = [tableView dequeueReusableCellWithIdentifier:@"UseableOrderCell" forIndexPath:indexPath];
        return useableCell;
    }
    else{
        DatedOrderTableViewCell *datedCell = [tableView dequeueReusableCellWithIdentifier:@"DatedOrderCell" forIndexPath:indexPath];
        return datedCell;
       
    }

}
@end
