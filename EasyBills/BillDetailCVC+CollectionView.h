//
//  MyCollectionViewController+CollectionView.h
//  EasyBills
//
//  Created by 罗 杰 on 11/15/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "BillDetailCVC.h"

@interface BillDetailCVC (CollectionView)

- (void) handleTextFieldDidBeginEditingNotification:(NSNotification *)paramNotification;
- (void) handleSetBillLocationIsOnNotification:(NSNotification *)paramNotification;
- (void) handleDeleteBillImageNotification:(NSNotification *)paramNotification;


-(void)showInputCellWithBaseCellIdentifier:(NSString *)identifier;
-(void)updateInputPhotoCell;


@end
