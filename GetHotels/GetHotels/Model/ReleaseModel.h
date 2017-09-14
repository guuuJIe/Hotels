//
//  ReleaseModel.h
//  GetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseModel : NSObject
@property (nonatomic) NSInteger Id;
@property(strong,nonatomic) NSString *departure;   //出发地
@property(strong,nonatomic)NSString *destination;  //目的地
@property(strong,nonatomic)NSString *startTime;    //发布日期
@property(nonatomic) NSInteger lowPrice;  //最低价
@property(nonatomic) NSInteger highPrice;  //最高价
@property(strong,nonatomic) NSString *aviationDemandDetail;  //航空需求
@property(nonatomic) NSInteger finalPrice;  //最终价
@property(nonatomic) NSInteger time;    //起飞日期
@property(strong,nonatomic) NSString *cabin;   //客舱
@property(strong,nonatomic) NSString *company;   //航空公司
@property(nonatomic) NSInteger inTime;
@property(nonatomic) NSInteger outTime;


- (instancetype)initWithDict: (NSDictionary *)dict;
- (instancetype)initWithDictForRelease:(NSDictionary *)dict;
-(instancetype)initWithDictForHistroy:(NSDictionary *)dict;
-(instancetype)initWithDictForOffer:(NSDictionary *)dict;
@end
