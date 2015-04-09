//
//  BillDetailCVC+CLLocation.m
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+CLLocation.h"
#import "Bill+MKAnnotation.h"

@implementation BillDetailCVC (CLLocation)

#pragma mark - Core Location Method

//Request Current CLLocationManager Authorization Status
- (void)requestGetCurentLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:{
                [self displayAlertWithTitle:@"访问拒绝"
                                    message:@"应用程序没有权利访问定位服务！"];
                break;
            }
            case kCLAuthorizationStatusNotDetermined:{
                [self.locationManager requestWhenInUseAuthorization];
                break;
            }case kCLAuthorizationStatusRestricted:{
                [self displayAlertWithTitle:@"访问受限"
                                    message:@"应用程访问定位服务受到限制！"];
                break;
            }
            default:{
                [self getCurentLocation];
                break;
            }
        }
        
        [self updateCellWithIdentifier:@"locationCell"];
        
    }
}


//Authorization Status Changed
- (void)        locationManager:(CLLocationManager *)manager
   didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    NSLog(@"The authorization status of location services is changed to: ");
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:{
            NSLog(@"Denied");
            break;
        }
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"Not determined");
            break;
        }case kCLAuthorizationStatusRestricted:{
            NSLog(@"Restricted");
            break;
        }
        default:{
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
    [self.bill upadatePlacemark:nil];
    [self updateCellWithIdentifier:@"locationCell"];
    [self showMapCell];
    
}


-(void) locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //    [self displayAlertWithTitle:@"访问错误"
    //                        message:@"无法获取您的位置！"];
    [self.locationManager stopUpdatingLocation];
    //    self.locationSwitch.on = NO;
    //    [self locationIsOnStateChanged:self.locationSwitch];
    
}

- (void)getCurentLocation{
    [self.locationManager startUpdatingLocation];
    
}

- (void)displayAlertWithTitle:(NSString *)title
                      message:(NSString *)message{
    
    UIAlertView *alertView =
    [[UIAlertView alloc]
     initWithTitle:title
     message:message
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles: nil];
    
    [alertView show];
    
}




@end
