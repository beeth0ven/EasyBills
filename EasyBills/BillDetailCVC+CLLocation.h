//
//  BillDetailCVC+CLLocation.h
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC.h"

@interface BillDetailCVC (CLLocation)<CLLocationManagerDelegate>

- (void)requestGetCurentLocation;
- (void)getCurentLocation;


@end
