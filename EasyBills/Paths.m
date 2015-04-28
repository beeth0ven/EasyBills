//
//  Paths.m
//  CursorBarButton
//
//  Created by luojie on 3/25/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#import "Paths.h"

@implementation Paths

+ (CGPathRef)cursor {
    UIBezierPath* cursorPath = UIBezierPath.bezierPath;
    [cursorPath moveToPoint: CGPointMake(1033.56, 1390.42)];
    [cursorPath addLineToPoint: CGPointMake(1012.54, 1439.53)];
    [cursorPath addLineToPoint: CGPointMake(1005.08, 1418)];
    [cursorPath addLineToPoint: CGPointMake(983.57, 1411.5)];
    [cursorPath addLineToPoint: CGPointMake(1033.56, 1390.42)];
    [cursorPath closePath];
    return cursorPath.CGPath;
}

+ (CGPathRef)heart {
    UIBezierPath* heartPath = UIBezierPath.bezierPath;
    [heartPath moveToPoint: CGPointMake(382.03, 983.94)];
    [heartPath addCurveToPoint: CGPointMake(393.28, 990.54) controlPoint1: CGPointMake(383.99, 983.94) controlPoint2: CGPointMake(387.53, 984.88)];
    [heartPath addLineToPoint: CGPointMake(396.13, 993.34)];
    [heartPath addLineToPoint: CGPointMake(398.94, 990.49)];
    [heartPath addCurveToPoint: CGPointMake(410.03, 983.92) controlPoint1: CGPointMake(402.93, 986.44) controlPoint2: CGPointMake(407.18, 983.92)];
    [heartPath addCurveToPoint: CGPointMake(419.84, 988.17) controlPoint1: CGPointMake(413.86, 983.92) controlPoint2: CGPointMake(416.89, 985.23)];
    [heartPath addCurveToPoint: CGPointMake(424.15, 998.56) controlPoint1: CGPointMake(422.62, 990.95) controlPoint2: CGPointMake(424.15, 994.63)];
    [heartPath addCurveToPoint: CGPointMake(419.81, 1008.97) controlPoint1: CGPointMake(424.15, 1002.48) controlPoint2: CGPointMake(422.62, 1006.17)];
    [heartPath addCurveToPoint: CGPointMake(397.38, 1033.17) controlPoint1: CGPointMake(419.58, 1009.21) controlPoint2: CGPointMake(407.5, 1022.24)];
    [heartPath addCurveToPoint: CGPointMake(396.07, 1033.69) controlPoint1: CGPointMake(396.9, 1033.62) controlPoint2: CGPointMake(396.35, 1033.69)];
    [heartPath addCurveToPoint: CGPointMake(394.77, 1033.18) controlPoint1: CGPointMake(395.78, 1033.69) controlPoint2: CGPointMake(395.24, 1033.62)];
    [heartPath addCurveToPoint: CGPointMake(372.34, 1008.48) controlPoint1: CGPointMake(392.3, 1030.44) controlPoint2: CGPointMake(374.42, 1010.56)];
    [heartPath addCurveToPoint: CGPointMake(368.03, 998.09) controlPoint1: CGPointMake(369.56, 1005.7) controlPoint2: CGPointMake(368.03, 1002.01)];
    [heartPath addCurveToPoint: CGPointMake(372.34, 987.71) controlPoint1: CGPointMake(368.03, 994.17) controlPoint2: CGPointMake(369.56, 990.48)];
    [heartPath addCurveToPoint: CGPointMake(382.03, 983.94) controlPoint1: CGPointMake(375.05, 985) controlPoint2: CGPointMake(378.22, 983.94)];
    [heartPath closePath];
    return heartPath.CGPath;
}

+ (CGPathRef)circleInFrame:(CGRect)frame {
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:frame];
    return circle.CGPath;
}

@end


