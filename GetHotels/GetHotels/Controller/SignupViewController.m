//
//  SignupViewController.m
//  GetHotels
//
//  Created by mac on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *signupView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;//菊花膜(蒙层)

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userImageView.layer.borderWidth = 0.5;
    _userImageView.layer.borderColor = UIColorFromRGB(66, 162, 233).CGColor;
    //阴影颜色
    _signupView.layer.shadowColor = [UIColor blackColor].CGColor;
    //偏移距离
    _signupView.layer.shadowOffset = CGSizeMake(0,0);
    //不透明度
    _signupView.layer.shadowOpacity = 0.5;
    //半径
    _signupView.layer.shadowRadius = 5.0;
    //注册按钮禁用
    _signupBtn.enabled = NO;
    _signupBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    //添加事件监听当输入框文本内容改变时，调用textChange:方法
    [_phoneTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_pwdTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_confirmPwdTextField addTarget:self action:@selector(textChange:) forControlEvents: UIControlEventEditingChanged ];
    [self setNavigationItem];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航样式
- (void)setNavigationItem {
    //设置导航栏标题
    self.navigationItem.title = @"会员注册";
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
    if (_phoneTextField.text.length != 0 && _pwdTextField.text.length != 0 && _confirmPwdTextField.text.length != 0) {
        //注册按钮启用
        _signupBtn.enabled = YES;
        _signupBtn.backgroundColor = UIColorFromRGB(66, 162, 233);
    } else {
        //注册按钮禁用
        _signupBtn.enabled = NO;
        _signupBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
        
    }
}
//键盘收回
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTextField || textField == _pwdTextField || textField == _confirmPwdTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - request 网络请求


- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
@end
