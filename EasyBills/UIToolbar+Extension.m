//
//  UIToolbar+Extension.m
//  EasyBills
//
//  Created by luojie on 4/23/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIToolbar+Extension.h"
#import "DefaultStyleController.h"

@implementation UIToolbar (Extension)




+ (UIToolbar *)keyboardToolBarWithVC:(UIViewController *)VC
                         doneAction:(SEL)doneAction
{
    UIToolbar *result = [[UIToolbar alloc]
                         initWithFrame:CGRectMake(0,
                                                  0,
                                                  VC.view.bounds.size.width,
                                                  35)];
    
    result.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                             target:self
                             action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"完成"
                                      style:UIBarButtonItemStylePlain
                                      target:VC
                                      action:doneAction];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : EBBlue};
    [doneBarButton setTitleTextAttributes:attributes
                                 forState:UIControlStateNormal];
    
    [result setItems:@[flex, doneBarButton]];
    
    return result;
}


@end
