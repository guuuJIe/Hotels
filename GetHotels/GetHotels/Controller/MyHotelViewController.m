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
@interface MyHotelViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger useableFirst;
    NSInteger datedFirst;
    
    NSInteger allOrdersNum;
    NSInteger useableOrdersNum;
    NSInteger datedOrdersNum;
}
@property (strong,nonatomic) HMSegmentedControl *segmentcontrol;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *AllOrderTableView;
@property (weak, nonatomic) IBOutlet UITableView *UseableOrderTableView;
@property (weak, nonatomic) IBOutlet UITableView *DatedOrderTableView;
@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property ( nonatomic)CGRect rectStatus;
@property ( nonatomic)CGRect rectNav;
@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    useableFirst = 1;
    datedFirst = 1;
    allOrdersNum = 1;
    useableOrdersNum = 1;
    datedOrdersNum  = 1;
    // 状态栏(statusbar)
    _rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏（navigationbar）
    _rectNav = self.navigationController.navigationBar.frame;
    // Do any additional setup after loading the view.
    [self setsegment];
    [self refreshControl];
    _AllOrderTableView.tableFooterView = [UIView new];
    _UseableOrderTableView.tableFooterView = [UIView new];
    _DatedOrderTableView.tableFooterView = [UIView new];
    [self AllOrdersRequest];
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
    _segmentcontrol.frame = CGRectMake(0,_rectStatus.size.height+_rectNav.size.height , UI_SCREEN_W, 40);
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
    _segmentcontrol.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(150, 150, 150),NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f]};
    //选中时的标题样式
    _segmentcontrol.selectedTitleTextAttributes =@{NSForegroundColorAttributeName:UIColorFromRGB(0, 115, 255),NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f]};
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
-(void)refreshControl{
    UIRefreshControl *allorderRefresh = [UIRefreshControl new];
    [allorderRefresh addTarget:self action:@selector(refreshAllOrder) forControlEvents:UIControlEventValueChanged];
    allorderRefresh.tag = 100;
    [_AllOrderTableView addSubview:allorderRefresh];
    
    UIRefreshControl *useableorderRefresh = [UIRefreshControl new];
    [useableorderRefresh addTarget:self action:@selector(refreshUseableOrder) forControlEvents:UIControlEventValueChanged];
    useableorderRefresh.tag = 101;
    [_UseableOrderTableView addSubview:useableorderRefresh];
    
    UIRefreshControl *datedorderRefresh = [UIRefreshControl new];
    [datedorderRefresh addTarget:self action:@selector(refreshDatedOrder) forControlEvents:UIControlEventValueChanged];
    datedorderRefresh.tag = 102;
    [_DatedOrderTableView addSubview:datedorderRefresh];
}
//刷新全部订单
-(void)refreshAllOrder{
    allOrdersNum = 1;
    [self AllOrdersRequest];
}
//刷新可用订单
-(void)refreshUseableOrder{
    useableOrdersNum = 1;
    [self UseableOrdersRequest];
}
//刷新过期订单
-(void)refreshDatedOrder{
    datedOrdersNum = 1;
    [self DatedOrdersRequest];
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
    UserModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"openid": model.openid,@"id" : @1};
       [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
       
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_AllOrderTableView viewWithTag:100];
        [ref endRefreshing];
        NSLog(@"Orders:%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    }failure:^(NSInteger statusCode, NSError *error) {
         
    }];
    
}
//可使用订单
-(void)UseableOrdersRequest{
    UserModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"openid":model.openid,@"id":@2};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"acquire:%@",responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_UseableOrderTableView viewWithTag:101];
        [ref endRefreshing];
        NSLog(@"可使用订单%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
    }];
    
}
//过期订单
-(void)DatedOrdersRequest{
    UserModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"openid":model.openid,@"id":@3};
    [RequestAPI requestURL:@"/findOrders_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"acquire:%@",responseObject);
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_DatedOrderTableView viewWithTag:102];
        [ref endRefreshing];
        NSLog(@"过期订单:%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            
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
#pragma mark - scrollView
//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        NSInteger page = [self scrollCheck:scrollView];
        //将segmentedControl设置选中的index为page,[scrollView当前显示的tableView]
        [_segmentcontrol setSelectedSegmentIndex:page animated:YES];
    }
    
}
//scrollView已经结束滚动的动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        [self scrollCheck:scrollView];
    }
}
//判断scrollView滚到哪一页
-(NSInteger)scrollCheck:(UIScrollView *)scrollView{
    //ScrollView中的contentoffset内容的左上角位置
    NSInteger page = scrollView.contentOffset.x/(scrollView.frame.size.width);
   // NSLog(@"scrollView.contentOffset.x = %f",scrollView.contentOffset.x);
    if (useableFirst == 1  && page == 1) {
        useableFirst =0;
        [self UseableOrdersRequest];
    }
    if (datedFirst == 1 && page ==2) {
        datedFirst = 0;
        [self DatedOrdersRequest];
    }
    return page;
}
#pragma mark - tableView
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
