//
//  AviationViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AviationViewController.h"
#import "UserModel.h"
#import "CityTableViewController.h"
@interface AviationViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
   NSTimeInterval followUpTime;
    NSInteger PageNum;
    NSInteger  flag;

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





@end

@implementation AviationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    
    _datePicker.backgroundColor = UIColorFromRGB(235, 235, 241);
    _datePicker.minimumDate = [NSDate date];
    //_arr = [NSMutableArray new];

    //把状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //调用设置导航样式
    [self setNavigationItem];
    //接收一个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:) name:@"ResetHome" object:nil];
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
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //重写textField这个方法
    //NSLog(@"将要结束编辑");
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}
//当textfield结束编辑的时候调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //当旧密码、新密码和确认密码都输入了之后，按钮才能被点击
    if (textField == _lowPriceTextField || textField == _highPriceTextField || textField == _titleTextField ) {
        if (_lowPriceTextField.text.length != 0 && _highPriceTextField.text.length != 0 && _titleTextField.text.length != 0) {
            //确认按钮启用
            _releaseButton.enabled = YES;
            _releaseButton.backgroundColor = UIColorFromRGB(66, 162, 233);
        }
    }
}

//按键盘return收回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _lowPriceTextField || textField == _highPriceTextField || textField == _titleTextField)  {
        [textField resignFirstResponder];
    }
    return YES;
}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - quest
//网络请求
-(void)aviationRequest{
    UserModel *user = [[StorageMgr singletonStorageMgr]objectForKey:@"UserInfo"];
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    NSDictionary *para =@{@"openid" : user.openid, @"set_low_time_str": _dateButton.titleLabel.text,@"set_high_time_str":_nextDateButton.titleLabel.text,@"departure":_departureCityBtn.titleLabel.text,@"destination":_targetCityBtn.titleLabel.text,@"low_price":_lowPriceTextField.text,@"high_price":_highPriceTextField.text,@"aviation_demand_detail":_detailsTextField.text,@"aviation_demand_title":_titleTextField.text};
    [RequestAPI requestURL:@"/findHotelById" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        
        if([responseObject[@"result"]intValue] == 1){
            
        }
        else{
            //初始化日期格式器
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            //定义日期格式
            formatter.dateFormat = @"MM-dd";
            //当前时间
            NSDate *date = [NSDate date];
            //后天的日期
            NSDate *dateAfterdays = [NSDate dateWithDaysFromNow:2];
            NSString *dateStr = [formatter stringFromDate:date];
            NSString *dateTomStr= [formatter stringFromDate:dateAfterdays];
            //将处理好的字符串设置给两个Button
            [_dateButton setTitle:dateStr forState:UIControlStateNormal];
            [_nextDateButton setTitle:dateTomStr forState:UIControlStateNormal];
        }
    }
                   failure:^(NSInteger statusCode, NSError *error) {
                       [aiv stopAnimating];
                       [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
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

- (IBAction)dateActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
    _datePicker.hidden = NO;
    _tooBar.hidden = NO;
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM-dd";
    NSString *thDate = [formatter stringFromDate:date];
    [_dateButton setTitle:thDate forState:UIControlStateNormal];
    
}
- (IBAction)nextDateActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
    _datePicker.hidden = NO;
    _tooBar.hidden = NO;
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM-dd";
    NSString *thDate = [formatter stringFromDate:date];
    [_nextDateButton setTitle:thDate forState:UIControlStateNormal];

}
- (IBAction)departureCityActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 1;
    [self performSegueWithIdentifier:@"AviationToMyRelease" sender:self];
    
}
- (IBAction)targetCitiesActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 0;
    [self performSegueWithIdentifier:@"AviationToMyRelease" sender:self];
    
}
- (IBAction)releaseActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _tooBar.hidden = YES;
    _datePicker.hidden = YES;
    
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    _tooBar.hidden = YES;
    _datePicker.hidden = YES;
    NSDate *date = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *thDate = [formatter stringFromDate:date];
    followUpTime = [Utilities cTimestampFromString:thDate format:@"yyyy-MM-dd HH:mm"];
    if(flag == 1){
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
