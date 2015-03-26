//
//  BillDetailCVC+MKMapView.h
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC.h"
#import <MapKit/MapKit.h>

@interface BillDetailCVC (MKMapView)<MKMapViewDelegate>

- (void)reloadDataInMapView:(MKMapView *)mapView;

    
    
@end
