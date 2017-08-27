//
//  HotelListModel.h
//  GetHotels
//
//  Created by admin on 2017/8/27.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelListModel : NSObject
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *imgUrl;
@property (strong,nonatomic) NSString *latitude;
@property (strong,nonatomic) NSString *longitude;   //经度
@property (nonatomic) NSInteger price;
@property (nonatomic) NSInteger id;

-(id)initWithDict:(NSDictionary *)dict;
@end
