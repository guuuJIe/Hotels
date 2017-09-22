//
//  LoginViewController.m
//  GetHotels
//
//  Created by mac on 2017/8/21.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;//菊花膜(蒙层)

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //把状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //设置图片的边框宽度
    _userImageView.layer.borderWidth = 0.5;
    //设置图片的边框颜色
    _userImageView.layer.borderColor = UIColorFromRGB(66, 162, 233).CGColor;
    
    //阴影颜色
    _loginView.layer.shadowColor = [UIColor blackColor].CGColor;
    //偏移距离
    _loginView.layer.shadowOffset = CGSizeMake(0,0);
    //不透明度
    _loginView.layer.shadowOpacity = 0.5;
    //半径
    _loginView.layer.shadowRadius = 5.0;
    
    //登录按钮禁用
    _loginBtn.enabled = NO;
    //_loginBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    
    //添加事件监听当输入框文本内容改变时，调用textChange:方法
    [_phoneTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    //调用设置导航样式
    [self setNavigationItem];
    //调用记忆用户名
    [self uilayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航样式
- (void)setNavigationItem {
    //设置导航栏标题
    self.navigationItem.title = @"会员登录";
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

//记忆用户名
-(void)uilayout{
    //判断是否存在用户记忆体
    if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        if ([Utilities getUserDefaults:@"Username"] != nil) {
            //将用户名显示在输入框中
            _phoneTextField.text = [Utilities getUserDefaults:@"Username"];
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


//输入框内容改变的监听事件
- (void)textChange: (UITextField *)textField {
    //当文本框中的内容改变时判断内容长度是否为0，是：禁用按钮，否：启用按钮
    if (_phoneTextField.text.length != 0 && _pwdTextField.text.length != 0) {
        //登录按钮启用
        _loginBtn.enabled = YES;
        _loginBtn.backgroundColor = UIColorFromRGB(66, 162, 233);
    } else {
        //登录按钮禁用
        _loginBtn.enabled = NO;
        //_loginBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    }
}

//键盘收回
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTextField || textField == _pwdTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - request 网络请求

//登录接口
- (void)loginRequest {
    //点击按钮的时候创建一个蒙层(菊花膜)，并显示在当前页面(防止连续点击按钮)
    _aiv = [Utilities getCoverOnView:self.view];
    //参数(用户手机号和密码)
    NSDictionary *para = @{@"tel" : _phoneTextField.text,@"pwd" : _pwdTextField.text};
    NSLog(@"参数:%@",para);
    //网络请求(方法是kPost，数据提交方式是kForm)
    [RequestAPI requestURL:@"/login" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情在此处执行
        NSLog(@"登录：%@", responseObject);
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_aiv stopAnimating];
        if ([responseObject[@"result"] integerValue] == 1) {
            NSDictionary *content = responseObject[@"content"];
            UserModel *userModel = [[UserModel alloc] initWithDict:content];
            //将登录获取到的用户信息打包存储到单例化的全局变量中
            [[StorageMgr singletonStorageMgr] addKey:@"UserInfo" andValue:userModel];
            //单独将用户的ID也存储进单例化的全局变量来作为用户是否已经登录的判断依据，同时也方便其他页面更快的使用用户ID参数
            [[StorageMgr singletonStorageMgr] addKey:@"MemberId" andValue:userModel.nickname];
            //如果键盘还打开就让它收回去
            [self.view endEditing:YES];
            
            //登录成功后清空密码
            _pwdTextField.text = @"";
            //登录成功后按钮禁用
            _loginBtn.enabled = NO;
            //_loginBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_phoneTextField.text];
            //登录成功后返回上一页
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
//            UINavigationController *tabBar = [Utilities getStoryboardInstance:@"Main" byIdentity:@"TabBar"];
//            //执行跳转
//            [self presentViewController:tabBar animated:YES completion:nil];
        } else {
            [_aiv stopAnimating];
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            //清空密码
            _pwdTextField.text = @"";
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //当网络请求成功的时候停止动画(菊花膜/蒙层停止转动消失)
        [_aiv stopAnimating];
        //失败提示框
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"温馨提示" onView:self];
    }];
}

#pragma mark - buttonAction

//登录按钮事件
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //判断某个字符串中是否都是数字
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if (_phoneTextField.text.length < 11 || [_phoneTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities
         popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:@"温馨提示" onView:self];
        //清空手机号，方便再次输入
        _phoneTextField.text = @"";
        return;
    }
    if (_phoneTextField.text.length == 0){
        [Utilities
         popUpAlertViewWithMsg:@"请输入你的手机号" andTitle:@"温馨提示" onView:self];
        return;
    }
    if (_pwdTextField.text.length == 0){
        [Utilities
         popUpAlertViewWithMsg:@"请输入密码" andTitle:@"温馨提示" onView:self];
        return;
    }
    if (_pwdTextField.text.length < 6 || _pwdTextField.text.length > 18){
        [Utilities
         popUpAlertViewWithMsg:@"您输入的密码必须在6-18之间" andTitle:@"温馨提示" onView:self];
        //清空密码，方便再次输入
        _pwdTextField.text = @"";
        return;
    }
    //无输入异常,开始正式执行登录接口
    [self loginRequest];
}

//注册按钮事件
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
     [self performSegueWithIdentifier:@"signupToLogin" sender:self];
}
     
@end
