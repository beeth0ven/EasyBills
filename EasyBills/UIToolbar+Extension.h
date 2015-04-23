//
//  UIToolbar+Extension.h
//  EasyBills
//
//  Created by luojie on 4/23/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Extension)

+ (UIToolbar *)keyboardToolBarWithVC:(UIViewController *)VC
                         doneAction:(SEL)doneAction;
@end
