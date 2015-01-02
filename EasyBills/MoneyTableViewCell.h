//
//  moneyTableViewCell.h
//  我的账本
//
//  Created by 罗 杰 on 9/10/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill+Create.h"

@interface MoneyTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong ,nonatomic) UILabel *label;
@property (strong ,nonatomic) UITextField *textField;

@property (strong ,nonatomic) Bill *bill;

@end
