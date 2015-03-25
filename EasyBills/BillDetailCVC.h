//
//  MyCollectionViewController.h
//  EasyBills
//
//  Created by 罗 杰 on 11/10/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "Kind+Create.h"
#import "Bill+Create.h"
#import "MoneyCVCell.h"
#import "ImageCollectionViewCell.h"


#define DELETE_BILL_ACTIONSHEET_TITLE "您确定要删除账此单吗?"
#define DELETE_BILL_IMAGE_ACTIONSHEET_TITLE "您确定要删除此照片吗?"


@interface BillDetailCVC : UICollectionViewController


@property (strong ,nonatomic) Bill *bill;
@property (nonatomic) BOOL isIncome;


@end
