//
//  HotelListModel.m
//  GetHotels
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelListModel.h"

@implementation HotelListModel
 
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        _address = [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];
         _name = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _imgUrl = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
        _latitude = [Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@"0"];
        _longitude = [Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@"0"];
        _price = [[Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"0"] integerValue];
        _id = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"] integerValue];
        
    }
    return self;
}

@end
