//
//  CGPath+Extension.m
//  CursorBarButton
//
//  Created by luojie on 3/26/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#include "CGPath+Extension.h"

CGPathRef CGPathRescaleForFrame(CGPathRef path,CGRect frame) {
    
    CGRect boundingBox = CGPathGetBoundingBox(path);
    CGFloat boundingBoxAspectRatio = CGRectGetWidth(boundingBox) / CGRectGetHeight(boundingBox);
    CGFloat viewAspectRatio = CGRectGetWidth(frame) / CGRectGetHeight(frame);
    
    CGFloat scaleFactor = 1.0;
    
    if (boundingBoxAspectRatio > viewAspectRatio) {
        scaleFactor = CGRectGetWidth(frame) / CGRectGetWidth(boundingBox);
    }else{
        scaleFactor = CGRectGetHeight(frame) / CGRectGetHeight(boundingBox);
    }
    
    CGAffineTransform scaleTransform = CGAffineTransformIdentity;
    scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor);
    scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox));
    
    
    CGSize scaleSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    CGSize centerOffset = CGSizeMake((CGRectGetWidth(frame)-scaleSize.width)/(scaleFactor*2),
                                     (CGRectGetHeight(frame)-scaleSize.height)/(scaleFactor*2));
    scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height);
    
    return CGPathCreateCopyByTransformingPath(path,&scaleTransform);
}
