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

@interface HotelViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSInteger flag;
    BOOL scrollFlag;
    BOOL firstVisit;
    BOOL isLastPage;
    BOOL selectBool;
    BOOL selectCirfimBool;
    
    NSInteger PageNum;
    NSInteger pageSize;
    
    NSInteger scrollPage;
    NSInteger scrollPageC;
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
@property (weak, nonatomic) IBOutlet UITextView *searchTextView;
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
@property (weak, nonatomic) IBOutlet UIButton *inTime;
@property (weak, nonatomic) IBOutlet UIButton *outTime;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn; 
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UITableView *markTabelView;
@property (weak, nonatomic) IBOutlet SKTagView *selectTagView;
@property (weak, nonatomic) IBOutlet SKTagView *selectTwoTagView;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePick;
@property (weak, nonatomic) IBOutlet UIView *selectView;


- (IBAction)searchAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)inTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)outTimeAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)sortAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)doneAction:(UIBarButtonItem *)sender;
- (IBAction)selectTagCfirmAction:(UIButton *)sender forEvent:(UIEvent *)event;
 

@property (strong,nonatomic)CLLocationManager *locMgr;
@property (strong,nonatomic)CLLocation *location;

@property (strong,nonatomic)UIActivityIndicatorView *aiv;
@property (strong, nonatomic) NSMutableArray *hotelArr;
@property (strong, nonatomic) NSMutableArray *advImgArr;
@property (strong,nonatomic) NSString *inTimeDate;
@property (strong,nonatomic) NSString *outTimeDate;
@property (strong,nonatomic) NSArray *sortArr;
@property (strong,nonatomic) HomeMarkTableViewCell *mCell;

@property (strong,nonatomic) NSIndexPath *indexPath;
//@property (strong, nonatomic) NSString *longitude;      //经度
//@property (strong, nonatomic) NSString *latitude;       //纬度
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _advImgArr = [NSMutableArray new];
    firstVisit = YES;
    selectBool = YES;
    selectCirfimBool = NO;
    // Do any additional setup after loading the view.
    _hotelArr = [NSMutableArray new];
   
    PageNum = 1;
    pageSize = 8;
    starID = 1;
    priceID = 1;
    
    _datePick.backgroundColor = UIColorFromRGB(235, 235, 241);
    //去掉tableview底部多余的线
    _hotelTableView.tableFooterView = [UIView new];
    
    _searchTextView.text = @"";
    
   // [self weatherRequest];          //天气网络请求
    [self setDefaultDateForButton];
    
    [self locationConfig];          //开始定位
    [self enterApp];                //判断是否第一次进入app
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(chooseCity:) name:@"ResetCity" object:nil];
    //调用蒙层和刷新指示器
    [self initializeData];
    [self refresh];
    
    [self selectStar];
    //去掉scrollView横向滚动标示
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    [self duration];
    //滑动点设为4个
    _pageControl.numberOfPages = 4;
    _sortArr = @[@"智能排序",@"价格低到高",@"价格高到低",@"离我从近到远"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    //[[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self locationStart];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    [_inTime setTitle:[NSString stringWithFormat:@"入住%@ ▼",dateStr] forState:UIControlStateNormal];
    [_outTime setTitle:[NSString stringWithFormat:@"离店%@ ▼",dateTomStr] forState:UIControlStateNormal];
    _inTimeDate = dateStr;
    _outTimeDate = dateTomStr;
    
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

//广告,酒店
- (void)hotelAdv{
    //拿到刷新指示器
    UIRefreshControl *ref = (UIRefreshControl *)[_hotelTableView viewWithTag:10004];
    //开始日期
    NSTimeInterval startTime = [Utilities cTimestampFromString:_inTimeDate format:@"MM-dd"];
    //开始日期
    NSTimeInterval endTime = [Utilities cTimestampFromString:_outTimeDate format:@"MM-dd"];
    if (startTime >= endTime){
        
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请正确设置日期" andTitle:nil onView:self];
    }
    NSLog(@"%ld>>>",(long)PageNum);
    //参数
    NSDictionary *para = @{@"city_name" : _cityBtn.titleLabel.text, @"pageNum" :@(PageNum), @"pageSize" :  @(pageSize), @"startId" :  @(starID), @"priceId" :@(priceID), @"sortingId" :@(sortID) ,@"inTime" : [NSString stringWithFormat:@"2017-%@",_inTimeDate] ,@"outTime" : [NSString stringWithFormat:@"2017-%@",_outTimeDate] ,@"wxlongitude" :@"", @"wxlatitude" :@""};
    
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
                
                HotelListModel *model = [[HotelListModel alloc] initWithDict:dict];
                [_hotelArr addObject:model];
            }
            //广告图片
            NSArray *advertising = content[@"advertising"];
            for (NSDictionary *imgUrl in advertising){
                NSString *str = imgUrl[@"ad_img"];
                [_advImgArr addObject:str];
            }
            [_firstImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[0]] placeholderImage:[UIImage imageNamed:@"白云"]];
            [_secondImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[2]] placeholderImage:[UIImage imageNamed:@"白云"]];
            [_threeImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[3]] placeholderImage:[UIImage imageNamed:@"白云"]];
            [_fourImg sd_setImageWithURL:[NSURL URLWithString:_advImgArr[4]] placeholderImage:[UIImage imageNamed:@"白云"]];
            
            
            [_homeScrollView reloadInputViews];
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
    //开始日期
    NSTimeInterval startTime = [Utilities cTimestampFromString:_inTimeDate format:@"MM-dd"];
    //开始日期
    NSTimeInterval endTime = [Utilities cTimestampFromString:_outTimeDate format:@"MM-dd"];
    if (startTime >= endTime){
        
        [_aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请正确设置日期" andTitle:nil onView:self];
    }
    //参数
    NSDictionary *para = @{@"hotel_name" : _searchTextView.text, @"inTime" : [NSString stringWithFormat:@"2017-%@",_inTimeDate] ,@"outTime" : [NSString stringWithFormat:@"2017-%@",_outTimeDate]};
    
    //网络请求
    [RequestAPI requestURL:@"/selectHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //NSLog(@"登录 = %@",responseObject);
        //当网络请求成功时让蒙层消失
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
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
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
-(void)duration{
 [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
 }
 
 - (void)timerMethod:(id)sender
 {
 // _pageController.currentPage = _scrollView.contentOffset.x /(_scrollView.frame.size.width);
 if (scrollFlag) {
 _pageControl.currentPage++;
 }
 else
 {
     _pageControl.currentPage--;
 }
 if (_pageControl.currentPage == 0) {
     scrollFlag = YES;
 }
 if (_pageControl.currentPage == (_pageControl.numberOfPages - 1)) {
     scrollFlag = NO;
 }
 [_homeScrollView setContentOffset:CGPointMake(_pageControl.currentPage * _homeScrollView.frame.size.width, 0) animated:YES];
 }

//scrollView已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollPage = [self scrollCheck:scrollView];
    _pageControl.currentPage = scrollPage;
    
}
//scrollView已经开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > 3 * UI_SCREEN_W){
        if (scrollPage == 3){
            scrollPageC = 0;
        }
    } else if(scrollView.contentOffset.x < 0){
        if (scrollPage == 0){
            scrollPageC = 3;
        }
    } else {
       scrollPageC = 2;
    }
    
}

//判断scrollView滑动到哪里了
-(NSInteger)scrollCheck:(UIScrollView *)scrollView{
    scrollPage = scrollView.contentOffset.x /(scrollView.frame.size.width);
    if (scrollPageC == 0){
        scrollPage = scrollPageC;
        scrollView.contentOffset = CGPointMake(0, 0);
    } else if(scrollPageC == 3){
        scrollPage = scrollPageC;
        scrollView.contentOffset = CGPointMake(3 * UI_SCREEN_W, 0);
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
         for(NSIndexPath *eachIP in tableView.indexPathsForVisibleRows){
             _mCell = [self.markTabelView cellForRowAtIndexPath:eachIP];
             if (eachIP ==  indexPath){
                 _mCell.textLabel.textColor = SELECT_COLOR;
                 _mCell.accessoryType = UITableViewCellAccessoryCheckmark;
                 sortID = eachIP.row;
                 [_sortBtn setTitle:[NSString stringWithFormat:@"%@  ▼", _mCell.textLabel.text] forState:UIControlStateNormal];
                 _markView.hidden = YES;
                 [self initializeData];
             } else {
                 _mCell.textLabel.textColor = UNSELECT_TITLECOLOR;
                 _mCell.accessoryType = UITableViewCellAccessoryNone;
             }
         }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
//设置一级结果
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
    //防止循环引用，把块变成弱指针
    //选中一个按钮的时候，
    __weak SKTagView *weakView = _selectTagView;
    _selectTagView.didTapTagAtIndex = ^(NSUInteger preIdx, NSUInteger index) {
        if (selectBool == YES){
            preIdx = 0;
            selectBool = NO;
        }
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
        selectCirfimBool = NO;
        otherIndexOne = index;
        
    };
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
    //防止循环引用，把块变成弱指针
    //选中一个按钮的时候，
    __weak SKTagView *weakView1 = _selectTwoTagView;
    _selectTwoTagView.didTapTagAtIndex = ^(NSUInteger preIdx, NSUInteger index) {
        //第一次进来数组第一个设为选中状态
        if (selectBool == YES){
            preIdx = 0;
            selectBool = NO;
        }
        if (selectCirfimBool == YES){
            preIdx = index;
            index = otherPreIdxTwo;
        }
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
        //NSLog(@"%ld############%ld",(long)starID,(long)priceID);
        selectCirfimBool = NO;
        otherIndexTwo = index;
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

- (IBAction)inTimeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    _markView.hidden = NO;
    _toolBar.hidden = NO;
    _datePick.hidden = NO;
    _markTabelView.hidden = YES;
    _selectView.hidden = YES;
}

- (IBAction)outTimeAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    _markView.hidden = NO;
    _toolBar.hidden = NO;
    _datePick.hidden = NO;
    _markTabelView.hidden = YES;
    _selectView.hidden = YES;
}

- (IBAction)sortAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _markView.hidden = NO;
    _toolBar.hidden = YES;
    _datePick.hidden = YES;
    _markTabelView.hidden = NO;
    _selectView.hidden = YES;
}

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _markView.hidden = NO;
    _toolBar.hidden = YES;
    _datePick.hidden = YES;
    _markTabelView.hidden = YES;
    _selectView.hidden = NO;
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _markView.hidden = YES;
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    NSDate *date = _datePick.date;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd";
    NSString *thDate = [formatter stringFromDate:date];
    //followUptime = [date timeIntervalSince1970];
    if (flag == 0){
        [_inTime setTitle:[NSString stringWithFormat:@"入住%@ ▼",thDate] forState:UIControlStateNormal];
        _inTimeDate = thDate;
    }else{
        [_outTime setTitle:[NSString stringWithFormat:@"离店%@ ▼",thDate] forState:UIControlStateNormal];
        _outTimeDate = thDate;
    }
    _markView.hidden = YES;
    [self initializeData];
}

- (IBAction)selectTagCfirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    PageNum = 1;
    starID = starTestID;
    priceID = priceTestID;
    selectCirfimBool = YES;
    _markView.hidden = YES;
    otherPreIdxOne = otherIndexOne;
    otherPreIdxTwo = otherIndexTwo;
    [self initializeData];
    [self selectStar];
}
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _markView.hidden = YES; 
}
@end
