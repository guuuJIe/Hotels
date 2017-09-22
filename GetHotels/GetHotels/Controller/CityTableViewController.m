//
//  CityTableViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "CityTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AviationViewController.h"
@interface CityTableViewController ()<CLLocationManagerDelegate>{
    BOOL firstVisit; 
}
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (strong,nonatomic)NSDictionary *cities;
@property (strong,nonatomic)NSArray *keys;
@property (strong,nonatomic)CLLocationManager *locMgr;
@property  (strong,nonatomic)CLLocation *location;
@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication.sharedApplication.keyWindow setBackgroundColor:[UIColor darkGrayColor]];
    [self naviConfig];
    [self uiLayout];
    [self dataInitalize];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//每次要离开这个页面的时候,结束定位
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locMgr stopUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication.sharedApplication.keyWindow setBackgroundColor:THEME_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置背景图片为返回图片
    
    //实例化一个button，类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);

    //设置背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回3"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

//用Modal方式返回上一页
- (void)leftButtonAction {
    //[self dismissViewControllerAnimated:YES completion:nil];
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)uiLayout {
    if ([[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"] isKindOfClass:[NSNull class]]) {
        if ([[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"] != nil) {
            //已经获得定位，将定位到的城市显示在按钮上
            [_cityBtn setTitle:[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"] forState:UIControlStateNormal];
            _cityBtn.enabled = YES;
            return;
        }
    }
    //当还没有获取定位的情况下，去执行定位功能
    [self locationStart];
}
-(void)locationStart {
    _locMgr = [CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //设置定位到的设备位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLDistanceFilterNone;
    //设置把地球设置分割成边长多少的精度的方块
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    //打开定位服务的开关(开始定位)
    [_locMgr startUpdatingLocation];
}
- (void)dataInitalize {
    firstVisit = YES;
    //创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //获取要读取的文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"plist"];
    //判断路径是否存在文件
    if ([fileMgr fileExistsAtPath:filePath]) {
        //将文件内容读取为对应的格式
        NSDictionary *fileContent = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //判断读取到的内容是否存在（判断文件是否损坏）
        if (fileContent) {
            //NSLog(@"fileContent = %@", fileContent);
            _cities = fileContent;
            //提取字典中所有的键
            NSArray *rawKeys = [fileContent allKeys];
            //根据拼音首字母进行能够识别多音字的升序排序
            _keys = [rawKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //获取当前正在渲染的组的名称
    NSString *key = _keys[section];
    //根据组的名称，作为键来查询到对应的值（这个值就是这一组城市对应城市数组)
    NSArray *sectionCity = _cities[key];
    //返回这一组城市的个数来作为行数
    return sectionCity.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    NSString *key = _keys[indexPath.section];
    NSArray *sectionCities = _cities[key];
    NSDictionary *city = sectionCities[indexPath.row];
    cell.textLabel.text = city[@"name"];
    return cell;

    
    return cell;
}
//设置组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _keys[section];
}

//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}

//设置每一组中每一行细胞被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = _keys[indexPath.section];
    NSArray *sectionCities = _cities[key];
    NSDictionary *city = sectionCities[indexPath.row];
    if(_tag == 1){
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"ResetCity" object:city[@"name"]] waitUntilDone:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"Resetcity" object:city[@"name"]] waitUntilDone:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//设置右侧快捷键栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _keys;
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

//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    //NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    // NSLog(@"经度:%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //判断flag思想判断是否可以去根据定位拿到城市
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
                //NSLog(@"%@",locDict);
                NSString *city = locDict[@"City"];
                city = [city substringToIndex:city.length - 1];
                //NSLog(@"%@",city);
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                //将定位到的城市保存进单例化全局变量
                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:city];
                //修改城市按钮标题
                [Utilities removeUserDefaults:@"UserCity"];
                [_cityBtn setTitle:city forState:UIControlStateNormal];
                _cityBtn.enabled = YES;
                //修改用户选择城市的记忆体
                [Utilities setUserDefaults:@"UserCity" content:city];
                //[self presentViewController:alertView animated:YES completion:nil];
                
            }
        }];
        //过三秒钟关掉开关
        [_locMgr stopUpdatingLocation];
    });
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
