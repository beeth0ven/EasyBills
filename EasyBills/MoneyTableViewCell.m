//
//  moneyTableViewCell.m
//  我的账本
//
//  Created by 罗 杰 on 9/10/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "MoneyTableViewCell.h"
#import "PNChartDelegate.h"
#import "PNChart.h"


@interface MoneyTableViewCell()



@end


@implementation MoneyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, 34, 21)];
    self.label.text = @"金额";
    self.label.font = [UIFont systemFontOfSize:17.0];
    
    self.textField =[[UITextField alloc]initWithFrame:CGRectMake(57, 7, 228, 30)];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.text = [NSString stringWithFormat:@"$ %f",self.bill.money.floatValue];
    self.textField.placeholder = @"0";
    self.textField.textColor = PNFreshGreen;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.delegate = self;
    
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.bill.money = [NSNumber numberWithFloat: textField.text.floatValue];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
