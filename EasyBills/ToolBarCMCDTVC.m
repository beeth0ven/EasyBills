//
//  ToolBarCMCDTVC.m
//  EasyBills
//
//  Created by luojie on 3/25/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ToolBarCMCDTVC.h"
#import "EasyBillsCursorButton.h"
#import "UIAlertView+Extension.h"

@interface ToolBarCMCDTVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cursorBarButtonItem;
@property (strong, nonatomic)  EasyBillsCursorButton *cursorButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmented;

@property (nonatomic) BOOL showsUserLocation;
@property (nonatomic) BOOL shouldRestMapRegionToUserLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ToolBarCMCDTVC

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCursorBarButtonItem];
    [self configMapTypeSegmented];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.mapView.mapType = !self.mapTypeSegmented.selectedSegmentIndex;
    self.mapView.mapType = self.mapTypeSegmented.selectedSegmentIndex;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
////    NSLog(@"%@",[self.mapTypeSegmented titleForSegmentAtIndex:self.mapTypeSegmented.selectedSegmentIndex]);
//
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
////    [self configMapTypeSegmented];
////    [self.mapTypeSegmented setNeedsDisplay];
//    
//}


#pragma mark - MKMapView Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.showsUserLocation = YES;
    self.cursorBarButtonItem.customView = self.cursorButton;
    if (self.shouldRestMapRegionToUserLocation) {
        [self restMapRegion];
        self.shouldRestMapRegionToUserLocation = NO;
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    self.showsUserLocation = NO;
    self.cursorBarButtonItem.customView = self.cursorButton;
    [UIAlertView displayAlertWithTitle:@"定位失败"
                               message:[error localizedDescription]];

}

#pragma mark - CLLocation authorization Method


- (void)requestGetCurentLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:{
                [UIAlertView displayAlertWithTitle:kCLAuthorizationStatusDeniedTitle
                                           message:kCLAuthorizationStatusDeniedMessage];
                self.showsUserLocation = NO;
                
                break;
            }
            case kCLAuthorizationStatusNotDetermined:{
                [self.locationManager requestWhenInUseAuthorization];
                break;
            }
            case kCLAuthorizationStatusRestricted:{
                [UIAlertView displayAlertWithTitle:kCLAuthorizationStatusRestrictedTitle
                                           message:kCLAuthorizationStatusRestrictedMessage];
                self.showsUserLocation = NO;
                
                break;
            }
            default:{
                self.showsUserLocation = YES;
                break;
            }
        }
        
        
    }
    
}


- (void)        locationManager:(CLLocationManager *)manager
   didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    NSLog(@"The authorization status of location services is changed to: ");
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:{
            NSLog(@"Denied");
            self.showsUserLocation = NO;
            break;
        }
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"Not determined");
            break;
        }case kCLAuthorizationStatusRestricted:{
            NSLog(@"Restricted");
            self.showsUserLocation = NO;
            break;
        }
        default:{
            self.showsUserLocation = YES;
            break;
        }
    }
    
}


#pragma mark - Some Method

- (void)setUpCursorBarButtonItem {
//    if (self.showsUserLocation) {
//        [self requestGetCurentLocation];
//    }else{
//        self.mapView.showsUserLocation = NO;
//    }
    self.cursorButton = [EasyBillsCursorButton
                         cursorButtonSetOn:self.showsUserLocation];
    
    [self.cursorButton addTarget:self
                          action:@selector(changeShowLocationStates:)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.cursorBarButtonItem.customView = self.cursorButton;
}

- (void)configMapTypeSegmented {
    [self.mapTypeSegmented setTitle:@"标准" forSegmentAtIndex:0];
    [self.mapTypeSegmented setTitle:@"卫星" forSegmentAtIndex:1];
    
}

- (IBAction)changeShowLocationStates:(EasyBillsCursorButton *)sender {
    
    if (self.showsUserLocation) {
        //Determ Whether Change show to not show.
        MKMapPoint currentPoint =  MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
        MKMapPoint regionCenterPoint = MKMapPointForCoordinate(self.mapView.region.center);
        CLLocationDistance distence = MKMetersBetweenMapPoints(currentPoint, regionCenterPoint);

        if (distence > 20) {
            //Should show location;
            [self restMapRegion];
            return;
        }
        
        self.showsUserLocation = NO;
    }else{
        //Turn it on,Show location.
        [self requestGetCurentLocation];
    }
    

}

- (void)restMapRegion {
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

#pragma mark - Properties Setter And Getter Method
//- (BOOL)showsUserLocation {
//    NSNumber *showsUserLocationNum =
//    [[NSUserDefaults standardUserDefaults]
//     objectForKey:@"kToolBarCMCDTVCShowsUserLocation"];
//    return showsUserLocationNum.boolValue;
//}

- (void)setShowsUserLocation:(BOOL)showsUserLocation {
    
    if (_showsUserLocation != showsUserLocation) {
        self.mapView.showsUserLocation = showsUserLocation;
        self.cursorButton.on = showsUserLocation;
        if (showsUserLocation) self.cursorBarButtonItem.customView = self.activityIndicatorView;
        _showsUserLocation = showsUserLocation;
        if (showsUserLocation)
            self.shouldRestMapRegionToUserLocation = YES;
        
    }
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           22,
                                                           44)];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_activityIndicatorView startAnimating];
    }
    return _activityIndicatorView;
}

@end
