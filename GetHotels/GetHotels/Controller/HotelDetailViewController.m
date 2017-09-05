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
@interface HotelDetailViewController (){
    NSTimeInterval followUpTime;
    NSUInteger flag;
    NSTimeInterval  date;
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
                    _twoLabel.text = string;
                }if(i == 2){
                    _secondLabel.text = string;
                }if(i == 3){
                    _fourLabel.text = string;
                }if(i == 4){
                    _fiveLabel.text = string;
                }if(i == 5){
                    _sixLabel.text = string;
                }if(i == 6){
                    _sevenLabel.text = string;
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
            _priceLabel.text = _detailModel.now_price;
            _priceLabel.text = [NSString stringWithFormat:@"¥%@",_priceLabel.text];
            _petLabel.text = _detailModel.is_pet;
            
            
            [self addZLImageViewDisPlayView];
            //初始化日期格式器
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            //定义日期格式
            formatter.dateFormat = @"yyyy-MM-dd";
            //当前时间
            NSDate *date = [NSDate date];
            //后天的日期
            NSDate *dateAfterdays = [NSDate dateWithDaysFromNow:2];
            NSString *dateStr = [formatter stringFromDate:date];
            NSString *dateTomStr= [formatter stringFromDate:dateAfterdays];
            //将处理好的字符串设置给两个Button
            [_dateBtn setTitle:dateStr forState:UIControlStateNormal];
            [_nextDateBtn setTitle:dateTomStr forState:UIControlStateNormal];
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
 
}
- (IBAction)nextDateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag=1;
    _tooBar.hidden = NO;
    _datePicker.hidden = NO;
    _pickerview.hidden= NO;

}
- (IBAction)buyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        PurchaseTableViewController *purchaseVC = [Utilities getStoryboardInstance:@"BookHotels" byIdentity:@"purchaseNavi"];
        //传参
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
    NSTimeInterval  day = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd"];
    //获取默认时间
    //当前时间
    NSDate *dateToday = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:dateToday];
    NSTimeInterval startTime = [Utilities cTimestampFromString:dateStr format:@"MM-dd"];
    NSDate *dateAfterdays = [NSDate dateWithDaysFromNow:2];
    NSDate *tomorrowdays = [NSDate dateWithDaysFromNow:1];
    NSString *aftertomorrow= [formatter stringFromDate:dateAfterdays];
    NSString *tomorrowStr= [formatter stringFromDate:tomorrowdays];
     NSTimeInterval  dateAfter = [Utilities cTimestampFromString:aftertomorrow format:@"yyyy-MM-dd"];
     NSTimeInterval  tomorrow = [Utilities cTimestampFromString:tomorrowStr format:@"yyyy-MM-dd"];
    if(flag == 0){
        if(day < startTime){
            [Utilities popUpAlertViewWithMsg:@"请正确选择日期" andTitle:@"提示" onView:self];
        }else{
            [_dateBtn setTitle:thDate forState:UIControlStateNormal];
            startTime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd"];
        }
        
    }else{
        if(day<= startTime){
            [Utilities popUpAlertViewWithMsg:@"请正确选择日期" andTitle:@"提示" onView:self];
        }else{
            if(day > dateAfter){
                _nextDayLabel.text = nil;
            }else{
                 _nextDayLabel.text =[NSString stringWithFormat:@"后天"] ;
            }
            if(day == tomorrow){
                _nextDayLabel.text =[NSString stringWithFormat:@"明天"] ;
            }
        }
         [_nextDateBtn setTitle:thDate forState:UIControlStateNormal];
        
        
    }
}
 

@end
