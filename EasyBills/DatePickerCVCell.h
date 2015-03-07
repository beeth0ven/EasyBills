//
//  DatePickerCollectionViewCell.h
//  EasyBills
//
//  Created by 罗 杰 on 11/14/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

extern NSString *const kSetBillDateNotification;
extern NSString *const kSetBillDateKey;

@interface DatePickerCVCell : UICollectionViewCell

@property (strong ,nonatomic) Bill *bill;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
