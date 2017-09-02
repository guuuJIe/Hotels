//
//  MyReleaseViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyReleaseViewController.h"
#import "HMSegmentedControl.h"
#import "DidRealeseTableViewCell.h"
#import "IsReleasedTableViewCell.h"
#import "HistoryTableViewCell.h"
@interface MyReleaseViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger isReleasedFlag;
    NSInteger histroyFlag;
    
    NSInteger didReleaseNum;
    NSInteger isReleasedNum;
    NSInteger histroyNum;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *didReleaseTableView;
@property (weak, nonatomic) IBOutlet UITableView *isReleasedTableView;
@property (weak, nonatomic) IBOutlet UITableView *histroyTableView;
@property (strong,nonatomic) HMSegmentedControl *segmentcontrol;
@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property ( nonatomic)CGRect rectStatus;
@property ( nonatomic)CGRect rectNav;
@end

@implementation MyReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isReleasedFlag = 1;
    histroyFlag = 1;
    didReleaseNum = 1;
    isReleasedNum = 1;
    histroyNum = 1;
    _rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏（navigationbar）
    _rectNav = self.navigationController.navigationBar.frame;
    _didReleaseTableView.tableFooterView = [UIView new];
    _isReleasedTableView.tableFooterView = [UIView new];
    _histroyTableView.tableFooterView = [UIView new];
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
    _segmentcontrol = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已发布",@"正在发布",@"历史记录"]];
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
//创建刷新指示器
-(void)refreshControl{
    UIRefreshControl *didRelaseRefresh = [UIRefreshControl new];
    [didRelaseRefresh addTarget:self action:@selector(refreshDidRelase) forControlEvents:UIControlEventValueChanged];
    didRelaseRefresh.tag = 200;
    [_didReleaseTableView addSubview:didRelaseRefresh];
    
    UIRefreshControl *isReleasedRefresh = [UIRefreshControl new];
    [isReleasedRefresh addTarget:self action:@selector(refreshIsReleased) forControlEvents:UIControlEventValueChanged];
    didRelaseRefresh.tag = 201;
    [_isReleasedTableView addSubview:isReleasedRefresh];
    
    UIRefreshControl *histroyRefresh = [UIRefreshControl new];
    [histroyRefresh addTarget:self action:@selector(refreshHistroy) forControlEvents:UIControlEventValueChanged];
    didRelaseRefresh.tag = 202;
    [_histroyTableView addSubview:histroyRefresh];
}

//刷新已发布
-(void)refreshDidRelase{
    didReleaseNum = 1;
    
}
//刷新正在发布
-(void)refreshIsReleased{
    isReleasedNum = 1;
   
}
//刷新历史记录
-(void)refreshHistroy{
    histroyNum = 1;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableView
//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _didReleaseTableView) {
        return 1;
    }
    else if(tableView == _isReleasedTableView){
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
    if (isReleasedFlag == 1  && page == 1) {
        isReleasedFlag =0;
        
    }
    if (histroyFlag == 1 && page ==2) {
        histroyFlag = 0;
        
    }
    return page;
}

//细胞有多高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}
//哪行细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _didReleaseTableView) {
        
    }
    else if(tableView == _isReleasedTableView){
        [self performSegueWithIdentifier:@"MyReleaseToOffer" sender:self];
    }
    else{
        
    }
}
//每组有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//每行长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _didReleaseTableView) {
        DidRealeseTableViewCell *didReleaseCell = [tableView dequeueReusableCellWithIdentifier:@"didReleaseCell" forIndexPath:indexPath];
        return didReleaseCell;
    }
    else if(tableView == _isReleasedTableView){
        IsReleasedTableViewCell *isReleasedCell = [tableView dequeueReusableCellWithIdentifier:@"isReleasedCell" forIndexPath:indexPath];
        return isReleasedCell;
    }
    else{
        HistoryTableViewCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        return historyCell;
    }
    
}
@end
