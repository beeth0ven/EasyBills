//
//  DateTableViewCell.m
//  我的账本
//
//  Created by 罗 杰 on 9/10/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "DateTableViewCell.h"
#import "PubicVariable.h"

@interface DateTableViewCell ()

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation DateTableViewCell


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
    [super awakeFromNib];
    // Initialization code
    self.label.text = @"日期";
    self.textField.text = [PubicVariable stringFromDate:self.bill.date];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.datePicker.date = self.bill.date;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self
                        action:@selector(datePickerChanged:)
              forControlEvents:UIControlEventValueChanged];
    self.textField.inputView = _datePicker;
    
}

-(IBAction)datePickerChanged:(id)sender
{
    self.bill.date= [self.datePicker date];
    self.textField.text = [PubicVariable stringFromDate:self.bill.date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
