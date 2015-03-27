//
//  BillDetailCVC+UITextField.m
//  EasyBills
//
//  Created by luojie on 3/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+UITextField.h"

@implementation BillDetailCVC (UITextField)



#pragma mark - UITextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == self.moneyTextField) {
        float sum = textField.text.floatValue;
        
        if (!self.bill.isIncome.boolValue) sum = sum * -1;
        NSNumber *sumNumber =[NSNumber numberWithFloat: sum];
        
        if (![self.bill.money isEqualToNumber:sumNumber])
            self.bill.money = sumNumber;
    }else if (textField == self.noteTextField){
        self.bill.note = textField.text;
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //scoll cell to visible
    self.activeField = textField;
}

@end
