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
#import "LoginViewController.h"

@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIImageView *oneStarImg;
@property (weak, nonatomic) IBOutlet UIImageView *twoStarImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeStarImg;
@property (weak, nonatomic) IBOutlet UITableView *myInfoTableView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

- (IBAction)menuAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong, nonatomic) NSArray *arr;
@property (strong,nonatomic) UIView *markView;

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
        _usernameLabel.hidden = YES;
        _loginBtn.hidden = NO;
        _menuBtn.hidden = NO;
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
            _usernameLabel.hidden = NO;
            _loginBtn.hidden = YES;
            _menuBtn.hidden = YES;
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
    if (![Utilities loginCheck]){
        [Utilities popUpAlertViewWithMsg:@"请先登录" andTitle:nil onView:self];
    } else {
        if (indexPath.section == 0){
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"HomeToOrder" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"MyInfoToIssue" sender:self];
                    break;
                }
        } else {
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"MyInfoToSet" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"MyInfoToDeleget" sender:self];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"MyInfoToCall" sender:self];
                    break;
            }
        }
    }
        
}

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    LoginViewController *login = [Utilities getStoryboardInstance:@"Login" byIdentity:@"login"];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:login];
    [self presentViewController:nc animated:YES completion:nil];
}
- (IBAction)menuAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, UI_SCREEN_H)];
    _markView.backgroundColor = UIColorFromRGBA(104, 104, 104, 0.3);
    //[self.view addSubview:_markView];
    [[UIApplication sharedApplication].keyWindow addSubview:_markView];
    UIView *popoverView = [UIView new];
    popoverView.layer.cornerRadius = 5;
    popoverView.frame = CGRectMake((UI_SCREEN_W - 300)/2, (UI_SCREEN_H - 240)/2, 300, 160);
    popoverView.backgroundColor = [UIColor whiteColor];
    [self.markView addSubview:popoverView];
    UILabel *popLabel = [UILabel new];
//    popLabel.x = popoverView.width/5;
//    popoverView.y = popoverView.height/4;
    popLabel.frame = CGRectMake(popoverView.width/6, popoverView.height/5,200, 50);
    popLabel.text = @"确定退出登录 ？";
    popLabel.font = [UIFont systemFontOfSize:A_Font];
    popLabel.textColor = [UIColor grayColor];
    [popoverView addSubview:popLabel];
    UIButton *popBtn = [[UIButton alloc]initWithFrame:CGRectMake(popoverView.width - 100, popoverView.height - 50, 80, 40)];
    [popBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    popBtn.titleLabel.font = [UIFont systemFontOfSize:B_Font];
    [popBtn setTitleColor:SELECT_COLOR forState:UIControlStateNormal];
    [popoverView addSubview:popBtn];
    [popBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(popoverView.width - 180, popoverView.height - 50, 80, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:B_Font];
    [cancelBtn setTitleColor:UNSELECT_TITLECOLOR forState:UIControlStateNormal];
    [popoverView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)popAction{
    [_markView removeFromSuperview];
    _markView = nil;
    LoginViewController *login = [Utilities getStoryboardInstance:@"Login" byIdentity:@"login"];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:login];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)cancelAction{
    [_markView removeFromSuperview];
    _markView = nil; 
}
@end
