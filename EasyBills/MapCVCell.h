//
//  MapCollectionViewCell.h
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
#import <MapKit/MapKit.h>
#import "LocationCVCell.h"

@interface MapCVCell : UICollectionViewCell <MKMapViewDelegate>

@property (strong ,nonatomic) Bill *bill;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
