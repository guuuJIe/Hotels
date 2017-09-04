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
    }
    return self;
}

@end
