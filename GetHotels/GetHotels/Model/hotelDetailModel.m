//
//  hotelDetailModel.m
//  GetHotels
//
//  Created by admin2017 on 2017/8/25.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "hotelDetailModel.h"

@implementation hotelDetailModel
- (instancetype)initWithDictionary: (NSDictionary *)dict{
    self = [super init]; if (self) {
        _id =[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""];
       _hotel_address= [Utilities nullAndNilCheck:dict[@"hotel_address"] replaceBy:@""];
        _hotel_imgs= [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@""];
         _hotel_name= [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _now_price = [Utilities nullAndNilCheck:dict[@"now_price"] replaceBy:@""];
        _in_time = [Utilities nullAndNilCheck:dict[@"in_time"] replaceBy:@""];
        _out_time = [Utilities nullAndNilCheck:dict[@"out_time"] replaceBy:@""];
        _now_price = [Utilities nullAndNilCheck:dict[@"now_price"] replaceBy:@""];
        _room_img = [Utilities nullAndNilCheck:dict[@"room_img"] replaceBy:@""];
        _start_time = [Utilities nullAndNilCheck:dict[@"start_time"] replaceBy:@""];
        _longitude = [Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@""];
        _latitude = [Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@""];
        if([dict[@"is_pet"]isKindOfClass:[NSNull class]]){
            _is_pet=@"";
        }else{
            switch ([dict[@"is_pet"]integerValue]) {
                case 0:
                    _is_pet = @"不可携带宠物";
                    break;
                    case 1:
                    _is_pet = @"可携带宠物";
                    break;
                default:
                    _is_pet =@"";
                    break;
            }
        }

    }
     return self;
}
@end
