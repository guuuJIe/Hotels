//
//  PurchaseTableViewController.h
//  GetHotels
//
//  Created by mac on 2017/8/28.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hotelDetailModel.h"

@interface PurchaseTableViewController : UITableViewController

//创建一个容器去接受别的页面传来的数据
@property (strong,nonatomic) hotelDetailModel *hotelModel;

@end
