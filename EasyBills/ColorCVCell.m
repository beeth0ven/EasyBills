//
//  ColorCVCell.m
//  EasyBills
//
//  Created by 罗 杰 on 2/4/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ColorCVCell.h"

@interface ColorCVCell ()

@property (strong, nonatomic) UIView *circleView;
@property (strong, nonatomic) UIView *selectedCircleView;


@end



@implementation ColorCVCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    //initialize when first create the cell with dequeue method.
    
    if ([self isFirstCreate]) {
        [self initialize];
    }
    
    //if selected property is not change ,do nothing here.
    
    if (self.isSelected == selected) {
        return;
    }
    
    
    [super setSelected:selected];
    
    // change the cell select state with animation or not.
    
    [self setSelected:selected
        isFirstCreate:[self isFirstCreate]];
    
    
}

- (BOOL)isFirstCreate{
    return [self.subviews containsObject:self.circleView] == NO;
}

- (void)initialize
{
    [self addSubview:self.circleView];
    [self.circleView addSubview:self.selectedCircleView];
    //by defualt the select state is no,so the select circle should not show.
    [self showSelectedCircleView:NO];
    NSLog(@"Successfully create the circle view.");

}

- (void)setSelected:(BOOL)selected
      isFirstCreate:(BOOL)firstCreate
{
    if (selected == YES) {
        NSLog(@"Cell is selected.");
        if (firstCreate) {
            //get the cell defualt select state ,show the circle without animation.
            [self showSelectedCircleView:YES];
            NSLog(@"Successfully add the selected circle.");
            
        }else{
            //when user tap the cell, show the circle with animation.

            [UIView
             animateWithDuration:0.5
             delay:0
             options:UIViewAnimationOptionCurveLinear
             animations:^{
                 
                 [self showSelectedCircleView:YES];
                 
             }
             completion:^(BOOL finished) {
                 if (finished) {
                     NSLog(@"Successfully add the selected circle with animation.");
                 }
             }];
            
        }
    }else{
        
        NSLog(@"Cell was not selected.");
        if (firstCreate) {
            //get the cell defualt select state ,hide the circle without animation.

            [self showSelectedCircleView:NO];
            NSLog(@"Successfully remove the selected circle.");
            
        }else{
            //when user tap the another cell, hide the circle with animation.
            [UIView
             animateWithDuration:0.5
             delay:0
             options:UIViewAnimationOptionCurveLinear
             animations:^{
                 [self showSelectedCircleView:NO];
                 
             }
             completion:^(BOOL finished) {
                 if (finished) {
                     NSLog(@"Successfully remove the selected circle with animation.");
                 }
             }];
        }
        
    }
}

- (void)showSelectedCircleView:(BOOL)show
{
    CGAffineTransform transform = self.selectedCircleView.transform;

    if (show) {
        self.selectedCircleView.hidden = NO;
        self.selectedCircleView.transform =
        CGAffineTransformScale(transform,
                               100,
                               100);
    }else{
        self.selectedCircleView.transform =
        CGAffineTransformScale(transform,
                               0.01,
                               0.01);
        self.selectedCircleView.hidden = NO;
    }
    
    
}


- (UIView *)circleView{
    
    if (_circleView == nil) {
        _circleView= [[UIView alloc]
                      initWithFrame:CGRectMake(self.bounds.size.width   * 1 / 8,
                                               self.bounds.size.height  * 1 / 8,
                                               self.bounds.size.width   * 3 / 4,
                                               self.bounds.size.height  * 3 / 4)];
        //_circleView.center = self.center;
        _circleView.layer.cornerRadius = self.circleView.bounds.size.width / 2;
        _circleView.backgroundColor = [UIColor whiteColor];
    }
    return _circleView;
}


- (UIView *)selectedCircleView{
    
    if (_selectedCircleView == nil) {
        _selectedCircleView= [[UIView alloc]
                              initWithFrame:CGRectMake(self.circleView.bounds.size.width   * 1 / 8,
                                                       self.circleView.bounds.size.height  * 1 / 8,
                                                       self.circleView.bounds.size.width   * 3 / 4,
                                                       self.circleView.bounds.size.height  * 3 / 4)];
        //_selectedCircleView.center = self.center;
        _selectedCircleView.layer.cornerRadius = self.selectedCircleView.bounds.size.width / 2;
        _selectedCircleView.backgroundColor = self.backgroundColor;
    }
    return _selectedCircleView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
