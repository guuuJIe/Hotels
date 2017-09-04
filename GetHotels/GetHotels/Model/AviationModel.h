//
//  AviationModel.h
//  GetHotels
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AviationModel : NSObject
@property (strong,nonatomic) NSString *openid;
@property (strong,nonatomic) NSString *aviation_demand_detail;
@property (strong,nonatomic) NSString *aviation_demand_title;
@property (strong,nonatomic) NSString *set_low_time_str;
@property (strong,nonatomic) NSString *set_high_time_str;
@property (strong,nonatomic) NSString *set_hour;
@property (strong,nonatomic) NSString *departure;
@property (strong,nonatomic) NSString *destination;
@property (strong,nonatomic) NSString *high_price;
@property (strong,nonatomic) NSString *low_price;
@property (strong,nonatomic) NSString *back_low_time_str;
@property (strong,nonatomic) NSString *back_high_time_str;
@property (strong,nonatomic) NSString *is_back;
@property (strong,nonatomic) NSString *people_number;
@property (strong,nonatomic) NSString *child_number;
@property (strong,nonatomic) NSString *weight;




- (instancetype)initWithDictionary: (NSDictionary *)dict;
@end
