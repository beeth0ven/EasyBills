//
//  MyCollectionViewController+ActionSheet.m
//  EasyBills
//
//  Created by 罗 杰 on 11/15/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "MyCollectionViewController+ActionSheet.h"

@implementation MyCollectionViewController (ActionSheet)

#pragma mark - UIActionSheetDelegate


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"删除" ]) {
        [self deleteBill];
    }
}

- (void)deleteBill
{
    //[self.view endEditing:YES];
    [[PubicVariable managedObjectContext] deleteObject:self.bill];
    [self dismissViewControllerAnimated:YES completion:^(){}];
    
}

@end
