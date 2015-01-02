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

-(NSString *)title
{
    return self.kind.name;
}

-(NSString *)subtitle
{
    return [NSString stringWithFormat:@"￥  %.2f",fabs(self.money.floatValue)];
}






@end
