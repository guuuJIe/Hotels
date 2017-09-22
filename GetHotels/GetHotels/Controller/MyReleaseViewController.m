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
#import "UserModel.h"
#import "ReleaseModel.h"
#import "OfferViewController.h"
@interface MyReleaseViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger isReleasedFlag;
    NSInteger histroyFlag;
    
    NSInteger didReleaseNum;
    BOOL didReleaseLast;
    
    NSInteger isReleasedNum;
    BOOL isReleasedLast;
    
    NSInteger pageSize;
    
    NSInteger histroyNum;
    BOOL histroyLast;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *didReleaseTableView;
@property (weak, nonatomic) IBOutlet UITableView *isReleasedTableView;
@property (weak, nonatomic) IBOutlet UITableView *histroyTableView;
@property (strong,nonatomic) HMSegmentedControl *segmentcontrol;
@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property ( nonatomic)CGRect rectStatus;
@property ( nonatomic)CGRect rectNav;

@property(strong,nonatomic)NSMutableArray *isReleasedArr;
@property(strong,nonatomic)NSMutableArray *didReleaseArr;
@property(strong,nonatomic)NSMutableArray *histroyArr;

@property (strong, nonatomic) UIImageView *didReleaseNothingImg;
@property (strong, nonatomic) UIImageView *isReleasedNothingImg;
@property (strong, nonatomic) UIImageView *histroyNothingImg;
@end

@implementation MyReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageSize = 5;
    isReleasedFlag = 1;
    histroyFlag = 1;
    didReleaseNum = 1;
    isReleasedNum = 1;
    histroyNum = 1;
    _isReleasedArr = [NSMutableArray new];
    _didReleaseArr = [NSMutableArray new];
    _histroyArr = [NSMutableArray new];
    _rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏（navigationbar）
    _rectNav = self.navigationController.navigationBar.frame;
    _didReleaseTableView.tableFooterView = [UIView new];
    _isReleasedTableView.tableFooterView = [UIView new];
    _histroyTableView.tableFooterView = [UIView new];
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self setsegment];
    [self refreshControl];
    [self didReleasedRequest];
    //调用tableView没数据时显示图片的方法
    if (_didReleaseArr.count == 0) {
        [self nothingForTableView];
    }
    
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
    _segmentcontrol = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已成交",@"正在发布",@"历史记录"]];
    //设置位置，原点是模拟器左上角
    _segmentcontrol.frame = CGRectMake(0,0, UI_SCREEN_W, 40);
    //设置默认选中项为下标为 0 ；
    _segmentcontrol.selectedSegmentIndex = 0;
    //设置背景颜色
    _segmentcontrol.backgroundColor = [UIColor whiteColor];
    //设置                                                                                                                                                                          下划线的高度
    _segmentcontrol.selectionIndicatorHeight = 2.5;
    //设置选中状态的样式
    _segmentcontrol.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //选中时的标记
    _segmentcontrol.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentcontrol.borderType= HMSegmentedControlBorderTypeLeft;
    _segmentcontrol.borderColor =UIColorFromRGB(230, 230, 230);
    
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
    [self.navigationController popViewControllerAnimated:YES];
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
    isReleasedRefresh.tag = 201;
    [_isReleasedTableView addSubview:isReleasedRefresh];
    
    UIRefreshControl *histroyRefresh = [UIRefreshControl new];
    [histroyRefresh addTarget:self action:@selector(refreshHistroy) forControlEvents:UIControlEventValueChanged];
    histroyRefresh.tag = 202;
    [_histroyTableView addSubview:histroyRefresh];
}

//刷新已发布
-(void)refreshDidRelase{
    didReleaseNum = 1;
    [self didReleasedRequest];
}
//刷新正在发布
-(void)refreshIsReleased{
    isReleasedNum = 1;
    [self isReleasedRequest];
}
//刷新历史记录
-(void)refreshHistroy{
    histroyNum = 1;
    [self historyRequest];
}

//当tableView没有数据时显示图片的方法
- (void)nothingForTableView{
    _didReleaseNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
    _didReleaseNothingImg.frame = CGRectMake((UI_SCREEN_W - 100) / 2, 50, 100, 100);
    
    _isReleasedNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
    _isReleasedNothingImg.frame = CGRectMake(UI_SCREEN_W + (UI_SCREEN_W - 100) / 2, 50, 100, 100);
    
    _histroyNothingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_things"]];
    _histroyNothingImg.frame = CGRectMake(UI_SCREEN_W * 2 + (UI_SCREEN_W - 100) / 2, 50, 100, 100);
    
    [_scrollView addSubview:_didReleaseNothingImg];
    [_scrollView addSubview:_isReleasedNothingImg];
    [_scrollView addSubview:_histroyNothingImg];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/

//正在发布
-(void)isReleasedRequest{
    UserModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"openid": model.openid,@"pageNum" : @(isReleasedNum),@"pageSize" : @(pageSize),@"state" :@1};
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_isReleasedTableView viewWithTag:201];
        [ref endRefreshing];
        NSLog(@"正在发布:%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            NSArray *list = content[@"list"];
            isReleasedLast = [content[@"isLastPage"]boolValue];
            if (isReleasedNum == 1) {
                [_isReleasedArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                ReleaseModel *model = [[ReleaseModel alloc]initWithDict:dict];
                [_isReleasedArr addObject:model];
            }
            //当数组没有数据时将图片显示，反之隐藏
            if (_isReleasedArr.count == 0) {
                _isReleasedNothingImg.hidden = NO;
            }else{
                _isReleasedNothingImg.hidden = YES;
            }
            [_isReleasedTableView reloadData];
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    }failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_isReleasedTableView viewWithTag:201];
        [ref endRefreshing];
    }];
    
}
//已成交
-(void)didReleasedRequest{
    UserModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"openid": model.openid,@"pageNum" : @(didReleaseNum),@"pageSize" : @(pageSize),@"state" :@0};
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_didReleaseTableView viewWithTag:200];
        [ref endRefreshing];
        NSLog(@"已成交:%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            NSArray *list = content[@"list"];
            didReleaseLast = [content[@"isLastPage"]boolValue];
            if (didReleaseNum == 1) {
                [_didReleaseArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                ReleaseModel *model = [[ReleaseModel alloc]initWithDictForRelease:dict];
                [_didReleaseArr addObject:model];
            }
            //当数组没有数据时将图片显示，反之隐藏
            if (_didReleaseArr.count == 0) {
                _didReleaseNothingImg.hidden = NO;
            }else{
                _didReleaseNothingImg.hidden = YES;
            }
            [_didReleaseTableView reloadData];
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    }failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_didReleaseTableView viewWithTag:200];
        [ref endRefreshing];
        
    }];
    
}
//历史记录
-(void)historyRequest{
    UserModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UserInfo"];
    NSDictionary *para = @{@"openid": model.openid,@"pageNum" : @(histroyNum),@"pageSize" : @(pageSize),@"state" :@2};
    [RequestAPI requestURL:@"/findAllIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_histroyTableView viewWithTag:202];
        [ref endRefreshing];
        NSLog(@"历史记录:%@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            NSArray *list = content[@"list"];
            histroyLast = [content[@"isLastPage"]boolValue];
            if (histroyNum == 1) {
                [_histroyArr removeAllObjects];
            }
            for (NSDictionary *dict in list) {
                ReleaseModel *model = [[ReleaseModel alloc]initWithDictForHistroy:dict];
                [_histroyArr addObject:model];
            }
            //当数组没有数据时将图片显示，反之隐藏
            if (_histroyArr.count == 0) {
                _histroyNothingImg.hidden = NO;
            }else{
                _histroyNothingImg.hidden = YES;
            }
            [_histroyTableView reloadData];
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误,请稍后再试" andTitle:@"提示" onView:self];
        }
    }failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_histroyTableView viewWithTag:202];
        [ref endRefreshing];
        
    }];
    
}
#pragma mark - tableView
//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _didReleaseTableView) {
        return _didReleaseArr.count;
    }
    else if(tableView == _isReleasedTableView){
        return _isReleasedArr.count;
    }
    else{
        return _histroyArr.count;
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
        [self isReleasedRequest];
    }
    if (histroyFlag == 1 && page ==2) {
        histroyFlag = 0;
        [self historyRequest];
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
       // NSIndexPath *indexPath = [_isReleasedTableView indexPathForSelectedRow];
        //ReleaseModel *model = _isReleasedArr[indexPath.section];
        
        //2.获取下一页这个实例
        //OfferViewController *detailVC;
        //detailVC.IssueId = model.Id;
        [self performSegueWithIdentifier:@"MyReleaseToOffer" sender:indexPath ];
    }
    else{
        
    }
}
//每组有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _didReleaseTableView) {
        if (indexPath.section == _didReleaseArr.count -1) {
            if (!didReleaseLast) {
                didReleaseNum ++;
                [self didReleasedRequest];
            }
        }
    }else if (tableView == _isReleasedTableView) {
        //判断将要出现的组是不是当前显示的最后一组的组号
        if (indexPath.section == _isReleasedArr.count - 1) {
            //判断当前页是否为最后一页
            if (!isReleasedLast) {
                isReleasedNum ++;
                [self isReleasedRequest];
                NSLog(@"不是最后一页");
            }
        }
    }else{
        //判断将要出现的组是不是当前显示的最后一组的组号
        if (indexPath.section == _histroyArr.count - 1) {
            //判断当前页是否为最后一页
            if (!histroyLast) {
                histroyNum ++;
                [self historyRequest];
                NSLog(@"不是最后一页");
            }
        }
    }
}

//每行长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _didReleaseTableView) {
        DidRealeseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"didReleaseCell" forIndexPath:indexPath];
        ReleaseModel *model = _didReleaseArr[indexPath.section];
        cell.startTimeLab.text = model.startTime;
        cell.departureLab.text = model.departure;
        cell.destinationLab.text = model.destination;
        cell.priceLab.text =[NSString stringWithFormat:@"成交价:%ld", model.finalPrice];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.time / 1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"HH:mm";
        NSString *thDate = [formatter stringFromDate:date];
        NSInteger i = [thDate intValue];
        if (i<=12 && i>0) {
            cell.detailLab.text = [NSString stringWithFormat:@"上午 %@ 起飞", thDate];
        }else{
            cell.detailLab.text = [NSString stringWithFormat:@"下午 %@ 起飞", thDate];
        }
        cell.aviationDetail.text = model.aviationDemandDetail;
        return cell;
    }
    else if(tableView == _isReleasedTableView){
        IsReleasedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"isReleasedCell" forIndexPath:indexPath];
        ReleaseModel *model = _isReleasedArr[indexPath.section];
        cell.startTime.text = model.startTime;
        cell.departure.text = model.departure;
        cell.destination.text = model.destination;
        cell.price.text = [NSString stringWithFormat:@"%ld-%ld", model.lowPrice, model.highPrice];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.time  / 1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"HH";
        NSString *thDate = [formatter stringFromDate:date];
        NSInteger i = [thDate intValue];
        if (i<=12 && i>0) {
            cell.timeDetail.text = [NSString stringWithFormat:@"大约上午%@点左右", thDate];
        }else{
            cell.timeDetail.text = [NSString stringWithFormat:@"大约下午%@点左右", thDate];
        }
        cell.aviationDetail.text = model.aviationDemandDetail;
        return cell;
    }
    else{
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        ReleaseModel *model = _histroyArr[indexPath.section];
        cell.startTime.text = model.startTime;
        cell.departure.text = model.departure;
        cell.destination.text = model.destination;
        cell.price.text =[NSString stringWithFormat:@"成交价:%ld", model.finalPrice];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.time / 1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"HH:mm";
        NSString *thDate = [formatter stringFromDate:date];
        NSInteger i = [thDate intValue];
        if (i<=12 && i>0) {
            cell.time.text = [NSString stringWithFormat:@"上午 %@ 起飞", thDate];
        }else{
            cell.time.text = [NSString stringWithFormat:@"下午 %@ 起飞", thDate];
        }
        cell.detail.text = model.aviationDemandDetail;
        return cell;
    }
}
//当某一个页面跳转行为将要发生的时候
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"MyReleaseToOffer"]){
        //当从列表页到详情页的这个跳转要发生的时候
       // NSIndexPath *indexPath = [_isReleasedTableView indexPathForSelectedRow];
        NSIndexPath *indexPath = sender;
        ReleaseModel *model = _isReleasedArr[indexPath.section];
        NSLog(@"ahaiha:%ld", (long)model.Id);
        //2.获取下一页这个实例
        OfferViewController *detailVC = segue.destinationViewController ;
        //3、把数据给下一页预备好的接受容器
        detailVC.IssueId = model.Id;
        
        //1.获取要传递到下一页的数据
            }
}

@end
