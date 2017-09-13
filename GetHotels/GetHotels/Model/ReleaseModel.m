//
//  ReleaseModel.m
//  GetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ReleaseModel.h"

@implementation ReleaseModel
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        _openid = [Utilities nullAndNilCheck:dict[@"openid"] replaceBy:@"0"];
        _page = [[Utilities nullAndNilCheck:dict[@"page"] replaceBy:@"0"]integerValue];
        _state = [[Utilities nullAndNilCheck:dict[@"state"] replaceBy:@"0"]integerValue];
        _Id = [[Utilities nullAndNilCheck:dict[@"Id"] replaceBy:@"0"]integerValue];
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _startTime = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        _lowPrice = [[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""]integerValue];
        _highPrice = [[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""]integerValue];
        _aviationDemandDetail = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
    }
    return self;
}

@end
