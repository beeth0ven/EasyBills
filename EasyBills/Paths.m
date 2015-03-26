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

@end
