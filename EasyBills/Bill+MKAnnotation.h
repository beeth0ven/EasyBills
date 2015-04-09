//
//  Bill+MKAnnotation.h
//  EasyBills
//
//  Created by 罗 杰 on 10/25/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "Bill.h"
#import <MapKit/MapKit.h>

@interface Bill (MKAnnotation)<MKAnnotation>

-(CLLocationCoordinate2D) clusterAnnotationCoordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)setClusterAnnotationCoordinate:(CLLocationCoordinate2D)coordinate;

typedef void (^GeocodeCompletionHandler)(UIActivity *activity, UILabel *label ,id  self);

- (void)upadatePlacemark:(GeocodeCompletionHandler)completionHandler;

@end
