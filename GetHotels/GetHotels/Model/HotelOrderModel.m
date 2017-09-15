//
//  HotelOrderModel.m
//  GetHotels
//
//  Created by admin on 2017/9/13.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelOrderModel.h"

@implementation HotelOrderModel
- (instancetype) initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self){
        _hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"0"];
        _hotelAddress = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@"0"];
        _inTime = [Utilities nullAndNilCheck:dict[@"final_in_time_str"] replaceBy:@"0"];
        _outTime = [Utilities nullAndNilCheck:dict[@"final_out_time_str"] replaceBy:@"0"];
        _state = [[Utilities nullAndNilCheck:dict[@"state"] replaceBy:@"0"]integerValue];
        _hotelID = [[Utilities nullAndNilCheck:dict[@"hotel_id"] replaceBy:@"0"]integerValue];
    }
    return self;
}

@end
