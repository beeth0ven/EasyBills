//
//  ColorCVCell.h
//  EasyBills
//
//  Created by luojie on 4/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCVCell : UICollectionViewCell


@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *favoriteColor;
@property (nonatomic, strong) UIColor *notFavoriteColor;
@property (nonatomic, strong) UIColor *shapFavoriteColor;

@property (nonatomic, getter = isFavorite) BOOL favorite;



@end
