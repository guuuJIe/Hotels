//
//  AviationModel.h
//  GetHotels
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AviationModel : NSObject
@property (strong,nonatomic) NSString *openid;//用户openid
@property (strong,nonatomic) NSString *aviation_demand_detail;//详情
@property (strong,nonatomic) NSString *aviation_demand_title;//标题
@property (strong,nonatomic) NSString *set_low_time_str;//最早时间
@property (strong,nonatomic) NSString *set_high_time_str;//最晚时间
@property (strong,nonatomic) NSString *set_hour;//时间段
@property (strong,nonatomic) NSString *departure;//出发地
@property (strong,nonatomic) NSString *destination;//目的地
@property (strong,nonatomic) NSString *high_price;//最高价
@property (strong,nonatomic) NSString *low_price;//最低价
@property (strong,nonatomic) NSString *back_low_time_str;//返程最早时间
@property (strong,nonatomic) NSString *back_high_time_str;//返程最晚时间
@property (nonatomic) NSInteger is_back;//是否返程
@property (nonatomic) NSInteger people_number;//乘机人数(大人)
@property (nonatomic) NSInteger child_number;//乘机人数(小孩)
@property (strong,nonatomic) NSString *weight;//随身物品净重




- (instancetype)initWithDictionary: (NSDictionary *)dict;
@end
