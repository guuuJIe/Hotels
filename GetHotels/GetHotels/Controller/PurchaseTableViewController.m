//
//  PurchaseTableViewController.m
//  GetHotels
//
//  Created by mac on 2017/8/28.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "PurchaseTableViewController.h"

@interface PurchaseTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *payTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) NSArray *arr;
@property (strong, nonatomic) UIButton *payBtn;
@property (strong,nonatomic)NSIndexPath *index;
@end

@implementation PurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //把状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //调用设置导航样式
    [self naviConfig];
    [self uiLayout];
    [self dataInitilize];
    [self setFootViewForTableView];
   
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResultAction:) name:@"AlipayResult" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置导航样式
-(void)naviConfig {
    //设置导航条的标题文字
    self.navigationItem.title = @"支付";
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(23, 115, 232)];
    //self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    //实例化一个button，类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
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



//专门做界面
- (void)uiLayout {
    if (_tag == 1) {
        _nameLabel.text = [NSString stringWithFormat:@"%@  %@——%@",_releaseModel.company,_releaseModel.departure,_releaseModel.destination];
        NSString *timeStr = [Utilities dateStrFromCstampTime:_releaseModel.time withDateFormat:@"M月dd日 HH:mm"];
        _dateLabel.text = [NSString stringWithFormat:@"%@ 起飞",timeStr];
        _priceLabel.text = [NSString stringWithFormat:@"%ld元",(long)_releaseModel.finalPrice];
    }else {
        NSString *dateStr = [Utilities dateStrFromCstampTime:_intimestr withDateFormat:@"M月dd日"];
        NSString *dateTomStr = [Utilities dateStrFromCstampTime:_outtimestr withDateFormat:@"M月dd日"];
        _dateLabel.text = [NSString stringWithFormat:@"%@ -- %@",dateStr,dateTomStr];
        _nameLabel.text = _hotelModel.hotel_name;
        _priceLabel.text = [NSString stringWithFormat:@"%ld元",_hotelModel.now_price * _days];
    }
    self.tableView.tableFooterView = [UIView new];
    //将表格视图设置为"编辑中"
    self.tableView.editing = YES;
    
    //创建细胞的行号和组号(第一行，第一组)
    _index = [NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图中的某个细胞(默认选中某个细胞)
    [self.tableView selectRowAtIndexPath:_index animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)dataInitilize {
    _arr = @[@"支付宝支付",@"微信支付",@"银联支付"];
}


//当收到通知后要执行的方法
- (void)purchaseResultAction: (NSNotification *)note {
    NSString *result = note.object;
    if ([result isEqualToString:@"9000"]) {
        //成功
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"支付成功" message:@"恭喜你，你成功完成报名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:nil];
    } else {
        //失败
        [Utilities popUpAlertViewWithMsg:[result isEqualToString:@"4000"] ? @"未能成功支付，请确保账户余额充足" : @"你已取消支付" andTitle:@"支付失败" onView:self];
    }
}


#pragma mark - Table view data source

//设置组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"支付方式";
}

//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arr.count;
}

//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _arr[indexPath.row];
    
    return cell;
}

//设置每行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
    
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.payBtn.enabled = YES;
    _index = indexPath;
    //遍历表格视图中所有选中的细胞
    for (NSIndexPath *eachIP in tableView.indexPathsForSelectedRows)
    {
        //当选中的细胞不是当前正在按的这个细胞的情况下
        if (eachIP != indexPath)
        {
            //将细胞从选中状态改为不选中状态
            [tableView deselectRowAtIndexPath:eachIP animated:YES];
            
        }
        
    }
   
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.payBtn.enabled = NO;
}

//设置tableview的底部视图
- (void)setFootViewForTableView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 100)];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _payBtn.frame = CGRectMake(0, 60, UI_SCREEN_W, 40.f);
    [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    //设置按钮标题的字体大小
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [_payBtn setTitleColor:UIColorFromRGB(23, 115, 232) forState:UIControlStateNormal];
    _payBtn.backgroundColor = [UIColor whiteColor];
    [_payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_payBtn];
    
    [_payTableView setTableFooterView:view];
}

//确认支付按钮事件
- (void)payAction {
    switch (_index.row) {
        case 0: {
            
            if (_tag == 1) {
                //生成订单号
                NSString *tradeNo = [GBAlipayManager generateTradeNO];
                [GBAlipayManager alipayWithProductName:_releaseModel.company amount:[NSString stringWithFormat:@"%ld",(long)_releaseModel.finalPrice] tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@——%@飞机票",_releaseModel.departure,_releaseModel.destination] itBPay:@"50"];
            }else {
                //生成订单号
                NSString *tradeNo = [GBAlipayManager generateTradeNO];
                [GBAlipayManager alipayWithProductName:_hotelModel.hotel_name amount:[NSString stringWithFormat:@"%ld",(long)_hotelModel.now_price] tradeNO:tradeNo notifyURL:nil productDescription:[NSString stringWithFormat:@"%@入住费",_hotelModel.hotel_name] itBPay:[NSString stringWithFormat:@"%ld",(long)_hotelModel.now_price]];
            }
    
        }
            break;
        case 1: {
            
            
        }
            break;
        case 2: {
            
        }
            break;
        default:
            break;
    }
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
