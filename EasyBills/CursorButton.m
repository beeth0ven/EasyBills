//
//  CursorButton.m
//  CursorBarButton
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#import "CursorButton.h"
#import "Paths.h"
#import "CGPath+Extension.h"

@interface CursorButton ()

@property (strong, nonatomic) CAShapeLayer *cursorShap;

@end


@implementation CursorButton

#pragma mark - Instancetype Method



- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}


+ (instancetype)cursorButtonSetOn:(BOOL)on {

    CursorButton *cursorButton = [[self alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           44 * [self pathScale],
                                                           44)];
    cursorButton.on = on;
    return cursorButton;
}

#pragma mark - Property Setter And Getter Method



- (UIColor *)notFavoriteColor {
    return [UIColor grayColor];
}

- (UIColor *)cursorFavoriteColor {
    return [UIColor blueColor];
}

//pathScale control the path scale, For example value 1 is full screen in the self button frame;
+ (CGFloat)pathScale {
    return 0.5;
}

- (void)setOn:(BOOL)on {
    _on  = on;
    [self updateLayerProperties];
    
}

#pragma mark - Layout Method


- (void)layoutSubviews {
    [super layoutSubviews];
    [self createLayersIfNeeded];
    [self updateConstraints];
    
}


- (void)createLayersIfNeeded {
    
    if (self.cursorShap == nil) {
        CGRect cursorFrame = self.bounds;
        cursorFrame.size.width  = CGRectGetWidth(cursorFrame);
        cursorFrame.size.height = CGRectGetHeight(cursorFrame) *  [CursorButton pathScale];
        
        self.cursorShap = [[CAShapeLayer alloc] init];
        
        self.cursorShap.path = CGPathRescaleForFrame([Paths cursor], cursorFrame);
        self.cursorShap.bounds = CGPathGetBoundingBox(self.cursorShap.path);
        self.cursorShap.fillColor = self.notFavoriteColor.CGColor;
        self.cursorShap.position = CGPointMake(CGRectGetWidth(self.frame)/2,
                                               CGRectGetHeight(self.frame)/2);
        
        self.cursorShap.transform = CATransform3DIdentity;
        self.cursorShap.opacity = 0.5;
        [self.layer addSublayer:self.cursorShap];
        
    }
    [self updateLayerProperties];
}

- (void)updateLayerProperties {
    if (self.cursorShap != nil) {
        self.cursorShap.fillColor = self.isOn ? self.cursorFavoriteColor.CGColor : self.notFavoriteColor.CGColor;
        
    }
}


@end
