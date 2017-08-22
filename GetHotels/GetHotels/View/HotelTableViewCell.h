//
//  HotelTableViewCell.h
//  GetHotels
//
//  Created by admin on 2017/8/22.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hotelImg;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelLocLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelPriceLabel;

@end
