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
    
    // others can't edite  when TextFieldDidBeginEditing.
    
    [center addObserver:self
               selector:@selector(handleTextFieldDidBeginEditingNotification:)
                   name:kTextFieldDidBeginEditingNotification
                 object:nil];
    
    //keyboard notification ,scoll textfield to visible.
    
    [center addObserver:self
               selector:@selector(keyboardWasShown:)
                   name:UIKeyboardDidShowNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(keyboardWillBeHidden:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    
    //Reset Map Cell State
    [self.bill addObserver:self
                forKeyPath:@"locationIsOn"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
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
        
        
    }
    
}


- (void) handleTextFieldDidBeginEditingNotification:(NSNotification *)paramNotification{
    
    if (self.inputCellIndexPath) {
        [self.collectionView performBatchUpdates:^{
            [self removeDataAndCellAtIndexPath:self.inputCellIndexPath];
            self.inputCellIndexPath = nil;
            
        }
                                      completion:nil];
    }
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize =[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    contentInsets.bottom = kbSize.height;
    
    self.collectionView.contentInset = contentInsets;
    self.collectionView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height);
    PubicVariable *pubicVariable = [PubicVariable pubicVariable];
    if (!CGRectContainsPoint(aRect, pubicVariable.activeField.frame.origin)) {
        CGRect rect = pubicVariable.activeField.frame;
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
