//
//  SettingTableViewController.h
//  EasyBills
//
//  Created by 罗 杰 on 10/7/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingTVC : UITableViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
