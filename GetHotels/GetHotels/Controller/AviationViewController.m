//
//  AviationViewController.m
//  GetHotels
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AviationViewController.h"

@interface AviationViewController ()<UITextFieldDelegate>

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






@end

@implementation AviationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}
- (IBAction)nextDateActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)departureCityActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)targetCitiesActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)releaseActionButton:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
}
@end
