//
//  PurchaseTableViewController.h
//  GetHotels
//
//  Created by mac on 2017/8/28.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hotelDetailModel.h"
#import "ReleaseModel.h"

@interface PurchaseTableViewController : UITableViewController

//创建容器去接收别的页面传来的数据
@property (strong,nonatomic) hotelDetailModel *hotelModel;
@property (strong,nonatomic) ReleaseModel *releaseModel;
@property (nonatomic) NSInteger tag;
@property (nonatomic)NSInteger days;
@end
