//
//  HotelOrderModel.h
//  GetHotels
//
//  Created by admin on 2017/9/13.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelOrderModel : NSObject
@property (strong, nonatomic) NSString *hotelName;
@property (strong, nonatomic) NSString *hotelAddress;
@property (strong, nonatomic) NSString *inTime;
@property (strong, nonatomic) NSString *outTime;
@property (nonatomic) NSInteger hotelID;
@property (nonatomic) NSInteger state;

- (instancetype) initWithDict: (NSDictionary *)dict;
@end
