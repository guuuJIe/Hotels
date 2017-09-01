//
//  AccountSettingViewController.m
//  GetHotels
//
//  Created by mac on 2017/8/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AccountSettingViewController.h"

@interface AccountSettingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)exitAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //把状态栏变成白色
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //调用设置导航样式
    [self setNavigationItem];
    
    //用户不能启用（不能点击确认按钮）
    _confirmBtn.enabled = NO;
    //_confirmBtn.backgroundColor = UIColorFromRGB(200, 200, 200);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置导航样式
- (void)setNavigationItem {
    //设置导航栏标题
    self.navigationItem.title = @"账户设置";
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

//当textfield结束编辑的时候调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //当旧密码、新密码和确认密码都输入了之后，按钮才能被点击
    if (textField == _oldPwdTextField || textField == _nowPwdTextField || textField == _confirmPwdTextField) {
        if (_oldPwdTextField.text.length != 0 && _nowPwdTextField.text.length != 0 && _confirmPwdTextField.text.length != 0) {
            //确认按钮启用
            _confirmBtn.enabled = YES;
            _confirmBtn.backgroundColor = UIColorFromRGB(66, 162, 233);
        }
    }
}

//按键盘return收回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _oldPwdTextField || textField == _nowPwdTextField || textField == _confirmPwdTextField)  {
        [textField resignFirstResponder];
    }
    return YES;
}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//确定按钮事件
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_nowPwdTextField.text.length < 6 || _nowPwdTextField.text.length > 18){
        [Utilities
         popUpAlertViewWithMsg:@"您输入的密码必须在6-18之间" andTitle:@"温馨提示" onView:self];
        //清空密码，方便再次输入
        _nowPwdTextField.text = @"";
        
        return;
    }

    if ([_nowPwdTextField.text isEqualToString:_confirmPwdTextField.text]) {
        //创建一个密码修改成功提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码修改成功，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        //创建确定按钮
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //注册成功后返回上一页
            //[self performSegueWithIdentifier:@"returnLogin" sender:self];
            [self dismissViewControllerAnimated:YES completion:nil];
            //清空用户名、密码和确认密码
            _oldPwdTextField.text = @"";
            _nowPwdTextField.text = @"";
            _confirmPwdTextField.text = @"";
            
        }];
        //创建取消按钮
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionA];
        [alert addAction:actionB];
        //把弹窗加到视图上
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [Utilities popUpAlertViewWithMsg:@"密码输入不一致，请重新输入" andTitle:@"温馨提示" onView:self];
        //清空新密码和确认密码
        _nowPwdTextField.text = @"";
        _confirmPwdTextField.text = @"";
    }

}


//退出登录按钮事件
- (IBAction)exitAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用确定退出登录返回登录页
        [self exit];
        
    }];
    UIAlertAction *actionB= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//确定退出登录返回登录页
- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
