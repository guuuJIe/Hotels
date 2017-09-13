//
//  ReleaseModel.h
//  GetHotels
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseModel : NSObject
@property (strong,nonatomic) NSString *openid;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger state;
@property (nonatomic) NSInteger Id;
@property(strong,nonatomic) NSString *departure;   //出发地
@property(strong,nonatomic)NSString *destination;  //目的地
@property(strong,nonatomic)NSString *startTime;    //发布日期
@property(nonatomic) NSInteger lowPrice;  //最低价
@property(nonatomic) NSInteger highPrice;  //最高价
@property(strong,nonatomic) NSString *aviationDemandDetail;  //航空需求


- (instancetype)initWithDict: (NSDictionary *)dict;
@end
