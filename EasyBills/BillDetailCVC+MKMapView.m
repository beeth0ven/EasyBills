//
//  BillDetailCVC+MKMapView.m
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+MKMapView.h"

@implementation BillDetailCVC (MKMapView)


#pragma mark - MKMap View Delegate Method

-(MKAnnotationView *)   mapView:(MKMapView *)mapView
              viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = nil;
    static NSString *reuseId = @"billAnnotation";
    view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
    UIColor *color = self.bill.kind.color;
    view.image = [UIImage pointerImageWithColor:color];
    view.canShowCallout = NO;
    //    view.pinColor = self.bill.isIncome.boolValue ? MKPinAnnotationColorGreen : MKPinAnnotationColorRed;
    return view;
}




- (void)reloadDataInMapView:(MKMapView *)mapView{
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotation:(id <MKAnnotation>)self.bill];
    [mapView showAnnotations:mapView.annotations animated:YES];
}


@end
