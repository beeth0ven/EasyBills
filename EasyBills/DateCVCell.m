//
//  DateCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "DateCVCell.h"
#import "PubicVariable+FetchRequest.h"

@implementation DateCVCell


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
    NSDate *date = bill.date;
    self.detailLabel.text = [PubicVariable stringFromDate:date];
}

-(void) handleSetBillDateNotification:(NSNotification *)paraNotification
{
    NSDate *date = paraNotification.userInfo[kSetBillDateKey];
    self.detailLabel.text = [PubicVariable stringFromDate:date];
}


-(void)awakeFromNib
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(handleSetBillDateNotification:)
                   name:kSetBillDateNotification
                 object:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
