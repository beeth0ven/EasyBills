//
//  KindePickerCollectionViewCell.h
//  EasyBills
//
//  Created by 罗 杰 on 11/14/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill+Create.h"

@interface KindePickerCVCell : UICollectionViewCell<UIPickerViewDataSource, UIPickerViewDelegate>

extern NSString *const kSetBillKindNotification;
extern NSString *const kSetBillKindKey;

@property (strong ,nonatomic) Bill *bill;

@property (weak, nonatomic) IBOutlet UIPickerView *kindPickerView;

@end
