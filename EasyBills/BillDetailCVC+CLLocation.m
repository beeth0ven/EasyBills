//
//  BillDetailCVC+CLLocation.m
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+CLLocation.h"
#import "Bill+MKAnnotation.h"
#import "UIAlertView+Extension.h"

@implementation BillDetailCVC (CLLocation)

#pragma mark - Core Location Method

//Request Current CLLocationManager Authorization Status
- (void)requestGetCurentLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:{
                [UIAlertView displayAlertWithTitle:[PubicVariable kCLAuthorizationStatusDeniedTitle]
                                    message:[PubicVariable kCLAuthorizationStatusDeniedMessage]];
                self.bill.locationIsOn = [NSNumber numberWithBool:NO];

                break;
            }
            case kCLAuthorizationStatusNotDetermined:{
                [self.locationManager requestWhenInUseAuthorization];
                break;
            }
            case kCLAuthorizationStatusRestricted:{
                [UIAlertView displayAlertWithTitle:[PubicVariable kCLAuthorizationStatusRestrictedTitle]
                                           message:[PubicVariable kCLAuthorizationStatusRestrictedMessage]];
                self.bill.locationIsOn = [NSNumber numberWithBool:NO];

                break;
            }
            default:{
                [self getCurentLocation];
                break;
            }
        }
        
        
    }
    [self updateCellWithIdentifier:@"locationCell"];

}


//Authorization Status Changed
- (void)        locationManager:(CLLocationManager *)manager
   didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    NSLog(@"The authorization status of location services is changed to: ");
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:{
            NSLog(@"Denied");
            self.bill.locationIsOn = [NSNumber numberWithBool:NO];
            break;
        }
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"Not determined");
            break;
        }case kCLAuthorizationStatusRestricted:{
            NSLog(@"Restricted");
            self.bill.locationIsOn = [NSNumber numberWithBool:NO];
            break;
        }
        default:{
            NSLog(@"Default");
            [self getCurentLocation];
            break;
        }
    }
    
}


-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    CLLocation *curentLocation = locations.lastObject;
    self.bill.locationIsOn = [NSNumber numberWithBool:YES];
    [self.bill setCoordinate:curentLocation.coordinate];
    [self.locationManager stopUpdatingLocation];
    [self.bill upadatePlacemark];
    [self updateCellWithIdentifier:@"locationCell"];
    [self showMapCell];
    
}


-(void) locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{

    [self.locationManager stopUpdatingLocation];
    self.bill.locationIsOn = [NSNumber numberWithBool:NO];
    [self updateCellWithIdentifier:@"locationCell"];
    //    self.locationSwitch.on = NO;
    //    [self locationIsOnStateChanged:self.locationSwitch];
    
}

- (void)getCurentLocation{
    [self.locationManager startUpdatingLocation];
    
}



@end
