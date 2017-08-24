//
//  UserModel.h
//  GetHotels
//
//  Created by mac on 2017/8/24.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong, nonatomic) NSString *gender;         //性别
@property (strong, nonatomic) NSString *grade;          //等级
@property (strong, nonatomic) NSString *headImg;        //用户头像
@property (strong, nonatomic) NSString *userId;         //用户id
@property (strong, nonatomic) NSString *cardId;         //身份证号
@property (strong, nonatomic) NSString *nickname;       //昵称
@property (strong, nonatomic) NSString *openid;         //
@property (strong, nonatomic) NSString *password;       //密码
@property (strong, nonatomic) NSString *realname;       //真实姓名
@property (strong, nonatomic) NSString *startTime;      //
@property (strong, nonatomic) NSString *startTimeStr;   //
@property (strong, nonatomic) NSString *state;          //状态
@property (strong, nonatomic) NSString *phone;          //手机号

- (instancetype)initWithDict: (NSDictionary *)dict;

@end
