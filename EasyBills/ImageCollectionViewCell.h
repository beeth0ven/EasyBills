//
//  ImageCollectionViewCell.h
//  EasyBills
//
//  Created by 罗 杰 on 11/29/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"

extern NSString *const kDeleteBillImageNotification;


@interface ImageCollectionViewCell : UICollectionViewCell <UIActionSheetDelegate>


@property (strong ,nonatomic) Bill *bill;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;


@end
