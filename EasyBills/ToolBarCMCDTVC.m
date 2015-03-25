//
//  ToolBarCMCDTVC.m
//  EasyBills
//
//  Created by luojie on 3/25/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ToolBarCMCDTVC.h"

@implementation ToolBarCMCDTVC


- (IBAction)changeShowLocationStates:(UIBarButtonItem *)sender {
    self.mapView.showsUserLocation = !self.mapView.showsUserLocation;
    if (self.mapView.showsUserLocation) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.mapView.userLocation.location.coordinate;
        mapRegion.span.latitudeDelta  = self.mapView.region.span.latitudeDelta;
        mapRegion.span.longitudeDelta = self.mapView.region.span.longitudeDelta;
        [self.mapView setRegion:mapRegion animated:YES];
    }
}


- (IBAction)changeMapType:(UISegmentedControl *)sender {
    self.mapView.mapType = sender.selectedSegmentIndex;
}


@end
