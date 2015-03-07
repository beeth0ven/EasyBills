//
//  BillTableViewCell.h
//  我的账本
//
//  Created by 罗 杰 on 9/22/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTVCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;

@property (nonatomic) float grade;
@property (strong ,nonatomic) UIColor * barColor;


@end
