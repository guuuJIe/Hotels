//
//  UserModel.m
//  GetHotels
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDict: (NSDictionary *)dict {
    self = [super init];
    if (self) {
        _grade = [Utilities nullAndNilCheck:dict[@"grade"] replaceBy:@"无"];
        _headImg = [Utilities nullAndNilCheck:dict[@"head_img"] replaceBy:@""];
        _userId = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];
        _cardId = [Utilities nullAndNilCheck:dict[@"id_card"] replaceBy:@"未设置"];
        _nickname = [Utilities nullAndNilCheck:dict[@"nick_name"] replaceBy:@"未设置"];
        _openid = [Utilities nullAndNilCheck:dict[@"openid"] replaceBy:@"0"];
        _password = [Utilities nullAndNilCheck:dict[@"password"] replaceBy:@""];
        _realname = [Utilities nullAndNilCheck:dict[@"real_name"] replaceBy:@"未设置"];
        _startTime = [dict[@"start_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"start_time"] integerValue];
        _startTimeStr = [dict[@"start_time_str"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"start_time_str"] integerValue];
        _state = [Utilities nullAndNilCheck:dict[@"state"] replaceBy:@"未设置"];
        _phone = [Utilities nullAndNilCheck:dict[@"tel"] replaceBy:@"未设置"];
        if ([dict[@"gender"] isKindOfClass:[NSNull class]]) {
            _gender = @"";
        } else {
            switch ([dict[@"gender"] integerValue]) {
                case 0:
                    _gender = @"男";
                    break;
                case 1:
                    _gender = @"女";
                    break;
                default:
                    _gender = @"未设置";
                    break;
            }
        }

    }
    return self;
}

@end
