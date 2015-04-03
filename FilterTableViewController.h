//
//  FilterTableViewController.h
//  PopToFilter
//
//  Created by luojie on 3/29/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#define EBBlue          [UIColor colorWithRed:95.0 / 255.0 green:200.0 / 255.0 blue:220.0 / 255.0 alpha:1.0f]
#define EBBackGround    [UIColor colorWithRed:137.0 / 255.0 green:142.0 / 255.0 blue:145.0 / 255.0 alpha:1.0f]

#import <UIKit/UIKit.h>

@interface FilterTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *filters;


@end
