//
//  CursorButton.h
//  CursorBarButton
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CursorButton : UIButton

@property (nonatomic, getter = isOn) BOOL on;

@property (strong, nonatomic) UIColor *notFavoriteColor;

@property (strong, nonatomic) UIColor *cursorFavoriteColor;

+ (instancetype)cursorButtonSetOn:(BOOL)on;


@end
