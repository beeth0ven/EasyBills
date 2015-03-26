//
//  ToolBarCMCDTVC.m
//  EasyBills
//
//  Created by luojie on 3/25/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ToolBarCMCDTVC.h"
#import "EasyBillsCursorButton.h"

@interface ToolBarCMCDTVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cursorBarButtonItem;

@end

@implementation ToolBarCMCDTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCursorBarButtonItem];

}

- (void)setUpCursorBarButtonItem {
    EasyBillsCursorButton *cursorButton = [EasyBillsCursorButton
                                           cursorButtonSetOn:self.mapView.showsUserLocation];
    
    [cursorButton addTarget:self
                     action:@selector(changeShowLocationStates:)
           forControlEvents:UIControlEventTouchUpInside];
    self.cursorBarButtonItem.customView = cursorButton;
}

- (IBAction)changeShowLocationStates:(EasyBillsCursorButton *)sender {
    
    if (self.mapView.showsUserLocation) {
        //Determ Whether Change show to not show.
        MKMapPoint currentPoint =  MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
        MKMapPoint regionCenterPoint = MKMapPointForCoordinate(self.mapView.region.center);
        CLLocationDistance distence = MKMetersBetweenMapPoints(currentPoint, regionCenterPoint);

        if (distence > 20) {
            //Should show location;
            [self restMapRegion];
            return;
        }
        
    }else{
        //Turn it on,Show location.
        [self restMapRegion];
    }
    
    self.mapView.showsUserLocation = !self.mapView.showsUserLocation;
    sender.on = self.mapView.showsUserLocation;

}

- (void)restMapRegion {
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.location.coordinate;
    mapRegion.span.latitudeDelta  = self.mapView.region.span.latitudeDelta;
    mapRegion.span.longitudeDelta = self.mapView.region.span.longitudeDelta;
    [self.mapView setRegion:mapRegion animated:YES];
}


- (IBAction)changeMapType:(UISegmentedControl *)sender {
    self.mapView.mapType = sender.selectedSegmentIndex;
}


@end
