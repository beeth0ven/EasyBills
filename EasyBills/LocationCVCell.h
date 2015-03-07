//
//  LocationCollectionViewCell.h
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"


extern NSString *const kSetBillLocationIsOnNotification;
extern NSString *const kSetBillLocationIsKey;


@interface LocationCVCell : UICollectionViewCell

@property (strong ,nonatomic) Bill *bill;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;


@end
