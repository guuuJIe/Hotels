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

        _Id = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"]integerValue];
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _startTime = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        _lowPrice = [[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""]integerValue];
        _highPrice = [[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""]integerValue];
        _aviationDemandDetail = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
        _time = [[Utilities nullAndNilCheck:dict[@"start_time"] replaceBy:@""]integerValue];
    }
    return self;
}

- (instancetype)initWithDictForRelease:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _startTime = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        _finalPrice = [[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""]integerValue];
        _aviationDemandDetail = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
        _time = [[Utilities nullAndNilCheck:dict[@"start_time"] replaceBy:@""]integerValue];
    }
    return self;
}

-(instancetype)initWithDictForHistroy:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _startTime = [Utilities nullAndNilCheck:dict[@"start_time_str"] replaceBy:@""];
        _finalPrice = [[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""]integerValue];
        _aviationDemandDetail = [Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
        _time = [[Utilities nullAndNilCheck:dict[@"start_time"] replaceBy:@""]integerValue];
    }
    return self;
}
-(instancetype)initWithDictForOffer:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _finalPrice = [[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""]integerValue];
        _cabin = [Utilities nullAndNilCheck:dict[@"aviation_cabin "] replaceBy:@""];
        _company = [Utilities nullAndNilCheck:dict[@"aviation_company"] replaceBy:@""];
        _inTime = [[Utilities nullAndNilCheck:dict[@"in_time_str"] replaceBy:@""]integerValue];
        _outTime = [[Utilities nullAndNilCheck:dict[@"out_time_str"] replaceBy:@""]integerValue];
        _time = [[Utilities nullAndNilCheck:dict[@"start_time"] replaceBy:@""]integerValue];
    }
    return self;
}
@end
