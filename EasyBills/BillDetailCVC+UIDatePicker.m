//
//  BillDetailCVC+DatePicker.m
//  EasyBills
//
//  Created by luojie on 3/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+UIDatePicker.h"

@implementation BillDetailCVC (UIDatePicker)

- (IBAction)datePickerChanged:(UIDatePicker *)sender {
    [self.bill setDateAttributes: sender.date];
}

@end
