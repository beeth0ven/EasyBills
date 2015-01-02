//
//  GetMoneyTableViewController.h
//  我的账本
//
//  Created by 罗 杰 on 14-9-7.
//  Copyright (c) 2014年 罗 杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "Kind+Create.h"
#import "Bill+Create.h"

@interface GetMoneyTableViewController : UITableViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate>
/*
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
*/
@property (strong ,nonatomic) Bill *bill;
@property (nonatomic) BOOL isIncome;
@end
