//
//  LJChartView.h
//  LJChart
//
//  Created by Beeth0ven on 3/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#define EBBlue          [UIColor colorWithRed:95.0 / 255.0 green:200.0 / 255.0 blue:220.0 / 255.0 alpha:1.0f]
#define EBBackGround    [UIColor colorWithRed:137.0 / 255.0 green:142.0 / 255.0 blue:145.0 / 255.0 alpha:1.0f]


#import <UIKit/UIKit.h>



@protocol LJChartViewDataSource;


@interface LJChartView : UIView

@property (nonatomic, assign) id <LJChartViewDataSource> dataSource;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) NSAttributedString *attributedTitle;
@property (nonatomic, strong) NSAttributedString *attributedSubTitle;
@property (nonatomic, strong) UIImage *leftTitleImage;
@property (nonatomic, strong) UIImage *rightTitleImage;

@end


@protocol LJChartViewDataSource <NSObject>

@required

- (NSInteger)numberOfLinesInChartView:(LJChartView *)chartView;

- (NSInteger)numberOfPointsOnLineInChartView:(LJChartView *)chartView;

- (float)chartView:(LJChartView *)chartView valueForPointAtIndexPath:(NSIndexPath *)indexPath;

- (UIColor *)chartView:(LJChartView *)chartView colorOfLine:(NSInteger)line;


@optional


@end