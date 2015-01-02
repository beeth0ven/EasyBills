//
//  KindNameTableViewCell.h
//  EasyBills
//
//  Created by 罗 杰 on 12/11/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kind+Create.h"



@interface KindNameTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong ,nonatomic) Kind *kind;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
