//
//  DateTableViewCell.h
//  我的账本
//
//  Created by 罗 杰 on 9/10/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moneyTableViewCell.h"
#import "Bill+Create.h"

@interface DateTableViewCell : MoneyTableViewCell

@property (strong ,nonatomic) Bill *bill;


@end
