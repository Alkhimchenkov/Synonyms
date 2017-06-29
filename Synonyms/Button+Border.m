//
//  Button+Border.m
//  Urbo_iOS
//
//  Created by Андрей on 07.02.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import "Button+Border.h"

NSString *const kStringKey_BorderTop    = @"borderTop";
NSString *const kStringKey_BorderBottom = @"borderBottom";
NSString *const kStringKey_BorderLeft   = @"borderLeft";
NSString *const kStringKey_BorderRight  = @"borderRight";

@interface Button_Border (PrivateMethods) <CAAnimationDelegate> {}

- (void)removeLayerByName:(NSString *)layerNameToRemove;
- (void)addAppearLayerAnimation:(CALayer *)layer;

@end

@implementation Button_Border

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth
{
    // Before to add new layer, we have to delete old one: there's not too much space for endless layers
    [self removeTopBorder];
    CALayer *border = [CALayer layer];
    // Give the layer a name to be able to remove it when needed
    border.name = kStringKey_BorderTop;
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
    [self addAppearLayerAnimation:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth
{
    [self removeBottomBorder];
    CALayer *border = [CALayer layer];
    border.name = kStringKey_BorderBottom;
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
    [self addAppearLayerAnimation:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth
{
    [self removeLeftBorder];
    CALayer *border = [CALayer layer];
    border.name = kStringKey_BorderLeft;
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
    [self addAppearLayerAnimation:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth
{
    [self removeRightBorder];
    CALayer *border = [CALayer layer];
    border.name = kStringKey_BorderRight;
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
    [self addAppearLayerAnimation:border];
}

- (void)addAllBordersWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth
{
    [self addTopBorderWithColor:color andWidth:borderWidth];
    [self addBottomBorderWithColor:color andWidth:borderWidth];
    [self addLeftBorderWithColor:color andWidth:borderWidth];
    [self addRightBorderWithColor:color andWidth:borderWidth];
}

- (void)removeTopBorder
{
    [self removeLayerByName:kStringKey_BorderTop];
}

- (void)removeBottomBorder
{
    [self removeLayerByName:kStringKey_BorderBottom];
}

- (void)removeLeftBorder
{
    [self removeLayerByName:kStringKey_BorderLeft];
}

- (void)removeRightBorder
{
    [self removeLayerByName:kStringKey_BorderRight];
}

- (void)removeAllBorders
{
    [self removeTopBorder];
    [self removeBottomBorder];
    [self removeLeftBorder];
    [self removeRightBorder];
}


#pragma mark - Private methods

- (void)removeLayerByName:(NSString *)layerNameToRemove
{
    for (CALayer *childLayer in [self.layer sublayers]) {
        if ([childLayer.name isEqualToString:layerNameToRemove]) {
            [childLayer removeFromSuperlayer];
            break;
        }
    }
}

- (void)addAppearLayerAnimation:(CALayer *)layer
{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    scaleAnim.fromValue = @(1);
    scaleAnim.toValue = @(0);
    
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    groupAnim.duration = 0.1;
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnim.removedOnCompletion = FALSE;
    groupAnim.fillMode = kCAFillModeForwards;
    groupAnim.animations = [NSArray arrayWithObjects:scaleAnim, nil];
    [layer addAnimation:groupAnim forKey: nil];
}

@end
