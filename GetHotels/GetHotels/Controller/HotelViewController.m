//
//  HotelViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelViewController.h"
#import "HotelTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <UIImageView+WebCache.h>
#import "HotelListModel.h"
#import "HotelDetailViewController.h"
#import "HomeMarkTableViewCell.h"
#import "SKTagView.h"
#import "JSONS.h"
#import "CityTableViewController.h"
@interface HotelViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
    BOOL scrollFlag;
    BOOL firstVisit;
    BOOL isLastPage;
    BOOL selectBool;
    double longitude;
    double latitude;
    NSInteger flag;
    NSInteger selectCirfimBool;
    
    NSInteger PageNum;
    NSInteger pageSize;
    
    NSInteger scrollPage;
    NSInteger sortID;
    NSInteger starTestID;
    NSInteger starID;
    NSInteger priceID;
    NSInteger priceTestID;
    NSInteger otherPreIdxOne;
    NSInteger otherPreIdxTwo;
    NSInteger otherIndexOne;
    NSInteger otherIndexTwo;
}
@property (weak, nonatomic) IBOutlet UIButton *homeLocation;
@property (weak, nonatomic) IBOutlet UIButton *
    searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;

@property (weak, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeImg;
@property (weak, nonatomic) IBOutlet UIImageView *fourImg;
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UITableView *markTabelView;
@property (weak, nonatomic) IBOutlet SKTagView *selectTagView;
@property (weak, nonatomic) IBOutlet SKTagView *selectTwoTagView;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePick;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UIView *homeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transviewPosotion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageTop;

- (IBAction)searchAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)doneAction:(UIBarButtonItem *)sender;
- (IBAction)selectTagCfirmAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)locAction:(UIButton *)sender forEvent:(UIEvent *)event;
 

@property (strong, nonatomic) CLLocationManager *locMgr;
@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) NSMutableArray *hotelArr;
@property (strong, nonatomic) NSMutableArray *advImgArr;
@property (strong, nonatomic) NSString *inTimeDate;
@property (strong, nonatomic) NSString *outTimeDate;
@property (strong, nonatomic) NSArray *sortArr;
@property (strong, nonatomic) UIView *mark;
@property (strong, nonatomic) HomeMarkTableViewCell *mCell;
@property (strong, nonatomic) HotelListModel *model;

@property (strong, nonatomic) UIButton *inTime;
@property (strong, nonatomic) UIButton *outTime;
@property (strong, nonatomic) UIButton *sortBtn;
@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic) UIView *cellHeaderView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSTimer *dt;
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //textField协议
    _searchTextView.delegate = self;
    //把状态栏变成白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    //半透明开关
    //self.navigationController.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTranslucent:NO];
    
    //设置datePick背景色
    _datePick.backgroundColor = UIColorFromRGB(235, 235, 241);
    //去掉tableview底部多余的线
    _hotelTableView.tableFooterView = [UIView new];
    //将输入框变为无边框样式
    _searchTextView.borderStyle = UITextBorderStyleNone;
    //去掉scrollView横向滚动标示
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    [self duration];
    //滑动点设为4个
    _pageControl.numberOfPages = 4;
    
    _searchTextView.text = @"";
    
    // Do any additional setup after loading the view.
    
    //初始化数组
    _hotelArr = [NSMutableArray new];
    _advImgArr = [NSMutableArray new];
    
    firstVisit = YES;
    selectBool = YES;
    selectCirfimBool = NO; 
    [self buttonAtt];
    //各种赋初值
    PageNum = 1;
    pageSize = 8;
    starTestID = 1;
    priceTestID = 1;
    selectCirfimBool = 0;
    scrollPage = 0;
    
    [self setDefaultDateForButton];
    [self locationConfig];          //开始定位
    [self enterApp];                //判断是否第一次进入app
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(chooseCity:) name:@"ResetCity" object:nil];
    //调用蒙层和刷新指示器
    [self initializeData];
    [self refresh];
    [self selectStar];
    _sortArr = @[@"智能排序",@"价格低到高",@"价格高到低",@"离我从近到远"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _markView.frame = CGRectMake(0, _HeadView.frame.size.height + 40, UI_SCREEN_W, 400);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    //[[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self locationStart];
    [self geocodeAddressString];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = YES;
//    //取消定时器
//    [_dt invalidate];
//    _dt = nil;
}

//-(BOOL)isDisplayedInScreen{
    
//}
//================================================================定位相关
-(void)locationConfig{
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //设置定位到的设备位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置把地球设置分割成边长多少的精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;

}
//这个方法处理开始定位
-(void)locationStart{
    //判断用户有没有选择过是否使用定位
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //询问用户是否愿意使用定位
#ifdef __IPHONE_8_0
        //使用 “使用中打开定位” 去运用定位功能
        [_locMgr requestAlwaysAuthorization];
#endif
    }
    //打开定位服务的开关(开始定位)
    [_locMgr startUpdatingLocation];
    
}
- (void)enterApp{
    BOOL AppInit = NO;
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开APP
        AppInit = YES;
    } else {
        if ([Utilities getUserDefaults:@"UserCity"] == nil) {
            //也说明是第一次打开APP
            AppInit = YES;
        }
        if (AppInit) {
            //第一次打开到APP将默认城市与记忆城市同步
            
            NSString *userCity = _cityBtn.titleLabel.text;
            [Utilities setUserDefaults:@"UserCity" content:userCity];
        }else {
            ;
            //不是第一次打开到APP将默认城市与按钮上的城市名反向同步
            NSString *userCity =[Utilities getUserDefaults:@"UserCity"];
            //NSLog(@"城市标题%@",userCity);
            [_cityBtn setTitle:userCity forState:UIControlStateNormal];
        }
    }
}

 //=========================================================================
//默认时间
- (void)setDefaultDateForButton{
    
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr= [formatter stringFromDate:dateTom];
    //将处理好的字符串设置给两个Button
    [_inTime setTitle:[NSString stringWithFormat:@"入住%@▼",dateStr] forState:UIControlStateNormal];
    [_outTime setTitle:[NSString stringWithFormat:@"离店%@▼",dateTomStr] forState:UIControlStateNormal];
    //
    NSDateFormatter *paraFormatter = [NSDateFormatter new];
    paraFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr2 = [paraFormatter stringFromDate:date];
    NSString *dateTomStr2= [paraFormatter stringFromDate:dateTom];
    _inTimeDate = dateStr2;
    _outTimeDate = dateTomStr2;
}
//创建一个刷新指示器
- (void)refresh{
    //创建一个刷新指示器放在tableview中
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshRequest) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10004;
    [_hotelTableView addSubview:ref];
}

- (void)initializeData{
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshRequest];
}
- (void)selectInitializeData{
    _aiv = [Utilities getCoverOnView:self.view];
    [self selectRequest];
}


- (void)refreshRequest{
    PageNum = 1;
    [self hotelAdv];
}
#pragma  mark - request
//天气
-(void)weatherRequest{

    //获得全宇宙天气的接口（当前这一刻的天气）（http://api.openweathermap.org是一个开放天气接口提供商）
    NSString *weatherURLStr =  [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=b864044bb95a790134d17b43a9a14d70&lang=zh_cn&find?q=London&units=metric",latitude,longitude];
    
    //将字符串转换成NSURL对象lat=29&lon=120.444
    NSURL *weatherURL = [NSURL URLWithString:weatherURLStr];
    //初始化单例化的NSURLSession对象b864044bb95a790134d17b43a9a14d70
    NSURLSession *session = [NSURLSession sharedSession];
    //创建一个基于NSURLSession的请求（除了请求任务还有上传和下载任务可以选择）任务并处理完成后的回调
    NSURLSessionDataTask *jsonDataTask = [session dataTaskWithURL:weatherURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"请求完成，开始做事");
        if (!error) {
            NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
            if (httpRes.statusCode == 200) {
                //NSLog(@"网络请求成功，真的开始做事");
                //将JSON格式的数据流data用JSONS工具包里的NSData下的Category中的JSONCol方法转化为OC对象（Array或Dictionary）
                id jsonObject = [data JSONCol];
                NSLog(@"%@", jsonObject);
                NSArray *weatherArr = jsonObject[@"weather"];
                NSDictionary *weather = [NSDictionary new];
                for (NSDictionary *dict in weatherArr) {
                    weather = dict;
                }
                
                NSDictionary *main = jsonObject[@"main"];
                NSString *temq = [NSString stringWithFormat:@"%ld",([main[@"temp"] integerValue]/1)];
                NSString *weatherStr = weather[@"description"];
                //NSString *weatherID = [NSString stringWithFormat:@"%@",weather[@"id"]];
                NSInteger weatherID = [weather[@"id"] integerValue];
                //将某指定方法抛回主线程去执行
                [self performSelectorOnMainThread:@selector(updateUI:) withObject:[NSArray arrayWithObjects:@(weatherID),weatherStr,temq,nil] waitUntilDone:YES];
                
                
            } else {
                //NSLog(@"%ld", (long)httpRes.statusCode);
            }
        } else {
            //NSLog(@"%@", error.description);
        }
    }];
    //让任务开始执行
    [jsonDataTask resume];
}

-(void)updateUI:(NSArray *)data {
    
    if ([data[0] integerValue] == 800){
        _weatherImg.image = [UIImage imageNamed:@"晴"];
    }else if ([data[0] integerValue] > 800 && [data[0] integerValue] < 804){
        _weatherImg.image = [UIImage imageNamed:@"多云"];
    }else if ([data[0] integerValue] == 804){
        _weatherImg.image = [UIImage imageNamed:@"阴"];
    }else{
        _weatherImg.image = [UIImage imageNamed:@"小雨"];
    }
    _tempLabel.text = [NSString stringWithFormat:@"%@℃",data[2]];
    _weatherLabel.text = data[1];
}

//广告,酒店
- (void)hotelAdv{
    //拿到刷新指示器
    UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10004];
//    //开始日期
//    NSTimeInterval startTime = [Utilities cTimestampFromString:_inTimeDate format:@"MM-dd"];
//    //开始日期
//    NSTimeInterval endTime = [Utilities cTimestampFromString:_outTimeDate format:@"MM-dd"];
//    if (startTime >= endTime){
//        [_aiv stopAnimating];
//        [Utilities popUpAlertViewWithMsg:@"请正确设置日期" andTitle:nil onView:self];
//        [ref endRefreshing];
//        return;
//    } 
    //参数
    NSDictionary *para = @{@"city_name" : _cityBtn.titleLabel.text, @"pageNum" :@(PageNum), @"pageSize" :  @(pageSize), @"startId" :  @(starID), @"priceId" :@(priceID), @"sortingId" :@(sortID) ,@"inTime" : _inTimeDate ,@"outTime" : _outTimeDate ,@"wxlongitude" :@"", @"wxlatitude" :@""};
    
    //网络请求
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"登录 = %@",responseObject);
        //当网络请求成功时让蒙层消失
        [_aiv stopAnimating];
        [ref endRefreshing];
        if([responseObject[@"result"]intValue] == 1){
            NSDictionary *content = responseObject[@"content"];
            //酒店列表信息
            NSDictionary *hotel = content[@"hotel"];
            NSArray *list = hotel[@"list"];
            isLastPage = [hotel[@"isLastPage"] boolValue];
            
            if (PageNum == 1) {
                [_hotelArr removeAllObjects];
            }
            for (NSDictionary *dict in  list){
                
                _model = [[HotelListModel alloc] initWithDict:dict];
                [_hotelArr addObject:_model];
            }
            
            //调用天气接口
            [self weatherRequest];
            //广告图片
            NSArray *advertising = content[@"advertising"];
            for (NSDictionary *imgUrl in advertising){
                NSString *str = imgUrl[@"ad_img"];
                [_advImgArr addObject:str];
            }
            [_firstImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[0]] placeholderImage:[UIImage imageNamed:@"多云"]];
            [_secondImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[2]] placeholderImage:[UIImage imageNamed:@"多云"]];
            [_threeImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[3]] placeholderImage:[UIImage imageNamed:@"多云"]];
            [_fourImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[4]] placeholderImage:[UIImage imageNamed:@"多云"]];
            
            [_hotelTableView reloadData];
        } else {
            [_aiv stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败时让蒙层消失
        [_aiv stopAnimating];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//搜索
- (void)selectRequest{
    //拿到刷新指示器
    UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10004];
   
    //参数
    NSDictionary *para = @{@"hotel_name" : _searchTextView.text, @"inTime" : [NSString stringWithFormat:@"2017-%@",_inTimeDate] ,@"outTime" : [NSString stringWithFormat:@"2017-%@",_outTimeDate]};
    
    //网络请求
    [RequestAPI requestURL:@"/selectHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"登录 = %@",responseObject);
        //当网络请求成功时让蒙层消失三国
        [_aiv stopAnimating];
        [ref endRefreshing];
        if([responseObject[@"result"]intValue] == 1){
            NSArray *content = responseObject[@"content"];
            
            if (PageNum == 1) {
                [_hotelArr removeAllObjects];
            }
            for (NSDictionary *dict in  content){ 
                HotelListModel *model = [[HotelListModel alloc] initWithDict:dict];
                [_hotelArr addObject:model];
            }
            [_hotelTableView reloadData];
        } else {
            [_aiv stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
           // [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败时让蒙层消失
        [_aiv stopAnimating];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}


//================================================================滚动广告相关
#pragma mark scrollView

//将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   
    //停止定时器
    _dt.fireDate = [NSDate distantFuture];
    scrollFlag = NO;
}
//拖拽结束时 开启计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 启动定时器
    _dt.fireDate = [NSDate distantPast];
    scrollFlag = YES;
    //开启定时器
    //[_dt setFireDate:[NSDate distantPast]];
}

-(void)duration{
    _dt = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:_dt forMode:NSRunLoopCommonModes];
 }
 
 - (void)timerMethod:(id)sender
 {
          scrollPage ++;
     if (scrollPage == (_pageControl.numberOfPages - 1)) {
         [_homeScrollView setContentSize:CGSizeMake((_pageControl.numberOfPages + 1) * UI_SCREEN_W,_homeScrollView.frame.size.height)];
         
         UIImageView *img = [UIImageView new];
         img.frame =CGRectMake(_homeScrollView.frame.size.width * _pageControl.   numberOfPages, 0, _homeScrollView.frame.size.width, _homeScrollView.frame.size.height);
         if (_advImgArr.count != 0)
         {
             [img sd_setImageWithURL:[NSURL URLWithString:_advImgArr[0]] placeholderImage:[UIImage imageNamed:@"多云"]];
             [_homeScrollView addSubview:img];
         }
         
     } 
     [_homeScrollView setContentOffset:CGPointMake(scrollPage * UI_SCREEN_W, 0) animated:YES];
     
     
     if (scrollPage == _pageControl.numberOfPages){
         scrollPage = 0;
         dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 1.5 *NSEC_PER_SEC);
         //用duration这个设置好的策略去执行下列方法
         dispatch_after(duration, dispatch_get_main_queue(), ^{
             [_homeScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
         });
     }
     _pageControl.currentPage = scrollPage;
 }

//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollPage = [self scrollCheck:scrollView];
}

//判断scrollView滑动到哪里了
-(NSInteger)scrollCheck:(UIScrollView *)scrollView{
    scrollPage = scrollView.contentOffset.x /(scrollView.frame.size.width);
    _pageControl.currentPage = scrollPage;
    if (scrollPage == _pageControl.numberOfPages - 1){
        [scrollView setContentSize:CGSizeMake((_pageControl.numberOfPages + 1) * UI_SCREEN_W,scrollView.frame.size.height)];
        UIImageView *img = [UIImageView new];
        img.frame =CGRectMake(scrollView.frame.size.width * _pageControl.numberOfPages, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [img sd_setImageWithURL:[NSURL URLWithString:_advImgArr[0]] placeholderImage:[UIImage imageNamed:@"多云"]];
        [scrollView addSubview:img];
    }
    if (scrollPage == _pageControl.numberOfPages){
        scrollPage = 0;
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    return scrollPage;
}

 /*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//设置细胞头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _hotelTableView){
        return 40;
    }
    return 0;
}

//设置头部筛选栏button属性
- (void)buttonAtt{
    //初始化button
    _inTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W/4.f, 40)];
    _outTime = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_W/4.f, 0, UI_SCREEN_W/4.f, 40)];
    _sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(2 * UI_SCREEN_W/4.f, 0, UI_SCREEN_W/4.f, 40)];
    _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(3 * UI_SCREEN_W/4.f, 0, UI_SCREEN_W/4.f, 40)];
    //字体
    [_inTime setTitle:[NSString stringWithFormat:@"%@▼",[_inTime.titleLabel.text substringToIndex:_inTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_outTime setTitle:[NSString stringWithFormat:@"%@▼",[_outTime.titleLabel.text substringToIndex:_outTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_sortBtn setTitle:@"智能排序▼" forState:UIControlStateNormal];
    [_selectBtn setTitle:@"筛选▼" forState:UIControlStateNormal];
    [_selectBtn setTitle:@"筛选▲" forState:UIControlStateSelected];
    
    //字体大小
    _inTime.titleLabel.font =  [UIFont systemFontOfSize:C_Font];
    _outTime.titleLabel.font = [UIFont systemFontOfSize:C_Font];
    _sortBtn.titleLabel.font = [UIFont systemFontOfSize:C_Font];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:C_Font];
    //字体颜色
    [_inTime setTitleColor:UNSELECT_TITLECOLOR forState:UIControlStateNormal];
    [_outTime setTitleColor:UNSELECT_TITLECOLOR forState:UIControlStateNormal];
    [_sortBtn setTitleColor:UNSELECT_TITLECOLOR forState:UIControlStateNormal];
    [_selectBtn setTitleColor:UNSELECT_TITLECOLOR forState:UIControlStateNormal];
    [_inTime setTitleColor:SELECT_COLOR forState:UIControlStateSelected];
    [_outTime setTitleColor:SELECT_COLOR forState:UIControlStateSelected];
    [_sortBtn setTitleColor:SELECT_COLOR forState:UIControlStateSelected];
    [_selectBtn setTitleColor:SELECT_COLOR forState:UIControlStateSelected];
    //边框
    
    [_inTime.layer setBorderWidth:1];
    [_outTime.layer setBorderWidth:1];
    [_sortBtn.layer setBorderWidth:1];
    [_selectBtn.layer setBorderWidth:1];
    _inTime.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _outTime.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _sortBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _selectBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //点击事件
    [_inTime addTarget:self action:@selector(inTimeAction)forControlEvents:UIControlEventTouchUpInside];
    [_outTime addTarget:self action:@selector(outTimeAction)forControlEvents:UIControlEventTouchUpInside];
    [_sortBtn addTarget:self action:@selector(sortBtnAction)forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn addTarget:self action:@selector(selectBtnAction)forControlEvents:UIControlEventTouchUpInside];
}

//设置细胞头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _hotelTableView){
        _cellHeaderView = [UIView new];
        _cellHeaderView.frame = CGRectMake(0, 0, UI_SCREEN_W, 40);
        _cellHeaderView.backgroundColor = [UIColor whiteColor];
        //view.alpha = 0.8;
        [_cellHeaderView addSubview:_inTime];
        [_cellHeaderView addSubview:_outTime];
        [_cellHeaderView addSubview:_sortBtn];
        [_cellHeaderView addSubview:_selectBtn];
        return _cellHeaderView;
    }
    return nil;
}

//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _markTabelView){
        return _sortArr.count;
    } else{
        return _hotelArr.count;
    }
}

//当一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
        //判断将要出现的细胞是不是当前最后一行
        if (indexPath.row == _hotelArr.count - 1) {
            //当存在下一页的时候，页码自增，请求下一页数据
            if (!isLastPage) {
                PageNum ++;
                [self hotelAdv];
            }
        }
}

//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _markTabelView){
        return 44;
    } else{
        return 100;
    }
}

//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _markTabelView){
        _mCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        _mCell.textLabel.text = _sortArr[indexPath.row];
        return _mCell;
    } else{
        HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeHotelCell" forIndexPath:indexPath];
        HotelListModel *model = _hotelArr[indexPath.row];
        cell.hotelNameLabel.text = model.name;
        cell.hotelLocLabel.text = _cityBtn.titleLabel.text;
        cell.hotelPriceLabel.text =   [NSString stringWithFormat:@"¥%ld" ,(long)model.price] ;
    
        NSURL *URL = [NSURL URLWithString:model.imgUrl ];
        [cell.hotelImg sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"酒店5"]];
        //计算距离
        CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:[model.latitude doubleValue] longitude:[model.longitude doubleValue]];
        CLLocationDistance kilometers=[_location distanceFromLocation:otherLocation]/1000;
        cell.hotelDistanceLabel.text = [NSString stringWithFormat:@"距离我%.1f公里",kilometers];
        return  cell;
    }
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _markTabelView){
        _sortBtn.selected = NO;
        for(NSIndexPath *eachIP in tableView.indexPathsForVisibleRows){
             _mCell = [self.markTabelView cellForRowAtIndexPath:eachIP];
             if (eachIP ==  indexPath){
                 _mCell.textLabel.textColor = SELECT_COLOR;
                 _mCell.accessoryType = UITableViewCellAccessoryCheckmark;
                 sortID = eachIP.row + 1;
                 [_sortBtn setTitle:[NSString stringWithFormat:@"%@▼", _mCell.textLabel.text] forState:UIControlStateNormal];
                 _markView.hidden = YES;
                 [self initializeData];
             } else {
                 _mCell.textLabel.textColor = UNSELECT_TITLECOLOR;
                 _mCell.accessoryType = UITableViewCellAccessoryNone;
             }
         }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath != _indexPath) {
//        _mCell.textLabel.textColor = SELECT_COLOR;
//        _mCell.accessoryType = UITableViewCellAccessoryCheckmark;
//        _indexPath = indexPath;
//    }else {
//        _mCell.textLabel.textColor = UNSELECT_TITLECOLOR;
//        _mCell.accessoryType = UITableViewCellAccessoryNone;
//        
//   } 
}

#pragma mark - SKTagView
//设置筛选条件
- (void)selectStar{
 
    NSArray *res = @[@"全部",@"四星",@"五星"];
    NSArray *resp = @[@"不限",@"300以下",@"301-500",@"501-1000",@"1000以上"];
    
    _selectTagView.padding = UIEdgeInsetsMake(15, 5, 5, 15);  //内边距
    _selectTagView.interitemSpacing = 20;                     //列间距
    _selectTwoTagView.padding = UIEdgeInsetsMake(10, 5, 5, 15);  //内边距
    _selectTwoTagView.lineSpacing = 15;                          //行间距
    _selectTwoTagView.interitemSpacing = 20;
    //根据数组中的文字创建按钮，同时设置默认的按钮长什么样
    [res enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
       
          SKTag *tag = [SKTag tagWithText:text];
        if (idx == 0){
            tag.textColor = SELECT_COLOR;
            tag.borderColor = SELECTE_BORDER_COLOR;
        }else{
            tag.textColor = UNSELECT_TITLECOLOR; //设置字体颜色
            tag.borderColor = UNSELECT_BORDER_COLOR;           //边框颜色
        }

        tag.fontSize = 13;                      //设置字体大小
        tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);   //文字上下左右的间距
        tag.borderWidth = 0.5f;                              //边框宽度
        tag.cornerRadius = 5.f;                            //边框圆角
        [_selectTagView addTag:tag];
    }];

    //=================er==========er==================er==========================
    //根据数组中的文字创建按钮，同时设置默认的按钮长什么样
    [resp enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SKTag *tag = [SKTag tagWithText:text];
        if (idx == 0){
            tag.textColor = SELECT_COLOR;
            tag.borderColor = SELECTE_BORDER_COLOR;
        }else{
            tag.textColor = UNSELECT_TITLECOLOR; //设置字体颜色
            tag.borderColor = UNSELECT_BORDER_COLOR;           //边框颜色
        }
        
        tag.fontSize = 13;                      //设置字体大小
        tag.padding = UIEdgeInsetsMake(5, 10, 5, 10);   //文字上下左右的间距
        tag.borderWidth = 0.5f;                              //边框宽度
        tag.cornerRadius = 5.f;                            //边框圆角
        [_selectTwoTagView addTag:tag];
    }];
    [self weakSelect];
}

- (void) weakSelect{
    //防止循环引用，把块变成弱指针
    //选中一个按钮的时候，
    __weak SKTagView *weakView = _selectTagView;
//    if (selectCirfimBool == 2){
//        weakView.didTapTagAtIndex(otherIndexOne, otherPreIdxOne);
//    }
    _selectTagView.didTapTagAtIndex = ^(NSUInteger preIdx, NSUInteger index) {

//        if (selectCirfimBool == 2){
//            preIdx = otherIndexOne;
//            index = otherPreIdxOne;
//        }
        //判断当前要选中按钮时，有没有已选中的按钮
        if (preIdx != -1){
            //通过上次选中按钮的preIdx下表拿到一个按钮preTag
            SKTag *preTag = [weakView.tags objectAtIndex:preIdx];
            //更改文字颜色 为未选中状态
            preTag.textColor = UNSELECT_TITLECOLOR;
            preTag.borderColor = UNSELECT_BORDER_COLOR;
            //将上次选中的按钮从原有的下标preIdx上删除
            [weakView removeTagAtIndex:preIdx];
            //再把更改好状态的按钮插入到preIdx下标上
            [weakView insertTag:preTag atIndex:preIdx];
        }
        
        starTestID = index + 1;
        SKTag *tag = [weakView.tags objectAtIndex:index];
        tag.textColor = SELECT_COLOR;
        tag.borderColor = SELECTE_BORDER_COLOR;
        [weakView removeTagAtIndex:index];
        [weakView insertTag:tag atIndex:index];
        //selectCirfimBool = 3;
        otherIndexOne = index;
        
    };
    //防止循环引用，把块变成弱指针
    //选中一个按钮的时候，
    __weak SKTagView *weakView1 = _selectTwoTagView;
//    if (selectCirfimBool == 2){
//        weakView1.didTapTagAtIndex(otherIndexTwo, otherPreIdxTwo);
//    }
    _selectTwoTagView.didTapTagAtIndex = ^(NSUInteger preIdx, NSUInteger index) {
 
//        if (selectCirfimBool == 2){
//            preIdx = otherIndexTwo;
//            index = otherPreIdxTwo;
//        }
        
        //判断当前要选中按钮时，有没有已选中的按钮
        if (preIdx != -1){
            //通过上次选中按钮的preIdx下表拿到一个按钮preTag
            SKTag *preTag = [weakView1.tags objectAtIndex:preIdx];
            //更改文字颜色 为未选中状态
            preTag.textColor = UNSELECT_TITLECOLOR;
            preTag.borderColor = UNSELECT_BORDER_COLOR;
            //将上次选中的按钮从原有的下标preIdx上删除
            [weakView1 removeTagAtIndex:preIdx];
            //再把更改好状态的按钮插入到preIdx下标上
            [weakView1 insertTag:preTag atIndex:preIdx];
        }
        
        priceTestID = index + 1;
          
        SKTag *tag = [weakView1.tags objectAtIndex:index];
        tag.textColor = SELECT_COLOR;
        tag.borderColor = SELECTE_BORDER_COLOR;
        [weakView1 removeTagAtIndex:index];
        [weakView1 insertTag:tag atIndex:index];
//        selectCirfimBool = 2;
//        otherIndexTwo = index;
    };
    
}

#pragma mark - location
//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    if (error) {
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
                break;
            default:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
                break;
        }
    }
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    _location = newLocation;
    
    if (firstVisit) {
        firstVisit = !firstVisit;
        //根据定位拿到城市
        [self getRegionCoordinate];
    }

}

-(void)getRegionCoordinate{
    //duration表示从Now开始过3秒
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
    //用duration这个设置好的策略去执行下列方法
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                //NSLog(@"locDict = %@",locDict);
                NSString *city = locDict[@"City"];
                city = [city substringToIndex:city.length - 1];
                //NSLog(@"%@",city);
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                //将定位到的城市保存进单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:city];
                if (![city isEqualToString:_cityBtn.titleLabel.text]) {
                    //当定位到的城市和当前选择的城市不一样的时候，弹窗询问是否要切换城市
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@,请问是否需要切换",city] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityBtn setTitle:city  forState:UIControlStateNormal];
                       // _cityBtn.titleLabel.text = city;
                        
                        [Utilities removeUserDefaults:@"UserCity"];
                        //修改用户选择城市的记忆体
                        [Utilities setUserDefaults:@"UserCity" content:city];
                        //更改城市重新调用网络请求
                        [self initializeData];
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                }
            }
        }];
        //过三秒钟关掉开关
        [_locMgr stopUpdatingLocation];
    });

}
//接受上个页面的通知,进行方法的实现
-(void)chooseCity:(NSNotification *)note{
    NSString *cityStr = note.object;
    if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
        //修改城市按钮标题
        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
        [Utilities removeUserDefaults:@"UserCity"];
        //修改用户选择城市的记忆体
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        [self geocodeAddressString];
        
        //更改城市重新调用网络请求
        dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
        dispatch_after(duration, dispatch_get_main_queue(), ^{
            [self initializeData];
        });
    }
}

//获取经纬度
- (void)geocodeAddressString{
    NSString *oreillyAddress = [Utilities getUserDefaults:@"UserCity"];
    if ([oreillyAddress isKindOfClass:[NSNull class]]){
        oreillyAddress = _cityBtn.titleLabel.text;
    }
    CLGeocoder *geo = [CLGeocoder new];
    //反向地理编码
    [geo geocodeAddressString:oreillyAddress completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *first = placemarks.firstObject;
            longitude = first.location.coordinate.longitude;
            latitude = first.location.coordinate.latitude;
            [self weatherRequest];
        } else {
            
        }
    }];
}
//当某一个页面跳转行为将要发生的时候
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ListToDetail"]){
        //当从列表页到详情页的这个跳转要发生的时候
        //1.获取要传递到下一页的数据
        NSIndexPath *indexPath = [_hotelTableView indexPathForSelectedRow];
        HotelListModel *model = _hotelArr[indexPath.row];
        //2.获取下一页这个实例
        HotelDetailViewController *detailVC = segue.destinationViewController;
        //3、把数据给下一页预备好的接受容器
        detailVC.hotelId = model.hotelId;
    }
}

- (IBAction)searchAction:(UIButton *)sender forEvent:(UIEvent *)event {
        PageNum = 1;
        isLastPage = NO;
        if ([_searchTextView.text  isKindOfClass:[NSNull class]] || [_searchTextView.text isEqualToString:@""] || _searchTextView.text == nil){
            [self initializeData];
        } else {
            [self selectInitializeData];
        }
}

- (void)inTimeAction {
    [_inTime setTitle:[NSString stringWithFormat:@"%@▲",[_inTime.titleLabel.text substringToIndex:_inTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_outTime setTitle:[NSString stringWithFormat:@"%@▼",[_outTime.titleLabel.text substringToIndex:_outTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_sortBtn setTitle:[NSString stringWithFormat:@"%@▼",[_sortBtn.titleLabel.text substringToIndex:_sortBtn.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    
    //设置最小时间
    _datePick.minimumDate = [NSDate date];
    
    _inTime.selected = YES;
    _outTime.selected = NO;
    _sortBtn.selected = NO;
    _selectBtn.selected = NO;
    flag = 0;
    _markView.hidden = NO;
    _toolBar.hidden = NO;
    _datePick.hidden = NO;
    _markTabelView.hidden = YES;
    _selectView.hidden = YES;
}

- (void)outTimeAction{
    [_outTime setTitle:[NSString stringWithFormat:@"%@▲",[_outTime.titleLabel.text substringToIndex:_outTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
     [_inTime setTitle:[NSString stringWithFormat:@"%@▼",[_inTime.titleLabel.text substringToIndex:_inTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_sortBtn setTitle:[NSString stringWithFormat:@"%@▼",[_sortBtn.titleLabel.text substringToIndex:_sortBtn.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    //设置最小时间
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:_inTimeDate];
    NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    _datePick.minimumDate = nextDat;
    
    _outTime.selected = YES;
    _inTime.selected = NO;
    _sortBtn.selected = NO;
    _selectBtn.selected = NO;
    flag = 1;
    _markView.hidden = NO;
    _toolBar.hidden = NO;
    _datePick.hidden = NO;
    _markTabelView.hidden = YES;
    _selectView.hidden = YES;
}

- (void)sortBtnAction {
    [_sortBtn setTitle:[NSString stringWithFormat:@"%@▲",[_sortBtn.titleLabel.text substringToIndex:_sortBtn.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_outTime setTitle:[NSString stringWithFormat:@"%@▼",[_outTime.titleLabel.text substringToIndex:_outTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_inTime setTitle:[NSString stringWithFormat:@"%@▼",[_inTime.titleLabel.text substringToIndex:_inTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    _sortBtn.selected = YES;
    _inTime.selected = NO;
    _outTime.selected = NO;
    _selectBtn.selected = NO;
    _markView.hidden = NO;
    _toolBar.hidden = YES;
    _datePick.hidden = YES;
    _markTabelView.hidden = NO;
    _selectView.hidden = YES;
}

- (void)selectBtnAction {
    [_outTime setTitle:[NSString stringWithFormat:@"%@▼",[_outTime.titleLabel.text substringToIndex:_outTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
     [_inTime setTitle:[NSString stringWithFormat:@"%@▼",[_inTime.titleLabel.text substringToIndex:_inTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_sortBtn setTitle:[NSString stringWithFormat:@"%@▼",[_sortBtn.titleLabel.text substringToIndex:_sortBtn.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    _selectBtn.selected = YES;
    _inTime.selected = NO;
    _outTime.selected = NO;
    _sortBtn.selected = NO;
    _markView.hidden = NO;
    _toolBar.hidden = YES;
    _datePick.hidden = YES;
    _markTabelView.hidden = YES;
    _selectView.hidden = NO;
}

//下拉菜单栏位置设置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _hotelTableView){
//[UIView animateWithDuration:0.1 animations:^{
            if (_hotelTableView.contentOffset.y > _homeScrollView.frame.size.height){
                _transviewPosotion.constant = 40;
                _pageTop.constant = - 400;
            } else if(_hotelTableView.contentOffset.y > 0 && _hotelTableView.contentOffset.y < _homeScrollView.frame.size.height){
                _transviewPosotion.constant = _homeScrollView.frame.size.height - _hotelTableView.contentOffset.y + 40;
                _pageTop.constant = _homeScrollView.height - _hotelTableView.contentOffset.y - 40;
            }else{
                _transviewPosotion.constant = _homeScrollView.frame.size.height + 40;
                _pageTop.constant =  _homeScrollView.height - 40;
            }
 //       }];
        
    }
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [_outTime setTitle:[NSString stringWithFormat:@"%@▼",[_outTime.titleLabel.text substringToIndex:_outTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_inTime setTitle:[NSString stringWithFormat:@"%@▼",[_inTime.titleLabel.text substringToIndex:_inTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    _inTime.selected = NO;
    _outTime.selected = NO;
    _markView.hidden = YES;
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    _inTime.selected = NO;
    _outTime.selected = NO;
    NSDate *date = _datePick.date;
    //
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSDateFormatter *paraFormatter = [NSDateFormatter new];
    paraFormatter.dateFormat = @"yyyy-MM-dd";
    //
    NSString *thDate = [formatter stringFromDate:date];

    //获取默认时间
    //当前时间
 //   NSDate *dateToday = [NSDate date];
    //明天的日期
//    NSDate *dateTom = [NSDate dateTomorrow];
 //   NSString *dateStr = [formatter stringFromDate:dateToday];
//    NSString *dateTomStr= [formatter stringFromDate:dateTom];
 
    
    if (flag == 0){
        [_inTime setTitle:[NSString stringWithFormat:@"入住%@▼",thDate] forState:UIControlStateNormal];
        _inTimeDate = [paraFormatter stringFromDate:date];
        
        if ([Utilities cTimestampFromString:_inTimeDate format:paraFormatter.dateFormat] >= [Utilities cTimestampFromString:_outTimeDate format:paraFormatter.dateFormat]){
            
            NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
            NSString *dateStr = [formatter stringFromDate:nextDat];
            [_outTime setTitle:[NSString stringWithFormat:@"离店%@▼",dateStr] forState:UIControlStateNormal];
        }
    }else{
        [_outTime setTitle:[NSString stringWithFormat:@"离店%@▼",thDate] forState:UIControlStateNormal];
        _outTimeDate = [paraFormatter stringFromDate:date];
    }
    [self initializeData];
    //followUptime = [date timeIntervalSince2017];
 
    _markView.hidden = YES;
    
}

- (IBAction)selectTagCfirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _selectBtn.selected = NO;
    PageNum = 1;
    starID = starTestID;
    priceID = priceTestID;
    selectCirfimBool = 1;
    _markView.hidden = YES;
    otherPreIdxOne = otherIndexOne;
    otherPreIdxTwo = otherIndexTwo;
    [self initializeData];
}

- (IBAction)locAction:(UIButton *)sender forEvent:(UIEvent *)event {
    CityTableViewController *citylist = [Utilities getStoryboardInstance:@"Main" byIdentity:@"city"];
    [self.navigationController pushViewController:citylist animated:YES];
    citylist.tag = 1;
}


- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_outTime setTitle:[NSString stringWithFormat:@"%@▼",[_outTime.titleLabel.text substringToIndex:_outTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_inTime setTitle:[NSString stringWithFormat:@"%@▼",[_inTime.titleLabel.text substringToIndex:_inTime.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    [_sortBtn setTitle:[NSString stringWithFormat:@"%@▼",[_sortBtn.titleLabel.text substringToIndex:_sortBtn.titleLabel.text.length - 1] ] forState:UIControlStateNormal];
    _inTime.selected = NO;
    _outTime.selected = NO;
    _sortBtn.selected = NO;
    _selectBtn.selected = NO;
    _markView.hidden = YES;
    [self.view endEditing:YES];
//    selectCirfimBool = 2;
//    [self weakSelect];
       // _selectTagView.didTapTagAtIndex(otherPreIdxOne, otherIndexOne);
    
}


//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _searchTextView){
        [textField resignFirstResponder];
        [self initializeData];
    } 
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _mark = [UIView new];
    _mark.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mark.backgroundColor = UIColorFromRGBA(104, 104, 104, 0.3);
    //[[UIApplication sharedApplication].keyWindow addSubview:_mark];
    [self.view addSubview:_mark];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_mark removeFromSuperview];
    _mark = nil;
}
//- (IBAction)choosecityAction:(UIButton *)sender forEvent:(UIEvent *)event{
//    CityTableViewController *citylist = [Utilities getStoryboardInstance:@"Main" byIdentity:@"City"];
//    [self.navigationController pushViewController:citylist animated:YES];
//    citylist.tag = 1;
//}

@end
