//
//  BillDetailCVC+Observer.m
//  EasyBills
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+Observer.h"

@implementation BillDetailCVC (Observer)


#pragma mark - Notifications Method


-(void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //keyboard notification ,scoll textfield to visible.
    
    [center addObserver:self
               selector:@selector(keyboardWasShown:)
                   name:UIKeyboardDidShowNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(keyboardWillBeHidden:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    
    //KVO
    [self.bill addObserver:self
                forKeyPath:@"locationIsOn"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
    
    [self.bill addObserver:self
                forKeyPath:@"date"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
    
    [self.bill addObserver:self
                forKeyPath:@"kind"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
}

- (void) dealloc{
    
    if (self.bill != nil){
        [self.bill removeObserver:self forKeyPath:@"locationIsOn"];
        [self.bill removeObserver:self forKeyPath:@"date"];
        [self.bill removeObserver:self forKeyPath:@"kind"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:@"locationIsOn"]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if ([newValue respondsToSelector:@selector(boolValue)]) {
            BOOL isOn = newValue.boolValue;
            if (isOn == NO) {
                [self updateMapViewCellWithoutLocation];
            }
        }
        
    }else if ([keyPath isEqualToString:@"date"]){
        
        [self updateCellWithIdentifier:@"dateCell"];
        
    }else if ([keyPath isEqualToString:@"kind"]){
        
        [self updateCellWithIdentifier:@"kindCell"];
        
    }
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //Clear other input cell.
    if (self.inputCellIndexPath) {
        [self.collectionView performBatchUpdates:^{
            [self removeDataAndCellAtIndexPath:self.inputCellIndexPath];
            self.inputCellIndexPath = nil;
            
        }
                                      completion:nil];
    }
    
    //Scoll cell to visible
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize =[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    contentInsets.bottom = kbSize.height;
    
    self.collectionView.contentInset = contentInsets;
    self.collectionView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height);
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
        CGRect rect = self.activeField.frame;
        [self.collectionView scrollRectToVisible:rect animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    contentInsets.bottom = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionView.contentInset = contentInsets;
        
    }];
    self.collectionView.scrollIndicatorInsets = contentInsets;
    
}










@end
