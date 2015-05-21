//
//  MyCollectionViewController.h
//  EasyBills
//
//  Created by 罗 杰 on 11/10/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "Kind+Create.h"
#import "Bill+Create.h"
#import "ImageCollectionViewCell.h"
#import <CoreData/CoreData.h>
#import "Bill+Create.h"
#import "PubicVariable.h"
#import "PubicVariable+FetchRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "Kind+Create.h"
#import "DefaultStyleController.h"
#import "UIImage+Extension.h"


@interface BillDetailCVC : UICollectionViewController


@property (strong ,nonatomic) Bill *bill;
@property (nonatomic) BOOL isIncome;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//For Inner Use

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL shouldShowMapCell;

// The Current Input Cell IndexPath
@property (strong ,nonatomic) NSIndexPath *inputCellIndexPath;

@property (strong ,nonatomic) UITextField *activeField;
@property (strong, nonatomic) UITextField *moneyTextField;
@property (strong, nonatomic) UITextField *noteTextField;



@property (strong, nonatomic) NSFetchedResultsController *kindFRC;

- (void)updateCellWithIdentifier:(NSString *)identifier;
- (void)updateMapViewCellWithoutLocation;
- (void)showMapCell;

- (void)endEditing;

-(void)removeDataAndCellAtIndexPath:(NSIndexPath *)indexPath;


@end
