//
//  RippleView.m
//  Ripple
//
//  Created by rhyzx on 14-4-16.
//  Copyright (c) 2014年 rhyzx. All rights reserved.
//

#import "RippleView.h"

@interface RippleView()

- (void) ripple;
- (CAShapeLayer *) getLayer;

@property(nonatomic) NSTimer *timer;

@end

@implementation RippleView

- (void) start
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.2
                                                  target:self
                                                selector:@selector(ripple)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) stop
{
    [self.timer invalidate];
}


- (void)ripple
{
    CGRect toRect = self.bounds;
    CGRect fromRect = CGRectMake(CGRectGetMidX(toRect), CGRectGetMidY(toRect), 0.0, 0.0);
    
    CAShapeLayer *layer = [self getLayer];
    layer.path = CGPathCreateWithEllipseInRect(toRect, NULL);
    
    // shape ani
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"path"];
    ani.duration = 2.0;
    //    ani.autoreverses = YES;
    //    ani.repeatCount = CGFLOAT_MAX;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    ani.fromValue   = (__bridge id)CGPathCreateWithEllipseInRect(fromRect, NULL);
    ani.toValue     = (__bridge id)CGPathCreateWithEllipseInRect(toRect, NULL);
    
    ani.delegate = self;
    [ani setValue:layer forKey:@"layer"];
    
    [layer addAnimation:ani forKey:ani.keyPath];
    
    // fade ani
    CABasicAnimation *fadeAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAni.duration = 2.0;
    fadeAni.fromValue = @1.0;
    fadeAni.toValue = @0.0;
    
    [layer addAnimation:fadeAni forKey:fadeAni.keyPath];
    
    [self.layer addSublayer:layer];
}

- (CAShapeLayer *) getLayer
{
    // TODO restore layer
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [[UIColor whiteColor] CGColor];
    layer.fillColor = nil;
    layer.lineWidth = 1.0;
    layer.opacity = 0.0;
    
    return layer;
}

#pragma mark - CAAnimation delegage
// remove and restore layer
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    CAShapeLayer *layer = [theAnimation valueForKey:@"layer"];
    if (layer) {
        [layer removeFromSuperlayer];
        // TODO store layer
    }
}

@end
