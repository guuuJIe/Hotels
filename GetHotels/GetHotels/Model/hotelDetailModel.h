//
//  hotelDetailModel.h
//  GetHotels
//
//  Created by admin2017 on 2017/8/25.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotelDetailModel : NSObject
@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *city_id;
@property (strong,nonatomic) NSString *hotel_address;
@property (strong,nonatomic) NSString *hotel_hotel_img;
@property (strong,nonatomic) NSString *hotel_imgs;
@property (strong,nonatomic) NSString *hotel_name;
@property (strong,nonatomic) NSString *in_time;
@property (strong,nonatomic) NSString *out_time;
@property (strong,nonatomic) NSString *now_price;
@property (strong,nonatomic) NSString *room_img;
@property (strong,nonatomic) NSString *start_time;
@property (strong,nonatomic) NSString  *is_pet;
- (instancetype)initWithDictionary: (NSDictionary *)dict;



@end
