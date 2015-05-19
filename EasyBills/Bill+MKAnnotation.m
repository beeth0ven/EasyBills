//
//  Bill+MKAnnotation.m
//  EasyBills
//
//  Created by 罗 杰 on 10/25/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "Bill+MKAnnotation.h"
#import "Kind+Create.h"
#import "NSString+Extension.h"
#import "Plackmark+Create.h"
#import "AppDelegate.h"

@implementation Bill (MKAnnotation)


-(CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
//    if ([self isInChinaAtCoordinate:coordinate]) {
//        coordinate.latitude += [self chinaOffestCoordinate].latitude;
//        coordinate.longitude += [self chinaOffestCoordinate].longitude;
//    }
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self.latitude = [NSString stringWithFormat:@"%.8f",coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.8f",coordinate.longitude];
}

-(CLLocationCoordinate2D) clusterAnnotationCoordinate{
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.clusterAnnotationLatitude doubleValue];
    coordinate.longitude = [self.clusterAnnotationLongitude  doubleValue];
//    if ([self isInChinaAtCoordinate:coordinate]) {
//        coordinate.latitude += [self chinaOffestCoordinate].latitude;
//        coordinate.longitude += [self chinaOffestCoordinate].longitude;
//    }
    return coordinate;
}

- (void)setClusterAnnotationCoordinate:(CLLocationCoordinate2D)coordinate {
    self.clusterAnnotationLatitude = [NSString stringWithFormat:@"%.8f",coordinate.latitude];
    self.clusterAnnotationLongitude = [NSString stringWithFormat:@"%.8f",coordinate.longitude];
}

//
//- (BOOL)isInChinaAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    BOOL inChina =  (3.3 < coordinate.latitude &&
//                     coordinate.latitude < 53.4 &&
//                     73.2 < coordinate.longitude &&
//                     coordinate.longitude < 135.3);
//    
//    NSLog(@"In China: %i",inChina);
//    return inChina;
//}
//
//- (CLLocationCoordinate2D)chinaOffestCoordinate {
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = -0.0022;
//    coordinate.longitude = 0.0056;
//    return coordinate;
//}

-(NSString *)title
{
    if (self.containedAnnotations.count > 0) {
        return [NSString stringWithFormat:@"%zd 笔账单"
                , self.containedAnnotations.count + 1];
        
    }
    return self.kind.name;
}

//-(NSString *)subtitle
//{
//    NSString *reslut = nil;
//    if (self.plackmark.name.length) {
//        reslut = self.plackmark.name;
//    }
//    if (self.containedAnnotations.count > 0) {
//        // This is the father bill.
//        CLLocation *location = [[CLLocation alloc]
//                                initWithLatitude:self.coordinate.latitude
//                                longitude:self.coordinate.longitude];
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        
//        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//            if (placemarks.count > 0) {
//                CLPlacemark *placemark = placemarks.firstObject;
//                reslut = [NSString stringWithFormat:@"Near %@",
//                          [NSString stringForPlacemark:placemark]];
//            }
//        }];
//        
//    } else {
//        // This is the son bill.
//        
////        reslut = [NSString stringWithFormat:@"￥  %.2f",fabs(self.money.floatValue)];
//    }
//    return reslut;
//}


- (void)upadatePlacemark{
    
        if (self.locationIsOn) {
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            CLLocation *location =[[CLLocation alloc]
                                   initWithLatitude:self.latitude.doubleValue
                                   longitude:self.longitude.doubleValue];
            
            [geocoder reverseGeocodeLocation:location
                           completionHandler:
             ^(NSArray *placemarks, NSError *error){
                 [self.managedObjectContext performBlock:^{
                     
                     if (!error && [placemarks count] > 0) {
                         CLPlacemark *placemark = [placemarks lastObject];
                         NSString *name = [NSString stringForPlacemark:placemark];
                         self.plackmark = [Plackmark plackmarkWithName:name inManagedObjectContext:self.managedObjectContext];
                     }else{
                         self.plackmark = [Plackmark plackmarkWithName:@"未知地点" inManagedObjectContext:self.managedObjectContext];
                         
                     }
                     
                     
                     AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                     [appDelegate saveContext];
                 }];

             
                 
             }];
            
        }else{
            self.plackmark = nil;
        }

    
}






@end
