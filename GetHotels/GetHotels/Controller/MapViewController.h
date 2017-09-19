//
//  MapViewController.h
//  GetHotels
//
//  Created by admin2017 on 2017/9/19.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hotelDetailModel.h"
@interface MapViewController : UIViewController
@property(strong,nonatomic) hotelDetailModel*mapModel;
@property(strong,nonatomic)NSString *latitude;
@property(strong,nonatomic)NSString *longitude;
@end
