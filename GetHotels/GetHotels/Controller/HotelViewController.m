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
@interface HotelViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    BOOL firstVisit;
}
@property (weak, nonatomic) IBOutlet UIButton *homeLocation;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (strong,nonatomic)CLLocationManager *locMgr;
@property (strong,nonatomic)CLLocation *location;
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstVisit = YES;
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self locationConfig];
    [self enterApp];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(chooseCity:) name:@"ResetCity" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self locationStart];
}
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                NSLog(@"locDict = %@",locDict);
                NSString *city = locDict[@"City"];
                city = [city substringToIndex:city.length - 1];
                NSLog(@"%@",city);
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
