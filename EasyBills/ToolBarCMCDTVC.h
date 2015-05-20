//
//  ToolBarCMCDTVC.h
//  EasyBills
//
//  Created by luojie on 3/25/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ClusterMapCDTVC.h"
#import "UIViewController+Extension.h"

@interface ToolBarCMCDTVC : ClusterMapCDTVC <CLLocationManagerDelegate>

@property (strong, nonatomic, readonly) UIView *viewForHoldingRevealPanGesture;

@end




