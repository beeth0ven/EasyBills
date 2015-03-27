//
//  BillDetailCVC+UIPickerView.m
//  EasyBills
//
//  Created by luojie on 3/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+UIPickerView.h"

@implementation BillDetailCVC (UIPickerView)



#pragma mark UIPickerViewDataSource Methods
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return [[self.kindFRC sections] count];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[self.kindFRC sections] objectAtIndex:component] numberOfObjects];
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    
    NSIndexPath *indexPath =
    [NSIndexPath indexPathForItem:row inSection:component];
    Kind *kind = [self.kindFRC objectAtIndexPath:indexPath];
    return  kind.name;
}


#pragma mark UIPickerViewDelegate Methods

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:component];
    Kind *kind = [self.kindFRC objectAtIndexPath:indexPath];
    
    self.bill.kind = kind;
    kind.visiteTime = [NSDate date];
    
}


@end
