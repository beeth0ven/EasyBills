//
//  KindDetailCVC.h
//  EasyBills
//
//  Created by Beeth0ven on 2/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kind+Create.h"

#define DELETE_KIND_ACTIONSHEET_TITLE @"您确定要删除账此类别吗?"

@interface KindDetailCVC : UICollectionViewController
<UITextFieldDelegate,
UIAlertViewDelegate,
UIActionSheetDelegate,
UICollectionViewDelegateFlowLayout>


@property (strong ,nonatomic) Kind *kind;
@property (nonatomic) BOOL isIncome;


@end
