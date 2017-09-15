//
//  OfferCollectionViewCell.h
//  GetHotels
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TermCellDelegate<NSObject>
-(void)chooseItem:(UIButton *)button;
@end
@interface OfferCollectionViewCell : UICollectionViewCell
@property (assign, nonatomic) id<TermCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *departure;
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *aviationCabin;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *aviationCompany;

@end
