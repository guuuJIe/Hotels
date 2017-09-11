//
//  AviationModel.m
//  GetHotels
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AviationModel.h"

@implementation AviationModel
- (instancetype)initWithDictionary: (NSDictionary *)dict{
    self = [super init]; if (self) {
        _openid =[Utilities nullAndNilCheck:dict[@"openid"] replaceBy:@"0"];
        _aviation_demand_detail= [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
        _aviation_demand_title= [Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@""];
        _set_low_time_str= [Utilities nullAndNilCheck:dict[@"set_low_time_str"] replaceBy:@""];
        _set_high_time_str = [Utilities nullAndNilCheck:dict[@"set_high_time_str"] replaceBy:@""];
        _set_hour = [Utilities nullAndNilCheck:dict[@"set_hour"] replaceBy:@""];
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _high_price = [Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];
        _low_price = [Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""];
         _back_low_time_str= [Utilities nullAndNilCheck:dict[@"back_low_time_str"] replaceBy:@""];
         _back_high_time_str = [Utilities nullAndNilCheck:dict[@"back_high_time_str"] replaceBy:@""];
         _is_back = [[Utilities nullAndNilCheck:dict[@"is_back"] replaceBy:@"" ]integerValue];
         _people_number = [[Utilities nullAndNilCheck:dict[@"people_number"] replaceBy:@""]integerValue];
         _child_number = [[Utilities nullAndNilCheck:dict[@"child_number"] replaceBy:@""]integerValue];
         _weight = [Utilities nullAndNilCheck:dict[@"weight"] replaceBy:@""];
           }
    return self;
}

@end
