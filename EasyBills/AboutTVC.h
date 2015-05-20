//
//  AboutTableViewController.h
//  EasyBills
//
//  Created by luojie on 5/10/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "UIViewController+Extension.h"



@interface AboutTVC : UITableViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic, readonly) UIView *viewForHoldingRevealPanGesture;

@end




