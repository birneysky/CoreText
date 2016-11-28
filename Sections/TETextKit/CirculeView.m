//
//  CirculeView.m
//  CoreText
//
//  Created by birneysky on 16/11/28.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "CirculeView.h"

@interface CirculeView ()

@property (nonatomic,readonly) CAShapeLayer* shapeLayer;

@end

@implementation CirculeView


#pragma mark - *** override ***
+ (Class) layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer*)shapeLayer
{
    return (CAShapeLayer*)self.layer;
}

#pragma mark - *** Initializers ***

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}

- (void)configure{
    
    self.shapeLayer.frame = self.bounds;
    
    self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.strokeEnd = 0.5f;

}

- (void)setStartValue:(CGFloat)startValue
{
    _startValue = startValue;
    self.shapeLayer.strokeEnd = startValue;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.shapeLayer.lineWidth = lineWidth;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.shapeLayer.strokeColor = lineColor.CGColor;
}


- (void)setValue:(CGFloat)value
{
    _value = value;
    self.shapeLayer.strokeEnd = value;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
