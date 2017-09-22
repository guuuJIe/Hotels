//
//  UseableOrderTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UseableOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *hotelLocation;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *stayTime;
@property (weak, nonatomic) IBOutlet UILabel *leavelTime;
@end
