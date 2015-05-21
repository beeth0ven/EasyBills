//
//  BillDetailCVC+UIActionSheet.m
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+UIActionSheet.h"
#import "AppDelegate.h"

@implementation BillDetailCVC (UIActionSheet)

#pragma mark - UIAction Sheet Delegate Method


-(void)     actionSheet:(UIActionSheet *)actionSheet
   clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:NSLocalizedString( @"Delete", "") ]) {
        [self deleteBill];
    }
}

- (void)deleteBill
{
    [self.managedObjectContext deleteObject:self.bill];
    [self dismissViewControllerAnimated:YES completion:^(){
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate saveContext];
    }];
    
}


@end
