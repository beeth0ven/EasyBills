//
//  DatePickerCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/14/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "DatePickerCVCell.h"
#import "PubicVariable+FetchRequest.h"
#import "Bill+Create.h"

NSString *const kSetBillDateNotification = @"SetBillDateNotification";
NSString *const kSetBillDateKey = @"SetBillDateKey";


@implementation DatePickerCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setBill:(Bill *)bill
{
    _bill = bill;
    self.datePicker.date = self.bill.date;
}

- (IBAction)datePickerChanged:(UIDatePicker *)sender {
    
    NSNotification *notification =
    [NSNotification
     notificationWithName:kSetBillDateNotification
     object:self
     userInfo:@{kSetBillDateKey : sender.date}];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.bill setDateAttributes: sender.date];
    NSLog(@"date: %@",[PubicVariable stringFromDate:self.bill.date]);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
