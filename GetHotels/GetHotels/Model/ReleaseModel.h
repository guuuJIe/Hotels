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
@property(nonatomic) NSInteger page;
@property(nonatomic) NSInteger state;

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
