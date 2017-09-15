//
//  OfferCollectionViewCell.m
//  GetHotels
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "OfferCollectionViewCell.h"
#import "PurchaseTableViewController.h"
@implementation OfferCollectionViewCell

- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
    PurchaseTableViewController *purchaseVS = [Utilities getStoryboardInstance:@"BookHotels" byIdentity:@"purchaseNavi"];
    
}
@end
