//
//  BillDetailCVC+Extension.m
//  EasyBills
//
//  Created by luojie on 3/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "BillDetailCVC+Extension.h"

@implementation BillDetailCVC (Extension)


-(UIToolbar *)keyboardToolBar
{
    UIToolbar *result = [[UIToolbar alloc]
                         initWithFrame:CGRectMake(0,
                                                  0,
                                                  self.view.bounds.size.width,
                                                  35)];
    
    result.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                             target:self
                             action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"完成"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(endEditing)];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : EBBlue};
    [doneBarButton setTitleTextAttributes:attributes
                                 forState:UIControlStateNormal];
    
    [result setItems:@[flex, doneBarButton]];
    
    return result;
}



@end
