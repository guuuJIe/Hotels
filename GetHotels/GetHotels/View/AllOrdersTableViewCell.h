//
//  AllOrdersTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/21.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *hotelLocation;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *stayTime;
@property (weak, nonatomic) IBOutlet UILabel *leavelTime;

@end
