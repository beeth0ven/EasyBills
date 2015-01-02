//
//  NoteTableViewCell.h
//  我的账本
//
//  Created by 罗 杰 on 9/10/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFTextView.h"
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "Bill+Create.h"

@interface NoteTableViewCell : UITableViewCell <UITextViewDelegate>

@property (strong ,nonatomic) AFTextView *afTextView;

@property (strong ,nonatomic) Bill *bill;


@end
