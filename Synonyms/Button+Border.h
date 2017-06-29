//
//  Button+Border.h
//  Urbo_iOS
//
//  Created by Андрей on 07.02.17.
//  Copyright © 2017 urbolabs.urbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Button_Border : UIButton


- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;
- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;
- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;
- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;
- (void)addAllBordersWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

- (void)removeTopBorder;
- (void)removeBottomBorder;
- (void)removeLeftBorder;
- (void)removeRightBorder;
- (void)removeAllBorders;


@end
