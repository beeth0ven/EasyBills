//
//  ViewController.h
//  EasyBills
//
//  Created by 罗 杰 on 10/1/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "PubicVariable+FetchRequest.h"
#import "DefaultStyleController.h"

@interface ViewController : UIViewController<PNChartDelegate>



@property (nonatomic) PNBarChart * barChart;

@end