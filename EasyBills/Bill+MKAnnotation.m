//
//  Bill+MKAnnotation.m
//  EasyBills
//
//  Created by 罗 杰 on 10/25/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "Bill+MKAnnotation.h"
#import "Kind+Create.h"


@implementation Bill (MKAnnotation)


-(CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];

    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    self.latitude = [NSString stringWithFormat:@"%.8f",coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.8f",coordinate.longitude];
}

-(NSString *)title
{
    if (self.containedAnnotations.count > 0) {
        return [NSString stringWithFormat:@"%zd Bills"
                , self.containedAnnotations.count + 1];
        
    }
    return self.kind.name;
}

-(NSString *)subtitle
{
    __block NSString *reslut = nil;
    if (self.containedAnnotations.count > 0) {
        // This is the father bill.
        CLLocation *location = [[CLLocation alloc]
                                initWithLatitude:self.coordinate.latitude
                                longitude:self.coordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark *placemark = placemarks.firstObject;
                reslut = [NSString stringWithFormat:@"Near %@",
                        [self stringForPlaceMark:placemark]];
            }
        }];
        
    } else {
        // This is the son bill.
        reslut = [NSString stringWithFormat:@"￥  %.2f",fabs(self.money.floatValue)];
    }
    return reslut;
}

- (NSString *)stringForPlaceMark:(CLPlacemark *)placemark{
    
    NSMutableString *string = [[NSMutableString alloc] init];
    if (placemark.locality) {
        [string appendString:placemark.locality];
    }
    
    if (placemark.administrativeArea) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendString:placemark.administrativeArea];
    }
    
    if (string.length == 0 && placemark.name)
        [string appendString:placemark.name];
    
    return string;
}






@end
