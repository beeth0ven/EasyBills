//
//  KindCoreDataTableViewController.h
//  EasyBills
//
//  Created by 罗 杰 on 10/10/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "PNChart.h"
#import "PNCircleChart.h"
#import "KindViewController.h"

@interface KindCDTVC : CoreDataTableViewController
<UIPopoverPresentationControllerDelegate,
UIAdaptivePresentationControllerDelegate,
PNChartDelegate>

@property (strong, nonatomic) KindViewController *kindViewController;


@end
