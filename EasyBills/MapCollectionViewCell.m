//
//  MapCollectionViewCell.m
//  EasyBills
//
//  Created by 罗 杰 on 11/12/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "MapCollectionViewCell.h"
#import "Bill.h"



@interface MapCollectionViewCell ()


@end


@implementation MapCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    self.mapView.delegate = self;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(handleSetBillLocationIsOnNotification:)
                   name:kSetBillLocationIsOnNotification
                 object:nil];
}

-(void) handleSetBillLocationIsOnNotification:(NSNotification *)paraNotification
{
    [self updateUIWithLocationIsOnState:self.bill.locationIsOn.boolValue];
}



-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setBill:(Bill *)bill
{
    _bill = bill;
    [self updateUIWithLocationIsOnState:self.bill.locationIsOn.boolValue];
}

-(void)updateUIWithLocationIsOnState:(BOOL)locationIsOn
{
    if (locationIsOn){
        [self mapViewReloadData];
        [self labelUpdate];
    }else{
        [self updateMapViewAndLabelWithoutLocation];
    }
}

-(void)mapViewReloadData
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:(id <MKAnnotation>)self.bill];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}


-(void)labelUpdate
{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.bill.latitude.doubleValue longitude:self.bill.longitude.doubleValue];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (!error && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            [self.activity stopAnimating];
            self.label.text = [NSString stringWithFormat:@"%@,%@,%@",
                               placemark.administrativeArea,    placemark.locality,    placemark.thoroughfare];
        }else{
            NSLog(@"%@",error.debugDescription);
        }
    }];

}

-(void)updateMapViewAndLabelWithoutLocation
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
    self.label.text = @"";
    [self.activity startAnimating];
}

- (IBAction)mapViewReloadData:(UIButton *)sender {
    [self mapViewReloadData];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = nil;
    static NSString *reuseId = @"billAnnotation";
    view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    view.canShowCallout = NO;
    view.pinColor = self.bill.isIncome.boolValue ? MKPinAnnotationColorGreen : MKPinAnnotationColorRed;
    return view;
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
