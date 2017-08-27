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
@interface HotelViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    BOOL firstVisit;
    NSInteger PageNum;
    NSInteger pageSize;
    BOOL isLastPage;
    NSInteger scrollPage;
    NSInteger scrollPageC;
}
@property (weak, nonatomic) IBOutlet UIButton *homeLocation;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;

@property (weak, nonatomic) IBOutlet UITableView *hotelTableView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeImg;
@property (weak, nonatomic) IBOutlet UIImageView *fourImg;
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bottmScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (strong,nonatomic)CLLocationManager *locMgr;
@property (strong,nonatomic)CLLocation *location;

@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property (strong, nonatomic) NSMutableArray *hotelArr;
@property (strong, nonatomic) NSMutableArray *advImgArr;
//@property (strong, nonatomic) NSString *longitude;      //经度
//@property (strong, nonatomic) NSString *latitude;       //纬度
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _advImgArr = [NSMutableArray new];
    firstVisit = YES;
    // Do any additional setup after loading the view.
    _hotelArr = [NSMutableArray new];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    PageNum = 1;
    pageSize = 15;
    //去掉tableview底部多余的线
    _hotelTableView.tableFooterView = [UIView new];
    
   // [self weatherRequest];          //天气网络请求
    
    [self locationConfig];          //开始定位
    [self enterApp];                //判断是否第一次进入app
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(chooseCity:) name:@"ResetCity" object:nil];
    [self initializeData];
    //去掉scrollView横向滚动标示
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    //滑动点设为4个
    _pageControl.numberOfPages = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
}

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
            //不是第一次打开到APP将默认城市与按钮上的城市名反向同步
            NSString *userCity =[Utilities getUserDefaults:@"UserCity"];
            [_cityBtn setTitle:userCity forState:UIControlStateNormal];
        }
    }
}

 //=========================================================================
//创建一个刷新指示器
- (void)refresh{
    //创建一个刷新指示器放在tableview中
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshRequest) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10004;
    [_bottmScrollView addSubview:ref];
}

- (void)refreshRequest{
    PageNum = 1;
    [self hotelAdv];
    //[self hotelList];
}
- (void)initializeData{
    _aiv = [Utilities getCoverOnView:self.view];
    [self refreshRequest];
}
#pragma  mark - request
//天气
-(void)weatherRequest{
    
    
    NSDictionary *parameters = @{@"cityname" : @"%E5%A4%AA%E5%8E%9F&dtype=&format=&key=9c44df781a01d4f579aa8c782a578ea5"};
    
    [RequestAPI requestURL:@"http://op.juhe.cn/onebox/weather/query" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
        NSLog(@"pp:%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001){
            
        }else {
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];

}

//广告
- (void)hotelAdv{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"yyyy-MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr= [formatter stringFromDate:dateTom];
    //参数
    NSDictionary *para = @{@"city_name" : @"无锡", @"pageNum" :@(PageNum), @"pageSize" :  @(pageSize), @"startId" :  @1, @"priceId" :@1, @"sortingId" :@1 ,@"inTime" :  @0,@"outTime" : @0,@"wxlongitude" :@"", @"wxlatitude" :@""};
    //网络请求
    [RequestAPI requestURL:@"/findHotelByCity_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"登录 = %@",responseObject);
        UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10004];
        [ref endRefreshing];
        //当网络请求成功时让蒙层消失
        [_aiv stopAnimating];
        if([responseObject[@"result"]intValue] == 1){
            NSDictionary *content = responseObject[@"content"];
            NSArray *advertising = content[@"advertising"];
            for (NSDictionary *imgUrl in advertising){
                NSString *str = imgUrl[@"ad_img"];
                [_advImgArr addObject:str];
            }
            [_firstImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[0]] placeholderImage:[UIImage imageNamed:@"白云"]];
            [_secondImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[2]] placeholderImage:[UIImage imageNamed:@"白云"]];
            [_threeImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[3]] placeholderImage:[UIImage imageNamed:@"白云"]];
            [_fourImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[4]] placeholderImage:[UIImage imageNamed:@"白云"]];
           /* isLastPage = [result[@"isLastPage"] boolValue];
            if (PageNum == 1) {
                [_hotelArr removeAllObjects];
            }
            
            
            
            [_hotelTableView reloadData];*/
        } else {
            [_aiv stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败时让蒙层消失
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10004];
        [ref endRefreshing];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//酒店
- (void)hotelList{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"yyyy-MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //明天的日期
    NSDate *dateTom = [NSDate dateTomorrow];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dateTomStr= [formatter stringFromDate:dateTom];
    //参数
    NSDictionary *para = @{@"city_name" :  @"无锡", @"page" :@(PageNum), @"startId" :  @1, @"priceId" :@1, @"sortingId" :@1 ,@"inTime" :  dateStr,@"outTime" : dateTomStr};//,@"wxlongitude" :@"", @"wxlatitude" :@""};
    
    //网络请求
    [RequestAPI requestURL:@"/findHotelByCity" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"登录 = %@",responseObject);
//        UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10004];
//        [ref endRefreshing];
        //当网络请求成功时让蒙层消失
        [_aiv stopAnimating];
        if([responseObject[@"result"]intValue] == 1){
            NSDictionary *content = responseObject[@"content"];
//            NSArray *advertising = content[@"advertising"];
//            for (NSDictionary *imgUrl in advertising){
//                NSString *str = imgUrl[@"ad_img"];
//                [_advImgArr addObject:str];
//            }
//            [_firstImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[0]] placeholderImage:[UIImage imageNamed:@"白云"]];
//            [_secondImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[2]] placeholderImage:[UIImage imageNamed:@"白云"]];
//            [_threeImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[3]] placeholderImage:[UIImage imageNamed:@"白云"]];
//            [_fourImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[4]] placeholderImage:[UIImage imageNamed:@"白云"]];
            /* isLastPage = [result[@"isLastPage"] boolValue];
             if (PageNum == 1) {
             [_hotelArr removeAllObjects];
             }
             
             
             
             [_hotelTableView reloadData];*/
        } else {
            [_aiv stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求失败时让蒙层消失
        [_aiv stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10004];
        [ref endRefreshing];
        [Utilities
         popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}

//================================================================滚动广告相关
//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollPage = [self scrollCheck:scrollView];
    _pageControl.currentPage = scrollPage;
    
}
//scrollView已经开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollPage == 3){
        scrollPageC = 0;
    }else {
        scrollPageC = 1;
    }
}

//判断scrollView滑动到哪里了
-(NSInteger)scrollCheck:(UIScrollView *)scrollView{
    scrollPage = scrollView.contentOffset.x /(scrollView.frame.size.width);
    if (scrollPageC == 0){
        scrollPage = scrollPageC;
        scrollView.contentOffset = CGPointMake(0, 0);
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
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

//当一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   /* [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断将要出现的细胞是不是当前最后一行
    if (indexPath.row == _hotelArr.count - 1) {
        //当存在下一页的时候，页码自增，请求下一页数据
        if (!isLastPage) {
            PageNum ++;
            [self hotel];
        }
    }*/
}

//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeHotelCell" forIndexPath:indexPath];
    return  cell;
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
                        
                        [Utilities removeUserDefaults:@"UserCity"];
                        //修改用户选择城市的记忆体
                        [Utilities setUserDefaults:@"UserCity" content:city];
                       
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
    }
}
@end
