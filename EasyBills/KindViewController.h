//
//  KindViewController.h
//  EasyBills
//
//  Created by luojie on 5/15/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import <CoreData/CoreData.h>
#import "UIViewController+Extension.h"





@interface KindViewController : UIViewController
<UIPopoverPresentationControllerDelegate,
UIAdaptivePresentationControllerDelegate,
PNChartDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly)  NSInteger dateMode;
@property (nonatomic, readonly)  NSInteger isIncomeMode;

@property (nonatomic) BOOL shouldRelaodData;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic, readonly) UIView *viewForHoldingRevealPanGesture;

@end
