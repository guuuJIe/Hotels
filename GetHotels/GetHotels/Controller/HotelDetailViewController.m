//
//  HotelDetailViewController.m
//  GetHotels
//
//  Created by admin2017 on 2017/8/21.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelDetailViewController.h"

@interface HotelDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *DetailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *nameToView;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@property (weak, nonatomic) IBOutlet UIView *adressToView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
- (IBAction)dateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextDateBtn;
- (IBAction)nextDateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *nextDayLabel;
@property (weak, nonatomic) IBOutlet UIView *facilitiesView;


@end

@implementation HotelDetailViewController

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

- (IBAction)dateBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)dateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)nextDateActionBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
