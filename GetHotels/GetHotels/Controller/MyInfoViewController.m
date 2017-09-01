//
//  MyInfoViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTableViewCell.h"
#import "UserModel.h"

@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIImageView *oneStarImg;
@property (weak, nonatomic) IBOutlet UIImageView *twoStarImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeStarImg;
@property (weak, nonatomic) IBOutlet UITableView *myInfoTableView;

@property (strong, nonatomic) NSArray *arr;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //去掉tableview底部多余的线
    _myInfoTableView.tableFooterView = [UIView new];
    _arr = @[@{@"leftIcon" : @"酒店大", @"title" : @"我的酒店"}, @{@"leftIcon" : @"飞机大", @"title" : @"我的航空"}, @{@"leftIcon" : @"信息", @"title" : @"我的消息"}, @{@"leftIcon" : @"设置", @"title" : @"账户设置"}, @{@"leftIcon" : @"协议", @"title" : @"使用协议"}, @{@"leftIcon" : @"电话", @"title" : @"联系客服"}];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    if ([Utilities loginCheck]){
        _loginBtn.hidden = YES;
        _usernameLabel.hidden = NO; 
        _usernameLabel.text = [[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"]; 
        UserModel *model = [[StorageMgr singletonStorageMgr] objectForKey:@"UseInfo"];
        if ([model.grade integerValue] == 1){
            _oneStarImg.image = [UIImage imageNamed:@"星级"];
        } else if([model.grade integerValue] == 2){
            _oneStarImg.image = [UIImage imageNamed:@"星级"];
            _twoStarImg.image = [UIImage imageNamed:@"星级"];
        }else if([model.grade integerValue] == 3){
            _oneStarImg.image = [UIImage imageNamed:@"星级"];
            _twoStarImg.image = [UIImage imageNamed:@"星级"];
            _threeStarImg.image = [UIImage imageNamed:@"星级"];
        }
        else {
            _oneStarImg.image = [UIImage imageNamed:@"星级2"];
            _twoStarImg.image = [UIImage imageNamed:@"星级2"];
            _threeStarImg.image = [UIImage imageNamed:@"星级2"];
            }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#

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
    return 2;
}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

//当一个细胞将要出现的时候要做的事情
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//设置每一组中每一行细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0){
        return 5.f;
    }
    return 0;
}

//设置每一组中每一行的细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMyInfoCell" forIndexPath:indexPath];
    if (indexPath.section == 0){
        NSDictionary *dict = _arr[indexPath.row];
        cell.myInfoCellImg.image = [UIImage imageNamed:dict[@"leftIcon"]];
        cell.myInfoCellLabel.text = dict[@"title"];
    }else {
        NSDictionary *dict = _arr[indexPath.row + 3];
        cell.myInfoCellImg.image = [UIImage imageNamed:dict[@"leftIcon"]];
        cell.myInfoCellLabel.text = dict[@"title"];
    }
    return  cell;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击某行细胞变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![Utilities loginCheck] && indexPath.section == 0){
        [Utilities popUpAlertViewWithMsg:@"请先登录" andTitle:nil onView:self];
    } else {
        if (indexPath.section == 0){
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"HomeToOrder" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"MyInfoToMyRelease" sender:self];
                    break;
                }
            }
        }
        
}

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
