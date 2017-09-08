//
//  AviationViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AviationViewController.h"
#import "UserModel.h"
#import "AviationModel.h"
#import "CityTableViewController.h"
#import "LoginViewController.h"
@interface AviationViewController ()<UITextFieldDelegate>{
    NSTimeInterval followUpTime;
    NSInteger PageNum;
    NSInteger  flag;
    BOOL dateFlag;
}
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
- (IBAction)dateActionButton:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *nextDateButton;
- (IBAction)nextDateActionButton:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *departureCityBtn;
- (IBAction)departureCityActionBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *nextDayLab;
@property (weak, nonatomic) IBOutlet UIButton *targetCityBtn;
- (IBAction)targetCitiesActionBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITextField *lowPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *highPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet UIButton *releaseButton;
- (IBAction)releaseActionButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *tooBar;
@property (strong,nonatomic) NSString *city;
@property (weak, nonatomic) IBOutlet UIView *pickerview;
@property (strong,nonatomic)NSString *dateStr;
@property (strong,nonatomic)NSString *dateTomStr;



@end

@implementation AviationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    
    _datePicker.minimumDate = [NSDate date];
    //_arr = [NSMutableArray new];
    
    _datePicker.backgroundColor = [UIColor whiteColor];
    //把状态栏变成白色
    //[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //调用设置导航样式
    [self setNavigationItem];
    
    //设置默认时间
    [self defaultDate];
    //接收一个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:@"Resetcity" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航样式
- (void)setNavigationItem {
    //设置导航栏标题
    self.navigationItem.title = @"发布需求";
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(23, 115, 232)];
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    //实例化一个button，类型为UIButtonTypeSystem
    //UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    //leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置背景图片为返回图片
    //[leftBtn setBackgroundImage:[UIImage imageNamed:@"返回3"] forState:UIControlStateNormal];
    //给按钮添加事件
    //[leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
//英文键盘默认高度216
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //重写textField这个方法
    //NSLog(@"开始编辑");
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+216+50);
    NSLog(@"偏移高度为 --- %f",offset);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

-(void)defaultDate{
    //初始化日期格式器
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //定义日期格式
    formatter.dateFormat = @"MM-dd";
    //当前时间
    NSDate *date = [NSDate date];
    //后天的日期
    NSDate *Tomorrow = [NSDate dateWithDaysFromNow:1];
    NSDate *dateAfterdays = [NSDate dateWithDaysFromNow:2];
    _dateStr = [formatter stringFromDate:Tomorrow];
    _dateTomStr= [formatter stringFromDate:dateAfterdays];
    //将处理好的字符串设置给两个Button
    [_dateButton setTitle:_dateStr forState:UIControlStateNormal];
    [_nextDateButton setTitle:_dateTomStr forState:UIControlStateNormal];
    
}
//-(NSString *)getNDay:(NSInteger)n{
//
//        NSDate*nowDate = [NSDate date];
//
//        NSDate* theDate;
//
//        if(n!=0){
//                 NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
//                theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*n ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
//
//             }else{
//
//                     theDate = nowDate;
//                 }
//
//        NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
//         [date_formatter setDateFormat:@"yyyy-MM-dd"];
//         NSString *the_date_str = [date_formatter stringFromDate:theDate];
//
//         return the_date_str;
//     }



//当textfield结束编辑的时候调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //当都输入了之后，按钮才能被点击
    if (textField == _lowPriceTextField || textField == _highPriceTextField || textField == _titleTextField || textField == _detailsTextField) {
        if (_lowPriceTextField.text.length != 0 && _highPriceTextField.text.length != 0 && _titleTextField.text.length != 0 && _detailsTextField.text.length != 0) {
            //确认按钮启用
            _releaseButton.enabled = YES;
            _releaseButton.backgroundColor = UIColorFromRGB(66, 162, 233);
        }
    }
}

//按键盘return收回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _pickerview.hidden = YES;
}
//
#pragma mark - quest
//网络请求
-(void)aviationRequest{
    UserModel *user = [[StorageMgr singletonStorageMgr]objectForKey:@"UserInfo"];
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =@{@"openid" : user.openid, @"set_low_time_str": _dateButton.titleLabel.text,@"set_high_time_str":_nextDateButton.titleLabel.text,@"set_hour":@"20",@"departure":_departureCityBtn.titleLabel.text,@"destination":_targetCityBtn.titleLabel.text,@"low_price":_lowPriceTextField.text,@"high_price":_highPriceTextField.text,@"aviation_demand_detail":_detailsTextField.text,@"aviation_demand_title":_titleTextField.text,@"is_back":@5,@"back_low_time_str":@"无",@"back_high_time_str":@"无",@"people_number":@3,@"child_number":@1,@"weight":@50.0};
    [RequestAPI requestURL:@"/addIssue_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        
        if([responseObject[@"result"]intValue] == 1){
            
            [Utilities popUpAlertViewWithMsg:@"恭喜你发布成功，请注意接收消息" andTitle:nil onView:self ];
            _lowPriceTextField.text = @"";
            _highPriceTextField.text = @"";
            _detailsTextField.text =@"";
            _titleTextField.text =@"";
        }
        else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self ];
        }
    }
                   failure:^(NSInteger statusCode, NSError *error) {
                       [aiv stopAnimating];
                       [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:@"提示" onView:self ];
                   }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
- (IBAction)dateActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
    dateFlag = YES;
    _pickerview.hidden = NO;
    //    _datePicker.hidden = NO;
    //    _tooBar.hidden = NO;
    //    NSDate *date = _datePicker.date;
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    formatter.dateFormat = @"MM-dd";
    //    NSString *thDate = [formatter stringFromDate:date];
    //    [_dateButton setTitle:thDate forState:UIControlStateNormal];
    
}
- (IBAction)nextDateActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
    dateFlag = NO;
    _pickerview.hidden = NO;
    //    _datePicker.hidden = NO;
    //    _tooBar.hidden = NO;
    //    NSDate *date = _datePicker.date;
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    formatter.dateFormat = @"MM-dd";
    //    NSString *thDate = [formatter stringFromDate:date];
    //
    //   [_nextDateButton setTitle:thDate forState:UIControlStateNormal];
}
- (IBAction)departureCityActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    CityTableViewController *citylist = [Utilities getStoryboardInstance:@"Main" byIdentity:@"City"];
    [self.navigationController pushViewController:citylist animated:YES];
    citylist.tag = 2;
    
}
- (IBAction)targetCitiesActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    CityTableViewController *citylist = [Utilities getStoryboardInstance:@"Main" byIdentity:@"City"];
    [self.navigationController pushViewController:citylist animated:YES];
    citylist.tag = 2;
    
}
- (IBAction)releaseActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        [self aviationRequest];
        [self performSegueWithIdentifier:@"AviationToMyRelease" sender:self];
    }
    else{
        LoginViewController *login = [Utilities getStoryboardInstance:@"Login" byIdentity:@"login"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _pickerview.hidden = YES;
    
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    _pickerview.hidden = YES;
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM-dd";
    NSString *thDate = [formatter stringFromDate:date];
    followUpTime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd HH:mm"];
    if(dateFlag){
        [_dateButton setTitle:thDate forState:UIControlStateNormal];
    }else{
        [_nextDateButton setTitle:thDate forState:UIControlStateNormal];
    }
    
    
    
}

//接收通知执行的方法，将拿到的城市给相应的按钮
-(void)changeCity:(NSNotification *)name{
    NSString *citystr = name.object;
    if (flag == 1) {
        [_departureCityBtn setTitle:citystr forState:UIControlStateNormal];
        _city = citystr;
    }else if([_city isEqualToString:citystr]){
        
        [Utilities popUpAlertViewWithMsg:@"请正确选择城市" andTitle:nil onView:self];
        
    }else{
        [_targetCityBtn setTitle:citystr forState:UIControlStateNormal];
    }
}


@end
