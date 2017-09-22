//
//  HotelDetailViewController.m
//  GetHotels
//
//  Created by admin2017 on 2017/8/21.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "HotelViewController.h"
#import "ZLImageViewDisplayView.h"
#import "hotelDetailModel.h"
#import "PurchaseTableViewController.h"
#import "MapViewController.h"
@interface HotelDetailViewController (){
    NSTimeInterval followUpTime;
    NSUInteger flag;
    NSTimeInterval datetime;
}
@property (weak, nonatomic) IBOutlet UIScrollView *DetailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *nameToView;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UIView *adressToView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
- (IBAction)dateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextDateBtn;
- (IBAction)nextDateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *nextDayLabel;
@property (weak, nonatomic) IBOutlet UIView *facilitiesView;
@property (weak, nonatomic) IBOutlet UIView *dayView;
@property (weak, nonatomic) IBOutlet UIView *bedView;
@property (weak, nonatomic) IBOutlet UIView *comeToLeaveView;
@property (weak, nonatomic) IBOutlet UIView *petView;
@property (weak, nonatomic) IBOutlet UILabel *comeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIImageView *internalImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *earlyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigBedLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *tooBar;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (strong,nonatomic) NSMutableArray *arr;
@property (weak, nonatomic) IBOutlet UILabel *petLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;
@property (weak, nonatomic) IBOutlet UILabel *eigtLabel;
@property (strong,nonatomic) hotelDetailModel *detailModel;
@property (strong,nonatomic)NSDate *afterTomorrow;
@property (weak, nonatomic) IBOutlet UIView *pickerview;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (strong,nonatomic)NSString *startTime;
- (IBAction)mapBtnAct:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    _datePicker.backgroundColor = UIColorFromRGB(235, 235, 241);
    _datePicker.minimumDate = [NSDate date];
    _arr = [NSMutableArray new];
    [self hotelDetailRequest];
    
    
    // Do any additional setup after loading the view.
    //状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    _DetailScrollView.showsVerticalScrollIndicator = NO;
    
    NSTimeInterval  inttime = [Utilities cTimestampFromString:_intiemstr format:@"yyyy-MM-dd"];
    NSTimeInterval  outtime = [Utilities cTimestampFromString:_outtimestr format:@"yyyy-MM-dd"];
    followUpTime = inttime;
    datetime = outtime;
    _startTime =_intiemstr;
    

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void) naviConfig{
   
    //设置导航条的风格颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(23,115,232)];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //实例化一个button，类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回3"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];

}
-(void)leftButtonAction:(UIButton *)sender{
    //跳转回原来页
       [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - quest
//网络请求
-(void)hotelDetailRequest{
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =@{@"id":@(_hotelId)};
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        
        if([responseObject[@"result"]intValue] == 1){
            NSDictionary *content = responseObject[@"content"];
        NSArray *hotel_facilities = content[@"hotel_facilities"];
            for(NSInteger i = 0 ; i < hotel_facilities.count ; i ++){
                NSString *string = hotel_facilities[i];
                if (i == 0){
                   _oneLabel.text = string;
                }if(i == 1){
                    _fourLabel.text = string;
                }if(i == 2){
                    _sevenLabel.text = string;
                }if(i == 3){
                    _twoLabel.text = string;
                }if(i == 4){
                    _secondLabel.text = string;
                }if(i == 5){
                    _sixLabel.text = string;
                }if(i == 6){
                    _fiveLabel.text = string;
                }if(i == 7){
                    _eigtLabel.text = string;
                }
            }
            NSArray *remark = content[@"remarks"];
              for(NSInteger j = 0 ; j < remark.count ; j ++){
                  NSString *rem = remark[j];
                  if(j==0){
                      _comeLabel.text = rem;
                  }if(j==1){
                      _leaveLabel.text = rem;
                  }
              }
        NSArray *hotel_types = content[@"hotel_types"];
            for(NSInteger s = 0 ; s < hotel_types.count ; s ++){
                NSString *type = hotel_types[s];
                if(s==0){
                    _roomLabel.text = type;
                }if(s==1){
                     _earlyLabel.text = type;
                }if(s==2){
                    _bigBedLabel.text = type;
                }if(s==3){
                    _sizeLabel.text = type;
                }

            }
            NSArray *image = content[@"hotel_imgs"];
            for(NSString *string in image){
              NSString *img = [NSHomeDirectory()stringByAppendingString:string];
                [_arr addObject:img];
            }
            _detailModel = [[hotelDetailModel alloc]initWithDictionary:content];
            _nameLabel.text = _detailModel.hotel_name;
            _adressLabel.text = _detailModel.hotel_address;
            _priceLabel.text = [NSString stringWithFormat:@"%ld",(long)_detailModel.now_price];
            _priceLabel.text = [NSString stringWithFormat:@"¥%@",_priceLabel.text];
            _petLabel.text = _detailModel.is_pet;
            
            
            [self addZLImageViewDisPlayView];
            //初始化日期格式器
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            //定义日期格式
            formatter.dateFormat = @"yyyy-MM-dd";
            //当前时间
            NSDate *dates = [NSDate date];
            //后天的日期
            NSDate *dateAfterdays = [NSDate dateWithDaysFromNow:2];
            NSDate *dateday = [NSDate dateWithDaysFromNow:1];
            NSString *dateStr = [formatter stringFromDate:dates];
            NSString *dateTomStr= [formatter stringFromDate:dateAfterdays];
            NSString *datedayStr = [formatter stringFromDate:dateday];
            
            NSTimeInterval  tomorrow = [Utilities cTimestampFromString:dateTomStr format:@"yyyy-MM-dd"];
 
            NSTimeInterval  outtime = [Utilities cTimestampFromString:_outtimestr format:@"yyyy-MM-dd"];
          
            NSTimeInterval  date1 = [Utilities cTimestampFromString:dateStr format:@"yyyy-MM-dd"];
            NSTimeInterval  intime = [Utilities cTimestampFromString:_intiemstr format:@"yyyy-MM-dd"];
            NSTimeInterval  dateday1 = [Utilities cTimestampFromString:datedayStr format:@"yyyy-MM-dd"];
            
            if (intime > date1) {
                _dayLabel.text = NULL;
            }if (intime == tomorrow){
                _dayLabel.text =[NSString stringWithFormat:@"后天"] ;
            }
            if(intime ==  date1){
                _dayLabel.text =[NSString stringWithFormat:@"今天"] ;
            }
            if (intime == dateday1){
                _dayLabel.text =[NSString stringWithFormat:@"明天"] ;
            }

            if (outtime>tomorrow) {
                _nextDayLabel.text =NULL;
            }
            if (outtime == dateday1){
                _nextDayLabel.text =[NSString stringWithFormat:@"明天"] ;
            }
            if(outtime == tomorrow){
                _nextDayLabel.text =[NSString stringWithFormat:@"后天"] ;
            }
            //将处理好的字符串设置给两个Button
            [_dateBtn setTitle: _intiemstr forState:UIControlStateNormal];
            [_nextDateBtn setTitle:_outtimestr forState:UIControlStateNormal];
        }
        else{
            
        }
    }
failure:^(NSInteger statusCode, NSError *error) {
    [aiv stopAnimating];
    [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];

   }
-(void) addZLImageViewDisPlayView{
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    CGRect frame = CGRectMake(0, 0, screenFrame.size.width, 170);
    
    NSArray *imageArray =@[@"酒店1.jpg",@"酒店2.jpg",@"酒店3.jpg"];
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray =imageArray;
    imageViewDisplay.scrollInterval = 2;
    imageViewDisplay.animationInterVale = 0.6;
    [self.DetailScrollView addSubview:imageViewDisplay];
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


- (IBAction)dateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag=0;
    _tooBar.hidden = NO;
    _datePicker.hidden = NO;
    _pickerview.hidden= NO;
    _datePicker.minimumDate = [NSDate date];
 
}
- (IBAction)nextDateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag=1;
    _tooBar.hidden = NO;
    _datePicker.hidden = NO;
    _pickerview.hidden= NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
//    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:(followUpTime / 1000)];
//    NSString *timeStr = [formatter stringFromDate:date1];
//
//    NSDate *date = [formatter dateFromString:timeStr];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:_startTime];
    NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    _datePicker.minimumDate = nextDat;
    

}
- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        PurchaseTableViewController *purchaseVC = [Utilities getStoryboardInstance:@"BookHotels" byIdentity:@"purchaseNavi"];
        NSString *dateStr = [NSString stringWithFormat:@"%@",_dateBtn.titleLabel.text];
        NSTimeInterval dates = [Utilities cTimestampFromString:dateStr format:@"yyyy-MM-dd"];
        NSString *nextDateStr = [NSString stringWithFormat:@"%@",_nextDateBtn.titleLabel.text];
        NSTimeInterval nextDate = [Utilities cTimestampFromString:nextDateStr format:@"yyyy-MM-dd"];
        NSTimeInterval days = nextDate - dates;
        NSInteger totaldays =days/(24*60*60*1000);
        NSLog(@"%f",days/(24*60*60*1000));
        //传参
        purchaseVC.intimestr = dates;
        purchaseVC.outtimestr = nextDate;
        purchaseVC.days = totaldays;
        purchaseVC.hotelModel =_detailModel;
        //push跳转
        [self.navigationController pushViewController:purchaseVC animated:YES];
    }else{
        //获取要跳转过去的页面
        UINavigationController *signNavi = [Utilities getStoryboardInstance:@"Login" byIdentity:@"LoginNavi"];
        //执行跳转
        [self presentViewController:signNavi animated:YES completion:nil];
    }

}
//取消事件
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _pickerview.hidden= YES;
    _tooBar.hidden = YES;
    _datePicker.hidden = YES;
    
}
//确定事件
- (IBAction)confirmAction:(UIBarButtonItem *)sender {
     _pickerview.hidden= YES;
    _tooBar.hidden = YES;
    _datePicker.hidden = YES;
     NSDate *date = _datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
   NSString *thDate = [formatter stringFromDate:date];
    
    //获取默认时间
    //当前时间
    NSDate *dateToday = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:dateToday];
    NSTimeInterval todayTime = [Utilities cTimestampFromString:dateStr format:@"yyyy-MM-dd"];
    NSDate *dateAfterdays = [NSDate dateWithDaysFromNow:2];
    NSDate *tomorrowdays =  [NSDate dateWithDaysFromNow:1];
    NSString *aftertomorrow = [formatter stringFromDate:dateAfterdays];
    NSString *tomorrowStr =   [formatter stringFromDate:tomorrowdays];
    NSTimeInterval  dateAfter = [Utilities cTimestampFromString:aftertomorrow format:@"yyyy-MM-dd"];
    NSTimeInterval  tomorrow = [Utilities cTimestampFromString:tomorrowStr format:@"yyyy-MM-dd"];

    if(flag == 1){
         [_nextDateBtn setTitle:thDate forState:UIControlStateNormal];
        datetime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd"];
        
    }else{
        [_dateBtn setTitle:thDate forState:UIControlStateNormal];
        followUpTime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd"];
        _startTime = thDate;
        if(followUpTime >= datetime){
            NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
            NSString *endTime =  [formatter stringFromDate:nextDat];
            [_nextDateBtn  setTitle:endTime forState:UIControlStateNormal];
            datetime = [Utilities cTimestampFromString:endTime format:@"yyyy-MM-dd"];
        }
        if(followUpTime ==todayTime){
            _dayLabel.text =[NSString stringWithFormat:@"今天"];
        }
        if(followUpTime ==tomorrow){
            _dayLabel.text =[NSString stringWithFormat:@"明天"];

        }
        if(followUpTime ==dateAfter)
        
        {
            _dayLabel.text =[NSString stringWithFormat:@"后天"];
        }
        if(followUpTime > dateAfter ){
        _dayLabel.text = nil;
        }
}
            if(datetime ==todayTime){
                _nextDayLabel.text =[NSString stringWithFormat:@"今天"];
            }
            if(datetime ==tomorrow){
                 _nextDayLabel.text =[NSString stringWithFormat:@"明天"];
            }
            if(datetime ==dateAfter){
                 _nextDayLabel.text =[NSString stringWithFormat:@"后天"];
            }
            if(datetime > dateAfter ){
                _nextDayLabel.text = nil;
            }
}

- (IBAction)mapBtnAct:(UIButton *)sender forEvent:(UIEvent *)event {
    MapViewController *purchaseVC = [Utilities getStoryboardInstance:@"BookHotels" byIdentity:@"mapNavi"];
    //传参
    purchaseVC.latitude =_detailModel.latitude;
    purchaseVC.longitude = _detailModel.longitude;
    NSLog(@"purchaseVC.mapModel %@",purchaseVC.mapModel);
    //push跳转
    [self.navigationController pushViewController:purchaseVC animated:YES];
}
@end
