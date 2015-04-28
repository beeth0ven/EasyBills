//
//  ColorCVCell.m
//  EasyBills
//
//  Created by luojie on 4/27/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ColorCVCell.h"
#import "Paths.h"
#import "CGPath+Extension.h"
 #import <QuartzCore/QuartzCore.h>


NSString *const starKey = @"FAVANIMKEY";
NSString *const favoriteKey = @"FAVORITE";
NSString *const notFavoriteKey = @"NOTFAVORITE";

@interface ColorCVCell ()

@property (nonatomic, strong) CAShapeLayer *shap;
@property (nonatomic, strong) CAShapeLayer *outerRingShape;
@property (nonatomic, strong) CAShapeLayer *fillRingShape;




@end


@implementation ColorCVCell

- (void)awakeFromNib {
    if (self.lineWidth == 0) self.lineWidth = 1;
    if (self.favoriteColor == nil) self.favoriteColor = [UIColor redColor];
    if (self.notFavoriteColor == nil) self.favoriteColor = [UIColor grayColor];
    if (self.shapFavoriteColor == nil) self.shapFavoriteColor = [UIColor whiteColor];
}


- (void)createLayersIfNeeded {
    if (self.fillRingShape == nil) {
        self.fillRingShape = [[CAShapeLayer alloc] init];
        self.fillRingShape.path = [Paths circleInFrame:[self frameWithInset]];
        self.fillRingShape.bounds = CGPathGetBoundingBox(self.fillRingShape.path);
        self.fillRingShape.fillColor = self.favoriteColor.CGColor;
        self.fillRingShape.lineWidth = self.lineWidth;
        self.fillRingShape.position =
        CGPointMake(CGRectGetWidth(self.fillRingShape.bounds)/2,
                    CGRectGetHeight(self.fillRingShape.bounds)/2);
        self.fillRingShape.transform = CATransform3DMakeScale(0.2, 0.2, 0.2);
        self.fillRingShape.opacity = 0;
        
        [self.layer addSublayer:self.fillRingShape];
    }
    
    if (self.outerRingShape == nil) {
        self.outerRingShape = [[CAShapeLayer alloc] init];
        self.outerRingShape.path = [Paths circleInFrame:[self frameWithInset]];
        self.outerRingShape.bounds = [self frameWithInset];
        self.outerRingShape.lineWidth = self.lineWidth;
        self.outerRingShape.strokeColor = self.notFavoriteColor.CGColor;
        self.outerRingShape.fillColor = [UIColor clearColor].CGColor;
        self.outerRingShape.position =
        CGPointMake(CGRectGetWidth(self.bounds)/2,
                    CGRectGetHeight(self.bounds)/2);
        self.outerRingShape.transform = CATransform3DIdentity;
        self.outerRingShape.opacity = 0.5;
        [self.layer addSublayer:self.outerRingShape];

    }
    
    if (self.shap == nil) {
        CGRect starFrame = self.bounds;
        starFrame.size.width = CGRectGetWidth(starFrame)/2.5;
        starFrame.size.height = CGRectGetHeight(starFrame)/2.5;
        
        self.shap = [[CAShapeLayer alloc] init];
        
        //Change path here. ----------------------------------------------------------------------------
        
        self.shap.path = CGPathRescaleForFrame([Paths heart], starFrame);
        self.shap.bounds = CGPathGetBoundingBox(self.shap.path);
        self.shap.fillColor = self.notFavoriteColor.CGColor;
        self.shap.position =
        CGPointMake(CGRectGetWidth(CGPathGetBoundingBox(self.outerRingShape.path))/2,
                    CGRectGetHeight(CGPathGetBoundingBox(self.outerRingShape.path))/2);
        self.shap.transform = CATransform3DIdentity;
        self.shap.opacity = 0.5;
        [self.layer addSublayer:self.shap];

    }
    
    if (self.isFavorite) {
        //Show Favorite States
        self.shap.fillColor = self.shapFavoriteColor.CGColor;
        self.shap.opacity = 1;
        self.shap.transform = CATransform3DIdentity;
        
        self.fillRingShape.opacity = 1;
        self.fillRingShape.transform = CATransform3DIdentity;
        
        self.outerRingShape.transform = CATransform3DIdentity;
        self.outerRingShape.opacity = 0;

    }
}


- (void)updateLayerProperties {
    if (self.fillRingShape) {
        self.fillRingShape.fillColor = self.favoriteColor.CGColor;
    }
    
    if (self.outerRingShape) {
        self.outerRingShape.lineWidth = self.lineWidth;
        self.outerRingShape.strokeColor = self.notFavoriteColor.CGColor;
    }
    
    if (self.shap) {
        self.shap.fillColor = self.isFavorite ? self.shapFavoriteColor.CGColor : self.notFavoriteColor.CGColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createLayersIfNeeded];
    [self updateConstraints];
}


- (void)favorite {
    //  1.Star
    CATransform3D starGoUp = CATransform3DIdentity;
    starGoUp = CATransform3DScale(starGoUp, 1.5, 1.5, 1.5);
    
    CATransform3D starGoDown = CATransform3DIdentity;
    starGoDown = CATransform3DScale(starGoDown, 0.01, 0.01, 0.01);
    
    CAKeyframeAnimation *starKeyFrames =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    starKeyFrames.values = @[
                             [NSValue valueWithCATransform3D:CATransform3DIdentity],
                             [NSValue valueWithCATransform3D:starGoUp],
                             [NSValue valueWithCATransform3D:starGoDown]
                            ];
    starKeyFrames.keyTimes = @[@0.0, @0.4, @0.6];
    starKeyFrames.duration = 0.4;
    starKeyFrames.beginTime = CACurrentMediaTime() + 0.05;
    starKeyFrames.timingFunction = [CAMediaTimingFunction
                                    functionWithName:kCAMediaTimingFunctionEaseIn];
    
    starKeyFrames.fillMode = kCAFillModeBackwards;
    [starKeyFrames setValue:favoriteKey forKey:starKey];
    
    starKeyFrames.delegate = self;
     [self.shap addAnimation:starKeyFrames forKey:favoriteKey];
     self.shap.transform = starGoDown;
    
    //  2.Outer Circle
    CATransform3D grayGoUp = CATransform3DIdentity;
    grayGoUp = CATransform3DScale(grayGoUp, 1.5, 1.5, 1.5);
    
    CATransform3D grayGoDown = CATransform3DIdentity;
    grayGoDown = CATransform3DScale(grayGoDown, 0.01, 0.01, 0.01);
    
    CAKeyframeAnimation *outerCircleAnimation =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    outerCircleAnimation.values = @[
                                   [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                   [NSValue valueWithCATransform3D:grayGoUp],
                                   [NSValue valueWithCATransform3D:grayGoDown]
                                   ];
    outerCircleAnimation.keyTimes = @[@0.0, @0.4, @0.6];
    outerCircleAnimation.duration = 0.4;
    outerCircleAnimation.beginTime = CACurrentMediaTime() + 0.01;
    outerCircleAnimation.fillMode = kCAFillModeBackwards;
    outerCircleAnimation.timingFunction = [CAMediaTimingFunction
                                           functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.outerRingShape addAnimation:outerCircleAnimation forKey:@"Gray circle Animation"];
    self.outerRingShape.transform = grayGoDown;
    
    //  3.Fill Circle
    CATransform3D favoriteFillGrow = CATransform3DIdentity;
    favoriteFillGrow = CATransform3DScale(favoriteFillGrow, 1.5, 1.5, 1.5);
    
    CAKeyframeAnimation *fillCircleAnimation =
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    fillCircleAnimation.values = @[
                                  [NSValue valueWithCATransform3D:self.fillRingShape.transform],
                                  [NSValue valueWithCATransform3D:favoriteFillGrow],
                                  [NSValue valueWithCATransform3D:CATransform3DIdentity]
                                  ];
    fillCircleAnimation.keyTimes = @[
                                     @0.0,
                                     @0.4,
                                     @0.6,
                                     ];
    fillCircleAnimation.duration = 0.4;
    fillCircleAnimation.beginTime = CACurrentMediaTime() + 0.22;
    fillCircleAnimation.timingFunction = [CAMediaTimingFunction
                                          functionWithName:kCAMediaTimingFunctionEaseIn];

    fillCircleAnimation.fillMode = kCAFillModeBackwards;
    
    CABasicAnimation *favoriteFillOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    favoriteFillOpacity.toValue = @1;
    favoriteFillOpacity.duration = 1;
    favoriteFillOpacity.beginTime = CACurrentMediaTime();
    favoriteFillOpacity.timingFunction = [CAMediaTimingFunction
                                          functionWithName:kCAMediaTimingFunctionEaseIn];
    favoriteFillOpacity.fillMode = kCAFillModeBackwards;
    
    [self.fillRingShape addAnimation:fillCircleAnimation forKey:@"Show fill circle"];
    [self.fillRingShape addAnimation:fillCircleAnimation forKey:@"fill circle Animation"];
    self.fillRingShape.transform = CATransform3DIdentity;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    id obj = [anim valueForKey:starKey];
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *key = (NSString *)obj;
        if ([key isEqualToString:favoriteKey]) {
            [self endFavorite];
        }else if ([key isEqualToString:notFavoriteKey]) {
            [self prepareForFavorite];
        }
    }
    [self enableTouch];
}

- (void)endFavorite {
    
    [self executeWithoutActions:^{
        self.shap.fillColor = self.shapFavoriteColor.CGColor;
        self.shap.opacity = 1;
        self.fillRingShape.opacity = 1;
        self.outerRingShape.transform = CATransform3DIdentity;
        self.outerRingShape.opacity = 0;
    }];
    
//    CAAnimationGroup *starAnimations = [[CAAnimationGroup alloc] init];
    CATransform3D starGoUp = CATransform3DIdentity;
    starGoUp = CATransform3DScale(starGoUp, 2, 2, 2);
    
    CAKeyframeAnimation *starKeyFrames =[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    starKeyFrames.values = @[
                            [NSValue valueWithCATransform3D:self.shap.transform],
                            [NSValue valueWithCATransform3D:starGoUp],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]
                            ];
    
    starKeyFrames.keyTimes = @[
                               @0.0,
                               @0.4,
                               @0.6
                               ];
    starKeyFrames.duration = 0.2;
    starKeyFrames.timingFunction = [CAMediaTimingFunction
                                    functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.shap addAnimation:starKeyFrames forKey:nil];
    self.shap.transform = CATransform3DIdentity;

}

- (void)prepareForFavorite {
    [self executeWithoutActions:^{
        self.fillRingShape.opacity = 0;
        self.fillRingShape.transform = CATransform3DMakeScale(0.2, 0.2, 0.2);
    }];
    
}

- (void)notFavorite {
    
    CABasicAnimation *starFillColor = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    starFillColor.toValue = (__bridge id)(self.notFavoriteColor.CGColor);
    starFillColor.duration = 0.3;
    
    CABasicAnimation *starOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    starOpacity.toValue = @0.5;
    starOpacity.duration = 0.3;
    
    CAAnimationGroup *starGroup = [[CAAnimationGroup alloc] init];
    starGroup.animations = @[starFillColor, starOpacity];
    
    [self.shap addAnimation:starGroup forKey:nil];
    self.shap.fillColor = self.notFavoriteColor.CGColor;
    self.shap.opacity = 0.5;
    
    CABasicAnimation *fillCircle = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fillCircle.toValue = @0;
    fillCircle.duration = 0.3;
    [fillCircle setValue:notFavoriteKey forKey:starKey];
    fillCircle.delegate = self;
    
    [self.fillRingShape addAnimation:fillCircle forKey: nil];
    self.fillRingShape.opacity = 0;
    
    CABasicAnimation *outerCircle = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outerCircle.toValue = @0.5;
    outerCircle.duration = 0.3;
    
    [self.outerRingShape addAnimation:outerCircle forKey: nil];
    self.outerRingShape.opacity = 0.5;
}

- (void)executeWithoutActions:(void (^)(void))actions {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    actions();
    [CATransaction commit];
}



- (CGRect)frameWithInset{
    return CGRectInset(self.bounds, self.lineWidth/2, self.lineWidth/2);
}


- (void)animationDidStart:(CAAnimation *)anim {
    [self disableTouch];
}


- (void)enableTouch {
    self.userInteractionEnabled = YES;
}

- (void)disableTouch {
    self.userInteractionEnabled = NO;
}







- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self updateLayerProperties];
}

- (void)setFavoriteColor:(UIColor *)favoriteColor {
    _favoriteColor = favoriteColor;
    [self updateConstraints];
}

- (void)setNotFavoriteColor:(UIColor *)notFavoriteColor {
    _notFavoriteColor = notFavoriteColor;
    [self updateConstraints];
}

- (void)setShapFavoriteColor:(UIColor *)shapFavoriteColor {
    _shapFavoriteColor = shapFavoriteColor;
    [self updateConstraints];
}

- (void)setFavorite:(BOOL)favorite {
    _favorite = favorite;
    favorite ? [self favorite] : [self notFavorite];
}




@end

