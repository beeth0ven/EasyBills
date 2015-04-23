//
//  KindDetailCVC.h
//  EasyBills
//
//  Created by Beeth0ven on 2/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kind+Create.h"


@interface KindDetailCVC : UICollectionViewController
<UITextFieldDelegate>


@property (strong ,nonatomic) Kind *kind;
@property (nonatomic) BOOL isIncome;


@end
