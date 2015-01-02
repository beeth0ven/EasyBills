//
//  LocationCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "LocationCollectionViewCell.h"
#import <CoreLocation/CoreLocation.h>

NSString *const kSetBillLocationIsOnNotification = @"kSetBillLocationIsOnNotification";
NSString *const kSetBillLocationIsKey = @"kSetBillLocationIsKey";


@interface LocationCollectionViewCell ()<CLLocationManagerDelegate,UIActionSheetDelegate>




@property (strong ,nonatomic) CLLocationManager *locationManager;


@end

@implementation LocationCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setBill:(Bill *)bill
{
    _bill = bill;
    self.locationSwitch.on = self.bill.locationIsOn.boolValue;
    //when create a new bill with location is on;
    if ((bill.locationIsOn.boolValue) && (bill.latitude.length == 0)) [self getCurentLocation];
}


- (IBAction)locationIsOnStateChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        [self getCurentLocation];
    }else{
        self.bill.locationIsOn = [NSNumber numberWithBool:NO];
        self.bill.latitude = nil;
        self.bill.longitude = nil;
    }
    [self postNotificationWithLocationIsOn:sender.isOn];

}



-(void)getCurentLocation
{
    [self.locationManager startUpdatingLocation];
}

-(void)postNotificationWithLocationIsOn:(BOOL)locationIsOn
{
    NSNotification *notification =
    [NSNotification
     notificationWithName:kSetBillLocationIsOnNotification
     object:self
     userInfo:@{kSetBillLocationIsKey : [NSNumber numberWithBool:locationIsOn]}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *curentLocation = locations.lastObject;
    self.bill.locationIsOn = [NSNumber numberWithBool:YES];
    self.bill.latitude = [NSString stringWithFormat:@"%.8f" ,curentLocation.coordinate.latitude];
    self.bill.longitude = [NSString stringWithFormat:@"%.8f" ,curentLocation.coordinate.longitude];
    [manager stopUpdatingLocation];
    self.locationSwitch.on = YES;
    [self postNotificationWithLocationIsOn:YES];
    NSLog(@"latitude:%f longitude:%f",curentLocation.coordinate.latitude ,curentLocation.coordinate.longitude);

}


-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                    message:@"无法获取您的位置"
                                                   delegate:nil
                                           cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
    [manager stopUpdatingLocation];
    self.locationSwitch.on = NO;
    [self locationIsOnStateChanged:self.locationSwitch];
    
}


#pragma mark - Properties

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    return _locationManager;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
